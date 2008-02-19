Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYBSVZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYBSVZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYBSVZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:25:36 -0500
Received: from brick.kernel.dk ([87.55.233.238]:12240 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbYBSVZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:25:35 -0500
Date: Tue, 19 Feb 2008 22:25:30 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Johann Felix Soden <johfel@gmx.de>
Cc: Patrick McManus <mcmanus@ducksong.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: fix problem with sys_tee and SPLICE_F_NONBLOCK
Message-ID: <20080219212530.GN23197@kernel.dk>
References: <1203452091.7758.5.camel@localhost> <20080219202543.GK23197@kernel.dk> <1203455538.7758.17.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203455538.7758.17.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19 2008, Johann Felix Soden wrote:
> > On Tue, Feb 19 2008, Johann Felix Soden wrote:
> > > From: Johann Felix Soden <johfel@users.sourceforge.net>
> > > 
> > > With SPLICE_F_NONBLOCK sys_tee should return number of duplicated bytes,
> > > not only -EAGAIN on success.
> > 
> > ?
> > 
> > The current behaviour is to return bytes tee'd, or return -EAGAIN for
> > zero bytes if SPLICE_F_NONBLOCK is set. It doesn't return "-EAGAIN on
> > success", not sure what you mean there.
> > 
> Sorry, my patch description was not correct. 
> 
> The new behavior of sys_tee with my patch is: 
> 	- return -EAGAIN if there are no data in the pipe, but writer
> 	  connected to the pipe, 
> 	- return 0 if there are not writers connected
> 	- else return number of duplicated byte 
> 
> The old behavior was: return -EAGAIN or the number (>0) of duplicated
> bytes.

Your patch has an odd way of achieving that goal, modify the real
location of the assignment instead of overriding something. That has the
potential to turn into another confusing bug later on, wondering why the
heck your return value isn't being passed back.

Improvement is welcome though, you can't distuingish -EAGAIN on the
input side from the output side currently.

-- 
Jens Axboe

