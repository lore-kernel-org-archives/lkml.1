Return-Path: <linux-kernel-owner+w=401wt.eu-S933157AbZJIHMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbZJIHMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933105AbZJIHMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:12:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56257 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078AbZJIHMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:12:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ACEE220.1020705@jp.fujitsu.com>
Date: Fri, 09 Oct 2009 16:11:28 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Matt Domsch <Matt_Domsch@dell.com>
CC: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Zhang Yanmin <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCIe AER: honor ACPI HEST FIRMWARE FIRST mode
References: <20091006173311.GA15751@auslistsprd01.us.dell.com>
In-Reply-To: <20091006173311.GA15751@auslistsprd01.us.dell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Domsch wrote:
> For review and comment.
> 
> Today, the PCIe Advanced Error Reporting (AER) driver attaches itself
> to every PCIe root port for which BIOS reports it should, via ACPI
> _OSC.
> 
> However, _OSC alone is insufficient for newer BIOSes.  Part of ACPI
> 4.0 is the new Platform Environment Control Interface (PECI), which is
> a way for OS and BIOS to handshake over which errors for which
> components each will handle.  One table in ACPI 4.0 is the Hardware
> Error Source Table (HEST), where BIOS can define that errors for
> certain PCIe devices (or all devices), should be handled by BIOS
> ("Firmware First mode"), rather than be handled by the OS.
> 
> Dell PowerEdge 11G server BIOS defines Firmware First mode in HEST, so
> that it may manage such errors, log them to the System Event Log, and
> possibly take other actions.  The aer driver should honor this, and
> not attach itself to devices noted as such.
> 
> 
> Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
> 

In the current AER driver implementation, correctable, non-fatal,
fatal, unsupported request reporting enable bits in PCIe device
control register can be changed by adapter card drivers through pci_enable_pcie_error_reporting() or pci_disable_pcie_error_reporting()
APIs, regardless of _OSC evaluation result.

I'm not sure, but I guess you might need to prevent those bits
from being changed in the Firmware First mode.

Thanks,
Kenji Kaneshige


