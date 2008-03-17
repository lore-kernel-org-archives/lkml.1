Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbYCQTx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbYCQTx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbYCQTxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:53:19 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:23061 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbYCQTxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:53:18 -0400
Date: Mon, 17 Mar 2008 13:53:17 -0600
From: Alex Chiang <achiang@hp.com>
To: Mark Lord <mlord@pobox.com>
Cc: kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [regression] pciehp hang on hp ia64 rx6600
Message-ID: <20080317195317.GE6808@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Mark Lord <mlord@pobox.com>, kristen.c.accardi@intel.com,
	linux-kernel@vger.kernel.org
References: <20080312064755.GA31493@ldl.fc.hp.com> <47D8142E.6060305@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D8142E.6060305@pobox.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

* Mark Lord <mlord@pobox.com>:
> Alex Chiang wrote:
>> Hi Mark, Kristin,
>> On my hp ia64 rx6600, 'modprobe pciehp' causes lockups and a
>> system hang on 2.6.25-rc4. My system often hangs when only pciehp
>> is loaded and my console is sitting idle, but I can accelerate
>> the hang 100% of the time by immediately doing a 'modprobe
>> acpiphp' right afterwards.
> ..
>
> Does this patch fix things for you?

Yes, this patch does revert back to previously working 2.6.24
behavior and fixes the problem for me.

Thanks.

> * * *
>
> Invoke pciehp_enable_slot() at startup only when pciehp_force=1.
> Some HP equipment apparently cannot cope with it otherwise.
>
> This restores the (previously working) 2.6.24 behaviour here,
> while allowing machines that need a kick to use pciehp_force=1.
>

Acked-by: Alex Chiang <achiang@hp.com>

> Signed-off-by: Mark Lord <mlord@pobox.com>
> ---
>
> --- linux-2.6.25-rc5-git2/drivers/pci/hotplug/pciehp_core.c	2008-03-12 
> 13:21:46.000000000 -0400
> +++ linux/drivers/pci/hotplug/pciehp_core.c	2008-03-12 13:23:54.000000000 
> -0400
> @@ -467,7 +467,7 @@
> 	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
> 	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is 
> occupied */
> -	if (value) {
> +	if (value && pciehp_force) {
> 		rc = pciehp_enable_slot(t_slot);
> 		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
> 			value = 0;
>
