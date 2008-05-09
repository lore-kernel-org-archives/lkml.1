Return-Path: <linux-kernel-owner+w=401wt.eu-S933227AbYEIG0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227AbYEIG0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbYEIG0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:26:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59784
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754244AbYEIG0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:26:10 -0400
Date: Thu, 08 May 2008 23:26:02 -0700 (PDT)
Message-Id: <20080508.232602.193723628.davem@davemloft.net>
To: jengelh@medozas.de
Cc: linux-kernel@vger.kernel.org, adaplas@pol.net, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.26-rcX VC console scrolling regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.1.10.0805081236190.16904@fbirervta.pbzchgretzou.qr>
References: <20080507.214637.193700986.davem@davemloft.net>
	<alpine.LNX.1.10.0805081236190.16904@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>
Date: Thu, 8 May 2008 13:50:57 +0200 (CEST)

> My guess is that you see the effects of incomplete font table/position
> switching, something along the lines a `cat /dev/urandom` would cause.
> Using the very same kernel and boot params (vga=791 or anything to
> switch it to fbcon), I cannot trigger the problem on opensuse.

Jan, there is code in drivers/video/console/fbcon.c:fbcon_do_set_font()
which makes changes to vc->vc_video_erase_char, maybe that code needs
to update the new vc->vc_scrl_erase_char you added?

It would be nice if you could audit the tree to see if any other cases
have been missed like this as well.
