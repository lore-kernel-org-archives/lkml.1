Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYE1Ifp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYE1Ifp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 04:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYE1Ifh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 04:35:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbYE1Ifg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 04:35:36 -0400
Date: Wed, 28 May 2008 04:34:13 -0400
From: Alan Cox <alan@redhat.com>
To: Andy Walls <awalls@radix.net>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080528083413.GB30339@devserv.devel.redhat.com>
References: <20080527101039.1c0a3804@gaivota> <20080527094144.1189826a@bike.lwn.net> <20080527133100.6a9302fb@gaivota> <20080527103755.1fd67ec1@bike.lwn.net> <20080527155942.7693c360@gaivota> <412bdbff0805271226t41fe55b0jd0b8e3c737f34734@mail.gmail.com> <20080527180048.6a27dbf7@gaivota> <1211932138.3197.29.camel@palomino.walls.org> <412bdbff0805271746x3db9ae28h3c0f0b565f50d4c6@mail.gmail.com> <1211942221.3197.154.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211942221.3197.154.camel@palomino.walls.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 10:37:01PM -0400, Andy Walls wrote:
> I note the man page for open() doesn't list EBUSY as a valid errno.
> However, the V4L2 API Spec does list EBUSY as a valid errno for V4L2
> open().

The posix spec doesn't limit the errors returnable this way - it says if
the error is one of the ones listed it must return the error code stated so
EBUSY is just fine.

> But in this case I can't.  The driver probably shouldn't hold a lock and
> suspend an open() indefinitely (IMO).  It should say the device is BUSY

Agreed - especially if it is opened with O_NDELAY
