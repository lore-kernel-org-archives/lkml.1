Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbXFBPM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbXFBPM6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 11:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbXFBPMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 11:12:51 -0400
Received: from heineken.digium.com ([216.207.245.2]:54660 "EHLO
	heineken.digium.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbXFBPMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 11:12:50 -0400
Date: Sat, 2 Jun 2007 10:12:46 -0500 (CDT)
From: Matt Fredrickson <creslin@digium.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Lee Revell <rlrevell@joe-job.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com
Message-ID: <15604445.159241180797166445.JavaMail.root@jupiler.digium.com>
In-Reply-To: <12467610.159201180797054019.JavaMail.root@jupiler.digium.com>
Subject: Re: Device Driver Etiquette
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [68.62.219.187]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Daniel J Blueman" <daniel.blueman@gmail.com> wrote:
> On 1 Jun, 19:40, "Lee Revell" <rlrevell@joe-job.com> wrote:
> > On 6/1/07, Matthew Fredrickson <creslin@digium.com> wrote:
> >
> > > is it acceptable (although
> > > not nice) to simply fix it this way, by disabling irqs while it
> loads
> > > the firmware?
> >
> > I would say to just disable IRQs while loading firmware.  Almost
> every
> > server I maintain has some vendor driver which generates a "many
> lost
> > ticks!" message on load.  As long as it's only done at module load
> > time it should be fine.
> 
> For anything ~10s or more, you'll probably also need to call the
> timer
> update function to prevent soft lockup warning being generated.

Ahhh... so there is a way to get rid of that cursed message.  I forgot to mention this in my original message, the only place that I had seen this problem is on a certain machine (Dell 2950) with a certain distribution (FC6) kernel.  I had trimmed the code down to fit in 4K stacks already quite a bit.

I believe what actually made it crash and overflow the stack (the straw that breaks the camels back, so to speak) was the intermittent triggering of the softlockup detector.  I think if I can disable that while the firmware is loading that will fix the stack overflow issues and correct my problem.

Matthew Fredrickson
