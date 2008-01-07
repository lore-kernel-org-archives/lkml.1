Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYAGF2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYAGF2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 00:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYAGF2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 00:28:25 -0500
Received: from ozlabs.org ([203.10.76.45]:53954 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYAGF2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 00:28:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Mon, 7 Jan 2008 16:28:10 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <200712191731.26512.rusty@rustcorp.com.au> <200801071538.58875.rusty@rustcorp.com.au> <4781B234.7070805@gmail.com>
In-Reply-To: <4781B234.7070805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801071628.11381.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008 16:01:40 Tejun Heo wrote:
> > But we hit the same problems:
> >
> > 1) sg_chain loses information.  The clever chain packaging makes reading
> > easy, but manipulation is severely limited.  You can append to your own
> > chains by padding, but not someone elses.  This works for SCSI, but what
> > about the rest of us?  And don't even think of joining mapped chains: it
> > will almost work.
>
> You can append by allocating one more element on the chain to be
> appended and moving the last element of the first chain to it while
> using the last element for chaining.

Hi Tejun,

   Nice try!  Even ignoring the ugliness of undoing such an operation if the 
caller doesn't expect you to mangle their chains, consider a one-element sg 
array. :(

Cheers,
Rusty.
