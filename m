Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbXJGWsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbXJGWsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 18:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXJGWsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 18:48:43 -0400
Received: from barikada.upol.cz ([158.194.242.200]:55055 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbXJGWsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 18:48:42 -0400
Date: Mon, 8 Oct 2007 01:02:50 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, Rene Herman <rene.herman@keyaccess.nl>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:' usage"
Message-ID: <20071007230250.GV22435@flower.upol.cz>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu> <20071007211154.GA27685@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071007211154.GA27685@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2007 at 11:11:54PM +0200, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > I would say that while I'm not particularly fond of flashy colors 
> > everywhere, I think that being able to use colors to indicate 
> > particular actions in progress or conditions can be a good thing. RAID 
> > errors, devices disabled due to command-line parameters, and general 
> > anomalies which can cause a hang or panic a few line laters are worth 
> > coloring. And I don't believe in userland's help here, because for 
> > that type of messages, the indication should be returned immediately. 
> > For instance, anyone who has experienced read errors on and IDE disk 
> > knows that it can literally take hours/days to boot, after displaying 
> > thousands of messages. Here, having the ability to see that no IRQ was 
> > assigned or something like this could help.
> 
> Exactly. I'm also testing older distros quite regularly with new kernels 
> and there's it's useful to have an impression of a kernel's output at a 
> glance.

> Adding _any_ userspace change (even if i wanted to do it, which i dont)
> is out of question.

TERM=linux attribute escape codes did not change for a decade (or so).

Making greping and coloring in userspace by means of klibc (+ GNU sed)
and initramfs will solve this easily, provided there's useful
kernel->console[userspace] interface. Ugly hacks, like those patches,
aren't for my view of an useful feature.

> So these are distinct, well-defined usecases that nobody has brought
> any coherent argument against yet. VGA isnt going away anytime soon,
> certainly not on my testboxes.

If you are not going to see OOPes of new kernels running old distros, ask
any perl hacker (as they lovely mentioned in lkml) to hack for you
something like:

sed -u -e '
/^<1/s_^_'$COLOR1'_
/^<2/s_^_'$COLOR2'_
/^<3/s_^_'$COLOR3'_
/^<4/s_^_'$COLOR4'_
/^<5/s_^_'$COLOR5'_
/^<6/s_^_'$COLOR6'_
/^<7/s_^_'$COLOR7'_
' < /proc/kmsg >/dev/tty

place whole that perl shit on initrams of your kernel, run it in
background as early as possible with switched off default console output
(i.e. quiet boot).

OVER.

For really good output it would be better to have escape code to
serialize printing, thus no coloring brain damage will appear in
concurrent writes on the tty (multiple areas, cursor movements). And this
is only start of what can be done here.
____
