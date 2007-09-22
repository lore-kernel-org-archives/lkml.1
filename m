Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbXIVQ2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbXIVQ2l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 12:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXIVQ2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 12:28:34 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:26379 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbXIVQ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 12:28:33 -0400
Date: Sat, 22 Sep 2007 10:28:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] [9/50] i386: validate against ACPI motherboard resources
In-reply-to: <86802c440709212349l3d968d1bgdc89e7c7415b54da@mail.gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>, rajesh.shah@intel.com, jbarnes@virtuousgeek.org,
       greg@kroah.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Message-id: <46F542A4.9080207@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <200709221231.836138000@suse.de>
 <20070921223207.7BBE71479D@wotan.suse.de>
 <86802c440709212349l3d968d1bgdc89e7c7415b54da@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> No!
> 
> MMCONFIG will not work with acpi=off any more.

I don't think this is unreasonable. The ACPI MCFG table is how we are 
supposed to learn about the area in the first place. If we can't get the 
table location via an approved mechanism, and can't validate it doesn't 
overlap with another memory reservation or something, I really don't 
think we should be using it.

I don't think it's much of an issue anyway - the chances that somebody 
will want to run without ACPI on a system with MCFG are pretty low given 
that you'll end up losing a bunch of functionality (not least of which 
is multi-cores).

> 
> because acpi_init==>pci_mmcfg_late_init==>pci_mmcfg_check_hostbridge...
> 
> can you move pci_mmcfg_later_init out of acpi_init and just call
> somewhere after acpi_init...
> or put pci_mmcfg_check_hostbridge back to pci_mmcfg_early_init?
> 
> YH
> 
