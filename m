Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbZBYAPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbZBYAPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 19:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZBYAPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 19:15:05 -0500
Received: from main.gmane.org ([80.91.229.2]:45230 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbZBYAPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 19:15:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: ACPI exception with 2.6.29-rc6
Date: Tue, 24 Feb 2009 18:12:02 -0600
Message-ID: <49A48CD2.7070305@gmail.com>
References: <871vtpqex0.wl%htd@fancy-poultry.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-kernel@vger-kernel.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
In-Reply-To: <871vtpqex0.wl%htd@fancy-poultry.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heinz Diehl wrote:
> Hi,
> 
> booting 2.6.29-rc6 shows the following in boot.log:
> 
> [....]
> <7>bus: 00 index 4 mmio: [230000000, fcffffffff]
> <6>ACPI: bus type pci registered
> <5>PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
> <5>PCI: MCFG area at f0000000 reserved in E820
> <6>PCI: Using MMCONFIG at f0000000 - f7ffffff
> <6>PCI: Using configuration type 1 for base access
> <4>bio: create slab <bio-0> at 0
> <7>ACPI: EC: Look up EC in DSDT
> --> <3>ACPI: Denied BIOS AML access to invalid port 0x4d0+0x2 (ELCR)
> --> <4>ACPI Exception (dsopcode-0419): AE_AML_ILLEGAL_ADDRESS, During address validation of OpRegion [ELCR] [20081204]

Your BIOS defines an operation region on some IO addresses that the 
kernel will not allow it to access since they are things that BIOS AML 
code is not supposed to be poking with. This check was recently added. 
Windows XP and later also disallow AML access to these registers.

Note that this doesn't necessarily mean that the BIOS is actually trying 
to access those registers. On my A8N-SLI Deluxe machine, the ACPI AML 
defines an operation region for the ELCR register, but it doesn't seem 
like it is ever used.

In any case.. nothing to really worry about.

