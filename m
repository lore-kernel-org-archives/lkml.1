Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbXJAGGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbXJAGGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 02:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXJAGGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 02:06:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:60744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbXJAGGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 02:06:38 -0400
Date: Sun, 30 Sep 2007 23:10:25 -0700
From: Greg KH <gregkh@suse.de>
To: JoonwooPark <joonwpark81@gmail.com>
Cc: linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com
Subject: Re: [PATCH] PCI hotplug : Switch to pci_get_bus_and_slot instead
	of deprecated pci_find_slot.
Message-ID: <20071001061025.GA11573@suse.de>
References: <1191208147.6123.11.camel@joonwpark-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191208147.6123.11.camel@joonwpark-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 12:09:07PM +0900, JoonwooPark wrote:
> This patch fixes these warnings:
> 
> drivers/pci/hotplug/cpqphp_pci.c: In function ???cpqhp_configure_device???:
> drivers/pci/hotplug/cpqphp_pci.c:92: warning: ???pci_find_slot??? is deprecated (declared at include/linux/pci.h:481)
> drivers/pci/hotplug/cpqphp_pci.c:102: warning: ???pci_find_slot??? is deprecated (declared at include/linux/pci.h:481)
> drivers/pci/hotplug/cpqphp_pci.c: In function ???cpqhp_unconfigure_device???:
> drivers/pci/hotplug/cpqphp_pci.c:126: warning: ???pci_find_slot??? is deprecated (declared at include/linux/pci.h:481)
> drivers/pci/hotplug/cpqphp_pci.c: In function ???cpqhp_save_config???:
> drivers/pci/hotplug/cpqphp_pci.c:420: warning: ???pci_find_slot??? is deprecated (declared at include/linux/pci.h:481)
> 
> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

Close, but you need to free the reference that you now have grabed.  As
is, this patch will cause a memory leak and cause bad things to happen
:(

Take a look at the documentation for the pci_get_bus_and_slot()
function, it's not as easy as a simple search-and-replace.

thanks,

greg k-h
