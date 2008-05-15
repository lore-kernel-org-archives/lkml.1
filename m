Return-Path: <linux-kernel-owner+w=401wt.eu-S1764257AbYEOSvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764257AbYEOSvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbYEOSuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:50:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:36806 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbYEOSuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:50:22 -0400
Date: Thu, 15 May 2008 20:49:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Michelle Konzack <linux4michelle@tamay-dogan.net>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: Hardware designt to prevent Damages... [WAS: [patch 23/37]
 i2c-piix4: Blacklist two mainboards]
Message-ID: <20080515204955.7f877be8@hyperion.delvare>
In-Reply-To: <20080514195253.GB5673@freenet.de>
References: <20080513200453.064446337@mini.kroah.org>
	<20080513201225.GX31167@suse.de>
	<20080514195253.GB5673@freenet.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 21:52:53 +0200, Michelle Konzack wrote:
> Am 2008-05-13 13:12:25, schrieb Greg KH:
> > We had a report that running sensors-detect on a Sapphire AM2RD790
> > motherbord killed the CPU. While the exact cause is still unknown,
> > I'd rather play it safe and prevent any access to the SMBus on that
> > machine by not letting the i2c-piix4 driver attach to the SMBus host
> > device on that machine. Also blacklist a similar board made by DFI.
> ------------------------ END OF REPLIED MESSAGE ------------------------
> 
> Hell, since I do not depend on LOW-BUDGET, I have  never  killed  a  CPU
> even by SICK programming even my SuperSparc CPU survived.
> 
> Please can anyone advice me, about VERY VERY  good  Hardware  design  to
> prevent its destruction by software Errors?
> 
> You can even send me examples of such broken Hardware...

In this particular case, the CPU was apparently damaged as the result
of accidental memory over-voltage. It is worth noting though that said
CPU had gone through intensive overclocking session beforehand, and
this might explain the death. Other CPUs are known to have gone through
the same experience and are still working.

So, to clear up any misunderstanding: the CPU damage did not occur
because we used some odd CPU instruction sequence or anything like
that. The damage came to the CPU from other hardware on the board.

To be a bit more technical, the design mistake (I think) that was made
by the designers of the motherboard in question, was to use an
I2C/SMBus chip on a PC motherboard, which uses SMBus receive byte and
SMBus send byte for control, and which lives at an I2C address which is
very common amongst hardware monitoring chip. The 4th factor being, of
course, that improperly programming the chip in question can result in
hardware damage. If only 3 of these 4 factors had been present, most
probably there would have been no issue in practice. But with all 4
factors, bad things just had to happen. And it's not just Linux, users
had similar problems running hardware monitoring tools under Windows
too.

-- 
Jean Delvare
