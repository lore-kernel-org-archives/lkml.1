Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbXEUAZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbXEUAZa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 20:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbXEUAZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 20:25:25 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1254 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321AbXEUAZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 20:25:24 -0400
Date: Mon, 21 May 2007 02:25:35 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: RFC: kconfig select warnings bogus?
In-Reply-To: <20070519151523.GA26724@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0705210215170.1817@scrub.home>
References: <20070519151523.GA26724@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 19 May 2007, Sam Ravnborg wrote:

> We see a lot of these lately:
>   GEN     /home/bor/build/linux-2.6.22/Makefile
> scripts/kconfig/conf -s arch/i386/Kconfig
> drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol 'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
> drivers/net/Kconfig:2283:warning: 'select' used by config symbol 'UCC_GETH' refers to undefined symbol 'UCC_FAST'
> drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> 
> 
> Do this warning really add any value or should we just ignore them like this?

The problem is that a select operation on a non bool/tristate symbol is 
undefined. A runtime error would probably be even more ignored than this.
"Proving" that this select can't be activated is theoretically possible, 
but not really practical. An alternative might be to reverse the 
dependency again and let it act like a "depends on".
Just removing the warning is definitely not the right answer.

bye, Roman
