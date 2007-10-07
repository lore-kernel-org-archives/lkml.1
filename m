Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbXJGXBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbXJGXBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 19:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbXJGXBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 19:01:35 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54441 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbXJGXBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 19:01:34 -0400
Date: Mon, 8 Oct 2007 01:01:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
 usage"
In-Reply-To: <20071007230250.GV22435@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0710080059500.16301@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>
 <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu>
 <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu>
 <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu>
 <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu>
 <20071007211154.GA27685@elte.hu> <20071007230250.GV22435@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 8 2007 01:02, Oleg Verych wrote:
>
>If you are not going to see OOPes of new kernels running old distros, ask
>any perl hacker (as they lovely mentioned in lkml) to hack for you
>something like:
>
>sed -u -e '
>/^<1/s_^_'$COLOR1'_
>/^<2/s_^_'$COLOR2'_
>/^<3/s_^_'$COLOR3'_
>/^<4/s_^_'$COLOR4'_
>/^<5/s_^_'$COLOR5'_
>/^<6/s_^_'$COLOR6'_
>/^<7/s_^_'$COLOR7'_
>' < /proc/kmsg >/dev/tty
>
>place whole that perl shit on initrams of your kernel, run it in
>background as early as possible with switched off default console output
>(i.e. quiet boot).
>
>OVER.

Speaking of over, this does not fly at all. If you call panic(),
for whatever reason you want, then the printk() is the last thing
that happens after that, you can declare userspace dead.
On oopses, it depends on their severity. Eventually procfs goes
whoops and the kmsg transmission mechanism does not work, and oh,
userspace can't help it.
