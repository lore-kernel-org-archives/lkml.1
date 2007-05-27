Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbXE0Uba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbXE0Uba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 16:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbXE0UbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 16:31:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:62466 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbXE0UbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 16:31:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=kXjoeM82c/Eluon1JCDWP3Du0ei/uEulcAFAvWvhVCHW3B27j3sMxLmPVyDpZuajIF0hkReNx+Z/K47zmkFlPr3AV8fqDCox7kOplYnIgMsgsvApgFWb2bPNZmWMEhk2QrWEMCCshZcUM3754a6/03eU7lgkjuTsgbgRBCbYEqI=
Message-ID: <4659EA85.2010700@gmail.com>
Date: Mon, 28 May 2007 00:31:01 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: hpa@zytor.com, rdreier@cisco.com, greg@kroah.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
References: <46584C30.4030206@gmail.com>	<20070526.154910.78725926.davem@davemloft.net>	<4658EE32.5080506@zytor.com> <20070527.004019.41635814.davem@davemloft.net>
In-Reply-To: <20070527.004019.41635814.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Sat, 26 May 2007 19:34:26 -0700
> 
>> There are systems which only get a single bit indication that an MSI has
>> happened.
>>
>> Presumably we need something like IRQF_MSI which can be set as
>> appropriate depending on the architecture?
> 
> Although I don't want to make the IRQ handling subsystems any more
> complicated than they already are, one idea I floated around is that
> we could seperate CPU irq numbers (the things we pass around today)
> and MSI vector numbers.
> 
> But I immediately understand how that is unnecessary to some extent,
> any platform which needs to deal with that kind of distinction can use
> virtual IRQ numbers like sparc64 and powerpc do.
> 
> Sparc64 PCI-E controllers, for example, allow you to group several
> MSIs into a 'group', and the interrupt source is for the group rather
> than the individual MSIs.  When the MSI group interrupt arrives, you
> get a descriptor in a per-MSI-group ring buffer that describes the MSI
> that arrived.
> 
> This descriptor in fact passes on a ton of interesting information,
> see arch/sparc64/kernel/pci_sun4v.c:pci_sun4v_msiq_entry.
> 
> It gives you the type, the system TSC value at the time of interrupt
> arrival (so you could do incredibly cool profiling with this),
> the PCI bus/device/fn that generated the MSI vector, the MSI address
> that was signalled, the MSI data field, and full information for PCI-E
> MSG packets including bus/dev/fn of target, the message routing code,
> and the message code.
> 
> But we use none of these facilities currently because it's either
> impossible or too cumbersome to be useful at the moment.
> 

I think it is better to use IRQF_MSI as HPA suggested, since IRQF_SHARED
is a bit confusing thing altogether since MSI doesn't share interrupts.


