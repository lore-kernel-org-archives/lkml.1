Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbXJGSNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbXJGSNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 14:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXJGSNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 14:13:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:36467 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbXJGSNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 14:13:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:x-url:organization:user-agent:sender;
        b=Em5KfVgrARivazIn76UCOYUv0FecFoQ38x9ZGRGpVK44sHe+A56ZX16JRTBwhdacx8cWak5EYwOahalq3aIyGuAF2BARNvrJOGWecgs4IkJTTjgkU6mXcoASbEiNxn9VBRdDGny5/evQkRJK+0Ma5zeoAuD4MoE5kQmRTK+iKaw=
Date: Sun, 7 Oct 2007 15:11:01 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Valdis.Kletnieks@vt.edu, Oleg Verych <olecom@flower.upol.cz>,
       Ingo Molnar <mingo@elte.hu>, Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: NAK nettiquete (was Re: "Re: [PATCH 0/2] Colored kernel output
	(run2)"
Message-ID: <20071007181101.GB6673@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Valdis.Kletnieks@vt.edu,
	Oleg Verych <olecom@flower.upol.cz>, Ingo Molnar <mingo@elte.hu>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
	Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
	Helge Deller <deller@gmx.de>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <2614.1191766530@turing-police.cc.vt.edu> <20071007161222.1b758f2f@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071007161222.1b758f2f@the-village.bc.nu>
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Oct 07, 2007 at 04:12:22PM +0100, Alan Cox escreveu:
> > The few times I've tried to NAK something outright, I've always tried to attach
> > plenty of technical explanation 
> 
> Fair comment to my "silly" response
> 
> The problems I see are
> 
> - We run on a lot more than VGA PC consoles
> - We have serial consoles (which may or may not be VT132/ANSI compliant)
> - The printk paths are run at IRQ time ASAP to get messages to console,
> that could mean we split existing colour escape code processing and the
> like.
> - People redirect the console feed other places via ioctl. Some of them
> parse "<%d>" as the start
> 
> But most importantly:
> 
> - If you want to do "pretty" boot up you do it in X or frame buffer
> (which is going to get easier and easier with the X shift to kernel side
> video support)
> - If you want to do a coloured display after boot then this is a matter
> for your logging tools
> 
> As with translation the kernel is the wrong place to do this work.
> 
> What I would much rather people thought about was
> 
> - Marker modes for translation (so you know which bits of a message are
> formatted up)
> - More consistency on the use of "name: blah" to make it easier to parse
> - Turning more messages from kernel logs to events when it makes sense
> (eg "Disk Full", "Media Error", "CPU on fire")
> 
> So if you want to do a pretty boot, then solve the big picture, the
> framebuffer initrd graphical boot, the boot display, the combining of
> artwork and messages in user space from initrd run code.
> 
> 'leet kernel messages in flashing red are not really the problem that
> needs solving to do this.

Its kinda like we pronounce printk dead for first level error reporting.
We are getting more and more closer to that with all the macros that do
just that... I'm not following kernel development as I think I should
be, but...:

dev_printk
dev_dbg
dev_vdbg
DCCP_WARN
DCCP_CRIT
DCCP_PR_DEBUG
LIMIT_NETDEBUG

With some more researching I'm sure I'd find more printk wrappers. But I
guess this should make some sort of point: using these wrappers get us
closer to what Alan wants: consistent printk messages. Such that the
life of kcolorls like wrappers get to the point that the life of user
level debugging loggers can jump and shout in happiness for providing
even nifty popup messages on "modern desktops".

As if the problem with modern desktops (or server consoles) was just
that... gimme a way to configure wpa-psk on my brand new company
notebook without having to resort to, ugh, command line assistance...
Bluetooth without having to manually do "service bluetooth start"...

- Arnaldo

P.S.: I know that that is just in the making, dbus and a lot of other
buzzwords that keep promising to solve these kinds of problems :-)
