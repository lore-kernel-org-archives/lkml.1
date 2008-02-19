Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbYBSVsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbYBSVsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbYBSVry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:47:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:59696 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753940AbYBSVrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:47:53 -0500
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX18IaHEBUtEIxAfyOK1e6cZe8rmzMmCfZiXexTGB2Z
	i3ey1+Odc9kmLk
Subject: Re: [PATCH] splice: fix problem with sys_tee and SPLICE_F_NONBLOCK
From: Johann Felix Soden <johfel@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Johann Felix Soden <johfel@gmx.de>, Patrick McManus <mcmanus@ducksong.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080219212530.GN23197@kernel.dk>
References: <1203452091.7758.5.camel@localhost>
	 <20080219202543.GK23197@kernel.dk> <1203455538.7758.17.camel@localhost>
	 <20080219212530.GN23197@kernel.dk>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 22:47:41 +0100
Message-Id: <1203457661.7758.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Dienstag, den 19.02.2008, 22:25 +0100 schrieb Jens Axboe:
> On Tue, Feb 19 2008, Johann Felix Soden wrote:
> > > On Tue, Feb 19 2008, Johann Felix Soden wrote:
> > > > From: Johann Felix Soden <johfel@users.sourceforge.net>
> > > > 
> > > > With SPLICE_F_NONBLOCK sys_tee should return number of duplicated bytes,
> > > > not only -EAGAIN on success.
> > > 
> > > ?
> > > 
> > > The current behaviour is to return bytes tee'd, or return -EAGAIN for
> > > zero bytes if SPLICE_F_NONBLOCK is set. It doesn't return "-EAGAIN on
> > > success", not sure what you mean there.
> > > 
> > Sorry, my patch description was not correct. 
> > 
> > The new behavior of sys_tee with my patch is: 
> > 	- return -EAGAIN if there are no data in the pipe, but writer
> > 	  connected to the pipe, 
> > 	- return 0 if there are not writers connected
> > 	- else return number of duplicated byte 
> > 
> > The old behavior was: return -EAGAIN or the number (>0) of duplicated
> > bytes.
> 
> Your patch has an odd way of achieving that goal, modify the real
> location of the assignment instead of overriding something. That has the
> potential to turn into another confusing bug later on, wondering why the
> heck your return value isn't being passed back.
> 
> Improvement is welcome though, you can't distuingish -EAGAIN on the
> input side from the output side currently.
> 

I thought again about the problem and my patch: you are right, the patch
is nonsense. I have learnt, that the correctness of a patch is not
guaranteed by the (bad, but anyhow working) solution of the problem the
patch was written for.
Sorry for wasting your time.
--
 J. F. Soden


