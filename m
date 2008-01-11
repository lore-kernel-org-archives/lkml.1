Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbYAKPUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbYAKPUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbYAKPUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:20:32 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38752 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759590AbYAKPUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:20:31 -0500
Date: Fri, 11 Jan 2008 15:17:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Hall <mhall@mhcomputing.net>, linux-scsi@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sata_nv does not function in kernel > 2.6.20.21
Message-ID: <20080111151758.1d702b50@lxorguk.ukuu.org.uk>
In-Reply-To: <4785A1CF.7050006@garzik.org>
References: <20080110024733.GC9461@mhcomputing.net>
	<4785A1CF.7050006@garzik.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Error -16 is EBUSY, which causes the driver load to fail due to the 
> "Unable to reserve mem region" message.
> 
> This means that the sata_nv driver needed to use PCI BAR 6, but was 
> unable to for some reason.  Given that sata_nv uses devres like other 
> libata drivers, IMO the likely cause is outside the ATA subsystem (PCI? 
> ACPI?).

Actually it looks to me like there is something very odd going on here.
The sata_nv code checks each of the 6 resources exists (wrongly - it does
it before pcim_enable_device so the check is probably not valid). That
would report -ENODEV.

EBUSY implies all 6 resources were assigned but one couldn't be mapped.
