Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYAGIeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYAGIeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 03:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYAGIeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 03:34:13 -0500
Received: from ozlabs.org ([203.10.76.45]:46486 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbYAGIeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 03:34:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Mon, 7 Jan 2008 19:34:01 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <200712191731.26512.rusty@rustcorp.com.au> <200801071628.11381.rusty@rustcorp.com.au> <4781C8B5.6050207@gmail.com>
In-Reply-To: <4781C8B5.6050207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801071934.01597.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008 17:37:41 Tejun Heo wrote:
> Rusty Russell wrote:
> > Hi Tejun,
> >
> >    Nice try!  Even ignoring the ugliness of undoing such an operation if
> > the caller doesn't expect you to mangle their chains, consider a
> > one-element sg array. :(
>
> Heh heh, that can be dealt with by skipping the first chain if the first
> chain is empty after chaining.  Please take a look at
> ata_sg_setup_extra() in the following.
>
> http://git.kernel.org/?p=linux/kernel/git/tj/libata-dev.git;a=blob;f=driver
>s/ata/libata-core.c;h=32dde5bbc75ed53e89ac17040da2cd0621a37161;hb=c8847e473a
>4a2844244784226eb362be10d52ce9
>
> That said, yeah, it's seriously ugly.  Restoring the original sg is ugly
> too.  I definitely agree that we need some improvements here.

Erk, that's beyond ugly, into actual evil.

To make this general you need to find the last N 1-element chains (but SCSI 
doesn't do this of course).  Oh the horror...

I'd be remiss if I didn't mention that the sg_ring ata patches were 
straightforward, and indescribably beautiful if compared to this!

Thanks,
Rusty.
