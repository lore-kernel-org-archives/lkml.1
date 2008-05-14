Return-Path: <linux-kernel-owner+w=401wt.eu-S1763091AbYENOz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763091AbYENOz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762920AbYENOzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:55:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:49058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762910AbYENOzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:55:39 -0400
From: Andreas Schwab <schwab@suse.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to `strlen'
References: <Pine.LNX.4.64.0805140958400.5778@anakin>
	<jeprrpth5m.fsf@sykes.suse.de>
	<20080514141056.GB19909@cs181133002.pp.htv.fi>
	<jeabitt0xj.fsf@sykes.suse.de> <20080514144031.GA6902@cvg>
X-Yow: ..  Now KEN and BARBIE are PERMANENTLY ADDICTED to MIND-ALTERING DRUGS..
Date: Wed, 14 May 2008 16:55:37 +0200
In-Reply-To: <20080514144031.GA6902@cvg> (Cyrill Gorcunov's message of "Wed,
	14 May 2008 18:40:31 +0400")
Message-ID: <je63thszo6.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> I think it would help to see ..tmp_vmlinux1.cmd to ensure for inclusion
> of lib/lib.a. strlen was there without my patch as Andreas already pointed,
> I've just added strncat wich is coming from lib/string.o for this arch.

Actually the way strncat is used here is broken anyway, it does not
prevent array overrun.  The third argument of strncat only limits the
amount of characters copied, without taking into account the length of
the string already in the buffer.  Consequently gcc has optimized the
call to strncat into a simple call to strcat, since none of the copied
strings are longer than sizeof(msgbuf).  This strcat call is then
expanded to include a call to strlen.

So a better fix would probably be to make msgbuf big enough and use
strcat instead.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
