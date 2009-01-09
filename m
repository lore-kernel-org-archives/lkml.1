Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbZAIRA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbZAIRA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 12:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZAIRAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 12:00:21 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:30934 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZAIRAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 12:00:20 -0500
Message-Id: <496790D1.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 09 Jan 2009 17:00:49 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: x86: meaning of nolapic command line option
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't that option imply that all APIC related activity, including that relating to IO-APICs or PCI MSI, should be circumvented? I'm finding that MSI must be disabled separately, and while most of the IO-APIC stuff is indeed not happening, acpi_get_override_irq() only checks skip_ioapic_setup, but that doesn't normally set without the noapic command line option.

Is there any reason pci_no_msi() and disable_ioapic_setup() shouldn't be called when !cpu_has_apic at the end of identify_cpu()?

Thanks, Jan

