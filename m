Return-Path: <linux-kernel-owner+w=401wt.eu-S1764969AbXESXZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764969AbXESXZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 19:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbXESXZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 19:25:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758503AbXESXZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 19:25:22 -0400
Date: Sat, 19 May 2007 16:22:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: RFC: kconfig select warnings bogus?
Message-Id: <20070519162239.1bcb03d6.akpm@linux-foundation.org>
In-Reply-To: <20070519230537.GI6291@stusta.de>
References: <20070519151523.GA26724@uranus.ravnborg.org>
	<20070519110944.2a52061e.akpm@linux-foundation.org>
	<20070519230537.GI6291@stusta.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 01:05:37 +0200 Adrian Bunk <bunk@stusta.de> wrote:

> Look for example at the last one in drivers/input/mouse/Kconfig:
> 
> config MOUSE_ATARI
>         tristate "Atari mouse"
>         depends on ATARI
>         select ATARI_KBD_CORE
> 
> This is perfectly correct (the select'ed symbol is only unavailable when 
> the dependency can't be fulfilled), and all things to "fix" the warning 
> will make it worse.

If ATARI is unset then we shouldn't be generating the "'select' used by
config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'"
warnings, should we?

