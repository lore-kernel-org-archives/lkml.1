Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbXJGTOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbXJGTOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbXJGTN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:13:58 -0400
Received: from 1wt.eu ([62.212.114.60]:2815 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbXJGTN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:13:57 -0400
Date: Sun, 7 Oct 2007 21:13:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Verych <olecom@flower.upol.cz>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:' usage"
Message-ID: <20071007191309.GS10199@1wt.eu>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470929D8.80003@keyaccess.nl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2007 at 08:47:52PM +0200, Rene Herman wrote:
> On 10/07/2007 06:12 PM, Ingo Molnar wrote:
> 
> >* Oleg Verych <olecom@flower.upol.cz> wrote:
> 
> >>Coloring isn't useful. If it was, it would be implemented ~16 years
> >>ago.
> >
> >Congratulations, this is the most stupid argument i've ever read on 
> >lkml.
> 
> "Ay. World is finished. Everyone can go home and watch Friends reruns now."
> 
> But well, there actually have been worse arguments given that VGA console 
> is getting less and less important. I recently did a perusal of alternative 
> distributions and didn't find a single one that didn't default to having a 
> splash screen hide the kernel during boot (and if I'm not mistaken, only 
> one of them provided me with the option during installation to not boot 
> into X immediately afterwards).

I don't recall having seen any splash screen on Slackware. And fortunately,
the mainstream distros still provide the option to boot in text mode.

> Sure, that in itself needn't necesarily be of concern to anyone who, err, 
> is not concerned but any such colouring feature appearing when there's only 
> a smathering of people left that still cares about the VGA console in the 
> first place really isn't all _that_ far out as an argument...

There are two distinct populations :
  - those who are afraid of boot messages and prefer "splash" screens.
    Those people are most common users, grown in non-IT environments. They
    are happy to see a big logo on their BIOS to hide important boot errors,
    and they are the ones who would never have imagined that pressing Escape
    during the boot of windows 3.1/95 provided them with the full text
    messages. Basically, they want to ensure they will never have to worry
    about things they don't understand.

  - those who are troubleshooting their system in the early stages (kernel,
    filesystems, network, services, ...). These ones *need* boot messages.
    And there, depending on the hardware, sometimes the FB is better because
    it shows larger lines, sometimes it's worse because the scrollback is
    limited by too low memory.

I personally fit in the second category. And I'm sure most people on this
list do. I would be miserably sad if I couldn't get my boot messages
anymore. It already irritates me a lot to loose the ones displayed before
switching to frame-buffer when a hang happens just afterwards...

I would say that while I'm not particularly fond of flashy colors
everywhere, I think that being able to use colors to indicate particular
actions in progress or conditions can be a good thing. RAID errors,
devices disabled due to command-line parameters, and general anomalies
which can cause a hang or panic a few line laters are worth coloring.
And I don't believe in userland's help here, because for that type of
messages, the indication should be returned immediately. For instance,
anyone who has experienced read errors on and IDE disk knows that it
can literally take hours/days to boot, after displaying thousands of
messages. Here, having the ability to see that no IRQ was assigned or
something like this could help.

Regards,
Willy

