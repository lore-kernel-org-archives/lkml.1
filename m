Return-Path: <linux-kernel-owner+w=401wt.eu-S1763002AbXGMXkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763002AbXGMXkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbXGMXka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:40:30 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:56367 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbXGMXk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:40:29 -0400
Date: Fri, 13 Jul 2007 17:42:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Always zero test in arch/i386/pci/mmconfig-shared.c
In-reply-to: <fa.nwpKC6+7UvIqGGeRe+rNP7ZO5P4@ifi.uio.no>
To: Scott Ashcroft <scott.ashcroft@talk21.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Message-id: <46980DE4.6090404@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.nwpKC6+7UvIqGGeRe+rNP7ZO5P4@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Ashcroft wrote:
> I don't think it makes any change to subsequent flow but the code in 
> pci_mmcfg_check_hostbridge is:
> 
> pci_mmcfg_config_num = 0;
> 

You missed this code:

name = pci_mmcfg_probes[i].probe();

This calls one of the probe functions above, which will set 
pci_mmcfg_config_num to something else, as with the name variable. It 
may set the name but not the config num, if the chipset is recognized 
but MMCONFIG isn't enabled, etc.

> 
> if (name) {
>     printk(KERN_INFO "PCI: Found %s %s MMCONFIG support.\n",
>            name, pci_mmcfg_config_num ? "with" : "without");
> }
> 
> So it will always prints "without".
> 
> I'd make a patch but I'm not sure what this fix is. Just drop the test, 
> the printk or make it say "which might possibly have"?
> 
> Cheers,
> Scott

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

