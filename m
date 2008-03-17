Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYCQV30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYCQV30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 17:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbYCQV3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 17:29:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:1616 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbYCQV3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 17:29:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,514,1199692800"; 
   d="scan'208";a="535349106"
Date: Mon, 17 Mar 2008 14:13:41 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alex Chiang <achiang@hp.com>, Linus Torvalds <torvalds@osdl.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] pciehp dont enable slot unless forced
Message-ID: <20080317141341.1efebb7b@appleyard>
In-Reply-To: <47DECEC7.6070005@rtr.ca>
References: <20080312064755.GA31493@ldl.fc.hp.com>
	<47D8142E.6060305@pobox.com>
	<20080317195317.GE6808@ldl.fc.hp.com>
	<47DECEC7.6070005@rtr.ca>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008 16:04:23 -0400
Mark Lord <lkml@rtr.ca> wrote:

> This fixes a 2.6.25 regression reported by Alex Chiang.
> 
> Invoke pciehp_enable_slot() at startup only when pciehp_force=1.
> Some HP equipment apparently cannot cope with it otherwise.
> 
> This restores the (previously working) 2.6.24 behaviour here,
> while allowing machines that need a kick to use pciehp_force=1.
> 
> This was the original design back in October 2007,
> but Kristen suggested we try without it first:
> 
>    Kristen Carlson Accardi wrote:
>    >I think it would be ok to try allowing the slot to be enabled
>    >when not using pciehp_force mode.  We can wrap it later if it
>    >proves to break things
> 
> This ended up breaking one of Alex's setups,
> so it's time to put the wrapper back in now.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> Acked-by: Alex Chiang <achiang@hp.com>
> ---
> 
> --- old/drivers/pci/hotplug/pciehp_core.c	2008-03-12
> 13:21:46.000000000 -0400 +++
> linux/drivers/pci/hotplug/pciehp_core.c	2008-03-12
> 13:23:54.000000000 -0400 @@ -467,7 +467,7 @@ t_slot =
> pciehp_find_slot(ctrl, ctrl->slot_device_offset); 
>  	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /*
> Check if slot is occupied */
> -	if (value) {
> +	if (value && pciehp_force) {
>  		rc = pciehp_enable_slot(t_slot);
>  		if (rc)	/* -ENODEV: shouldn't happen, but
> deal with it */ value = 0;
> 

Acked-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
