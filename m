Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYEHLvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYEHLvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 07:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYEHLu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 07:50:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44371 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYEHLu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 07:50:58 -0400
Date: Thu, 8 May 2008 13:50:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, adaplas@pol.net, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.26-rcX VC console scrolling regression
In-Reply-To: <20080507.214637.193700986.davem@davemloft.net>
Message-ID: <alpine.LNX.1.10.0805081236190.16904@fbirervta.pbzchgretzou.qr>
References: <20080507.214637.193700986.davem@davemloft.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-08 06:46, David Miller wrote:
>
>Causes garbage characters to appear at the end of lines on my VCs when
>scrolling.
>
(Gotten past the initramfs now..)
>They look like lowercase 'c' characters with a '.' above them, and they
>are colored light blue.  The rest of the console text is fine.
>I think it might be because my VC gets put into a UTF8 mode or something
>like that via the init scripts?  It seems to start happening right when
>the init scripts print "Setting up console font and keymap", which seems
>to come from /etc/init.d/console-setup which runs /bin/setupcon
>This is with a stock Ubuntu 7.10 installation.

I "reproduced" it this way on Ubuntu on i386 with fbcon (which you
are likely to be using on sparc64), when switching from a 256 to
512-glyph font. So far, only Ubuntu seems to exhibit this problem,
I am going to test Fedora for its fitness now.

# Right after boot...
	showconsolefont
# Trigger
	setfont Arabic-VGA16
	showconsolefont

# Resolve bug with 'reset'
	reset
	while $not_scrolled; do
		showconsolefont
	done;

My guess is that you see the effects of incomplete font table/position
switching, something along the lines a `cat /dev/urandom` would cause.
Using the very same kernel and boot params (vga=791 or anything to
switch it to fbcon), I cannot trigger the problem on opensuse.
