Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbZJIS2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbZJIS2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761180AbZJIS2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:28:50 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:22179 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760563AbZJIS2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:28:49 -0400
X-Loopcount0: from 10.9.160.253
Date: Fri, 9 Oct 2009 13:28:11 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Zhang Yanmin <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCIe AER: honor ACPI HEST FIRMWARE FIRST mode
Message-ID: <20091009182810.GB24889@mock.linuxdev.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@dell.com>
References: <20091006173311.GA15751@auslistsprd01.us.dell.com> <4ACEE220.1020705@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACEE220.1020705@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 04:11:28PM +0900, Kenji Kaneshige wrote:
> In the current AER driver implementation, correctable, non-fatal,
> fatal, unsupported request reporting enable bits in PCIe device
> control register can be changed by adapter card drivers through pci_enable_pcie_error_reporting() or pci_disable_pcie_error_reporting()
> APIs, regardless of _OSC evaluation result.
>
> I'm not sure, but I guess you might need to prevent those bits
> from being changed in the Firmware First mode.

You are correct.  Thank you for the catch.  I don't know if we can
prevent changing these bits via the raw operations, but we can prevent
them in these functions.  Patch to follow does so.

-- 
Matt Domsch
Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
