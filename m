Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbZGYUMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbZGYUMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 16:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZGYUMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 16:12:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55298 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbZGYUMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:12:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Regression] kdesu broken
Date: Sat, 25 Jul 2009 22:12:48 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ray Lee <ray-lk@madrabbit.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200907240145.31935.rjw@sisk.pl> <87ws5xjo2x.fsf@devron.myhome.or.jp> <20090725150510.35e8854d@lxorguk.ukuu.org.uk>
In-Reply-To: <20090725150510.35e8854d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907252212.49045.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 July 2009, Alan Cox wrote:
> Actually try this:
> 
> 
> commit b0e6bdde87725a5d46273ecc4bd00c54bd675848
> Author: Alan Cox <alan@linux.intel.com>
> Date:   Sat Jul 25 15:00:04 2009 +0100
> 
>     pty: ensure writes hit the reader before close
>     
>     This is elegant in all the wrong ways. Put the pty into low latency mode (which
>     we can do as we always post bytes from user context). The tty_flip_buffer_push
>     then always calls into the ldisc which means we clear the ldisc buffer before
>     we set the TTY_OTHER_CLOSED flag.
>     
>     Means pty has subtle knowledge of tty internals we really don't want it to, but
>     it fixes the problem for the moment.
>     
>     Signed-off-by: Alan Cox <alan@linux.intel.com>

Works for me, thanks!

Best,
Rafael
