Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbYEWPzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbYEWPzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYEWPz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:55:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52886 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751679AbYEWPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:55:27 -0400
Date: Fri, 23 May 2008 16:39:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: corbet@lwn.net (Jonathan Corbet)
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080523163956.6e93746c@core>
In-Reply-To: <9027.1211551014@vena.lwn.net>
References: <20080522223700.2f103a14@core>
	<9027.1211551014@vena.lwn.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On the other hand, the next level of BKL pushdown would be painful as
> all hell, given the massive number of callbacks in the V4L2 API.  So I'm
> thinking it might be justified to create a video_ioctl2_locked() for
> V4L2 drivers which are not yet known to be safe in the absence of the
> BKL.  The amount of extra code would be quite small, and it would let
> safe drivers operate BKL-free.

The problem is that currently they are almost all unsafe - I did a quick
survey as part of the changes. Pushing it down to the video2_ioctl is a
starting point, but the v4l layer is going to need a lot of love and its
own gradual migration.

Right now we've gone from BKL buried in fs to BKL at top of v4l layer
which is indeed only a starting point. I'd assumed the same as you are
think a new video_ioctl2 and switching drivers one by one (I was assuming
adding video2_ioctl_unlocked())

Alan
