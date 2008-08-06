Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYHHGT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYHHGT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYHHGTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:19:45 -0400
Received: from ozlabs.org ([203.10.76.45]:48340 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYHHGTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:19:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fernando Luis =?utf-8?q?V=C3=A1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: request->ioprio
Date: Thu, 7 Aug 2008 06:33:05 +1000
User-Agent: KMail/1.9.9
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
References: <1218014196.4419.44.camel@sebastian.kern.oss.ntt.co.jp>
In-Reply-To: <1218014196.4419.44.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808070633.06112.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008 19:16:36 Fernando Luis Vázquez Cao wrote:
> Hi Jens, Rusty,

Hi Fernando,

> Trying to implement i/o tracking all the way up to the page cache (so
> that cfq and the future cgroup-based I/O controllers can schedule
> buffered I/O properly) I noticed that struct request's ioprio is
> initialized but never used for I/O scheduling purposes. Indeed there
> seems to be one single user of this member: virtio_blk.

Hey, do I win a prize? :)

> Virtio uses 
> struct request's ioprio in the request() function of the virtio block
> driver, which just copies the ioprio value to the output header of
> virtblk_req.

Yes, we pass it through to the host, in the assumption they might want to use 
it to schedule our I/Os relative to each other.

I'm a little surprised noone else uses it, but I'm sure they will...
Rusty.
