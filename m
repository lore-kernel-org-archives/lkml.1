Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYEIVzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYEIVzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbYEIVzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 17:55:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51450
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbYEIVza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 17:55:30 -0400
Date: Fri, 09 May 2008 14:55:24 -0700 (PDT)
Message-Id: <20080509.145524.193685795.davem@davemloft.net>
To: jengelh@medozas.de
Cc: linux-kernel@vger.kernel.org, adaplas@pol.net, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.26-rcX VC console scrolling regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.1.10.0805092124010.28042@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0805081236190.16904@fbirervta.pbzchgretzou.qr>
	<20080508.232602.193723628.davem@davemloft.net>
	<alpine.LNX.1.10.0805092124010.28042@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>
Date: Fri, 9 May 2008 21:24:20 +0200 (CEST)

> 
> On Friday 2008-05-09 08:26, David Miller wrote:
> >> My guess is that you see the effects of incomplete font table/position
> >> switching, something along the lines a `cat /dev/urandom` would cause.
> >> Using the very same kernel and boot params (vga=791 or anything to
> >> switch it to fbcon), I cannot trigger the problem on opensuse.
> >
> >Jan, there is code in drivers/video/console/fbcon.c:fbcon_do_set_font()
> >which makes changes to vc->vc_video_erase_char, maybe that code needs
> >to update the new vc->vc_scrl_erase_char you added?
> >
> >It would be nice if you could audit the tree to see if any other cases
> >have been missed like this as well.
> >
> Try this patch please.

That seems to fix the bug, thanks Jan.

Acked-by: David S. Miller <davem@davemloft.net>
