Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbXLDMnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbXLDMnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbXLDMnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:43:10 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38384 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbXLDMnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:43:08 -0500
Date: Tue, 4 Dec 2007 13:42:54 +0100
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Is the PCI clock within the spec?
Message-ID: <20071204134254.5db8e27d@bull.net>
In-Reply-To: <475532A7.1000408@free.fr>
References: <475532A7.1000408@free.fr>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 04/12/2007 13:50:29,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 04/12/2007 13:50:34,
	Serialize complete at 04/12/2007 13:50:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi John,

On Tue, 04 Dec 2007 11:57:43 +0100 John Sigler <linux.kernel@free.fr> wrote:

> Hello everyone,
> 
> I have an x86 system, running Linux 2.6.22.1-rt9, in which I plug one
> or two PCI I/O boards. I had been experiencing complete system lock-ups
> until I sent the system to the board manufacturer, and he fixed the
> problem. However, he told me that the PCI clock seemed out of spec,
> as far as voltage is concerned.
> 
> (Disclaimer: my knowledge of PCI is 0.)
> 
> The board manufacturer sent me the plot of (what appears to be) voltage
> versus time for the PCI clock.
> 
> http://linux.kernel.free.fr/plot1.jpg
> 
> The system manufacturer sent me a similar plot.
> 
> http://linux.kernel.free.fr/plot2.jpg

  Why did they send you those plots? What was their point?

> 
> As far as my understanding goes, the signal should alternate between
> 0 V and 3.3 V (??).

  Yep, that's the idealized 3.3V signaling case. However, it looks like
the signal is overshooting a bit (-0.8V below 0 and +0.8V over 3.3V from looking
at the 1st plot) which may be due to incorrect impedance matching on the bus,
probes artifacts, ...

> In the second plot, it looks like Vmax ~ 4.6V
> and Vmin ~ -1.4V (Pk-Pk(C1)=6.08V might mean peak-to-peak voltage?)

  This one looks a bit high (if they measured the same voltages I wonder
where they got their scopes calibrated ;-) )

> 
> 0) What is this C1 both plots mention?

  Scope Channel 1

> 1) Am I reading the plot correctly?

  Yep

> 2) Is -1.4V in DC even possible?

  Why not!

> 3) 4.6V is 1.3V above 3.3V and -1.4V is -1.4V below 0. (Assuming I read 
> the numbers correctly) Are these values within the PCI spec? Or are 
> these voltages dangerous and / or might cause some problems with some 
> PCI boards?

  Well it depends on which of the plot is lying. Looking at the PCI spec
(4.2.2.1) the Vih max for a device is Vcc-max+0.5 = 3.6 + 0.5 = 4.1V
the Vil min is -0.5V so in this case it looks a bit high. But I would not
worry too much, those are only the overshoots, and the circuits have
clamping diodes on their inputs.

  The test waveform voltages for the maximum ratings (4.2.2.3) against which
every PCI device should be qualified are higher than what you have here: 7.1V
peak-to-peak.

  Hope this helps.

  Sebastien.

