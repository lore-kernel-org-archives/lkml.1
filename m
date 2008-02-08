Return-Path: <linux-kernel-owner+w=401wt.eu-S934894AbYBHS1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934894AbYBHS1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935059AbYBHSZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:25:57 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:46197 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935034AbYBHSZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:25:55 -0500
X-Belgacom-Dynamic: yes
Date: Fri, 8 Feb 2008 19:25:52 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: DMI: add-type-41
Message-ID: <20080208182552.GA6613@infomag.infomag.iguana.be>
References: <20080125201911.GB3234@infomag.infomag.iguana.be> <20080208053359.GE7226@auslistsprd01.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208053359.GE7226@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

> >     [PATCH] SMBIOS/DMI - add type 41 = Onboard Devices Extended Information
> 
> Is there something in the kernel that will consume this data, or is it
> being exported in /sys/class/dmi/id somehow?  There will be one table
> entry per device (Dell PowerEdge x9xx servers with recent BIOS do so).
> 
> FWIW, my biosdevname app consumes this data, using dmidecode from
> userspace.

Just like smbios/dmi type 10 we add the the info to the dmi_devices list.
The dmi_find_device function (see drivers/firmware/dmi_scan.c) makes this
info available to other device drivers (like drivers/ata/ata_piix.c,
drivers/misc/thinkpad_acpi.c, drivers/watchdog/ibmasr.c and
drivers/char/ipmi/ipmi_si_intf.c).

The dmi_devices list is a different list then the dmi_ident table that stores
the BIOS, PRODUCT, BOARD and CHASSIS info (and that is exported to /sys/class/dmi/* ).
The dmi_devices list is not exported to sysfs as far as I know.

My opinion: if we have type 10 we will need type 41 in the future. If we don't need
type 10 then we don't need type 41 neither (since we can use dmidecode in userspace).

Greetings,
Wim.

