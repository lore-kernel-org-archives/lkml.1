Return-Path: <linux-kernel-owner+w=401wt.eu-S1761060AbXEZPFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060AbXEZPFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 11:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbXEZPF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 11:05:29 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:16189 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbXEZPF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 11:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=IiHD7mgbJJMQpWbVIsL0Edw3SeqCVZZ2AdSMnaQcf+Y6ku7DnFXYGUlLIPPND/uieubW2+wOJh17IQoi9K/FagW8H714XzPa70MGF1Msy5t93zJvCm7zRfdRRnBTsWBQSRyMAyAL4ASR4lkLyNgyqguUtv5rT1e7ggFieY9r0s0=
Message-ID: <46584C30.4030206@gmail.com>
Date: Sat, 26 May 2007 19:03:12 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
References: <46543045.3030904@gmail.com> <20070523155958.GA5282@kroah.com>	<4654AB40.6060208@gmail.com> <adaejl79rh0.fsf@cisco.com>	<4654BC10.2000808@gmail.com> <adazm3v89hv.fsf@cisco.com>	<4654C85B.6060505@gmail.com> <adatzu385g1.fsf@cisco.com>	<46561287.8020103@gmail.com> <ada1wh560u1.fsf@cisco.com>
In-Reply-To: <ada1wh560u1.fsf@cisco.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > I am now wondering whether the usage of MSI would help in this case and
>  > that i should be using enable_msi before request_irq ?
> 
> MSI interrupts are never shared.  So if pci_enable_msi() succeeds, you
> can be sure that the interrupts you get with that IRQ number are
> coming from your device.
> 

i presume then i shouldn't be using IRQF_SHARED, if using MSI.

Another question would be if the device supports multiple messages, MSIX
should be used ?
In such a context, if i request for say more than the messages that i
need, say i request 16 messages, but use only 1 or 2, that does bear any
consequences ?

> But using MSI does not work on all systems, so your driver needs to
> work with standard (possibly shared) INTx interrupts too.  And you
> should probably provide at least a module flag to disable the use of
> MSI, to avoid problems on buggy systems.

I should probably look for CONFIG_PCI_MSI and check whether the system
supports MSI pci_enable_msi() ?

