Return-Path: <linux-kernel-owner+w=401wt.eu-S1759183AbYCUP4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183AbYCUP4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYCUP4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:56:09 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:1508 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968AbYCUP4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:56:07 -0400
Date: Fri, 21 Mar 2008 09:56:05 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH  1/16][BUG] Export kobject_rename for pci_hotplug_core
	(Not for mainline!)
Message-ID: <20080321155605.GE17292@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com> <47E334E2.6060306@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E334E2.6060306@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch looks like a candidate for the current 2.6.25 cycle.
Any chance of getting it in there?

If not, maybe you can push it into linux-next without waiting for
the rest of my pci_slot changes, since this is a fix for the
kobject core, and not necessarily what I'm working on.

Thanks.

/ac

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Export kobject_rename() to fix the following link error. This happens
> when pci_hotplug_core driver is compiled as a kernel module.
> 
> ERROR: "kobject_rename" [drivers/pci/hotplug/pci_hotplug.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> make: *** Waiting for unfinished jobs....
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Acked-by: Alex Chiang <achiang@hp.com>

> 
> ---
>  lib/kobject.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.25-rc6/lib/kobject.c
> ===================================================================
> --- linux-2.6.25-rc6.orig/lib/kobject.c
> +++ linux-2.6.25-rc6/lib/kobject.c
> @@ -456,6 +456,7 @@ out:
>  
>  	return error;
>  }
> +EXPORT_SYMBOL_GPL(kobject_rename);
>  
>  /**
>   * kobject_move - move object to another parent
> 
> 
