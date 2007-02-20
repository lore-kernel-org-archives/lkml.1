Return-Path: <linux-kernel-owner+w=401wt.eu-S965019AbXBTPK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019AbXBTPK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965021AbXBTPK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:10:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964989AbXBTPK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:10:57 -0500
Message-ID: <45DB0EEA.2010205@redhat.com>
Date: Tue, 20 Feb 2007 10:08:26 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Rudolf Marek <r.marek@assembler.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <45D8D6AE.3000204@assembler.cz>
In-Reply-To: <45D8D6AE.3000204@assembler.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rudolf Marek wrote:
> Hello all,
> 
> I got the DSDT from chuck and it seems there is nothing interesting - no
> declaration of PCI_config for the registers. If someone wants to check it I can
> send him the DSDT.
> 
> _TMP looks like this:
> 
>  Store (\_SB.PCI0.LPC0.EC0.RTMP, Local0)
>                     Store ("Current temp is: ", Debug)
> 
>                     Store (Local0, Debug)
> 
>                     Store (Local0, \_SB.CM25)
> 
>                     Return (Add (0x0AAC, Multiply (Local0, 0x0A)))
> 
> This looks quite OK LPC0.EC0 is embedded controller IO RAM at 0x62. Nothing
> special. I guess some SMM interrupt is reading the the PCI regs and sends it to EC.

I blacklisted the k8temp driver (and the out-of-tree k8_edac driver
in Fedora) and the temps were still volatile, so that's not causing
it. Since then I've upgraded the system BIOS from F.06 to F.27 and
the problems _may_ have gone away. My own custom 2.6.19 kernel has
never been a problem, so I'm thinking it's one of these drivers
loaded by Fedora that I never even compile:

	i2c_core
	i2c_ec
	i2c_piix4
	asus_acpi (on a Compaq???)
	sbs


