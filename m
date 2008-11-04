Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbYKDCHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbYKDCHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 21:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYKDCHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 21:07:07 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48836 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYKDCHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 21:07:06 -0500
Date: Tue, 4 Nov 2008 02:07:00 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add option to passively listen for PCIE hotplug events
Message-ID: <20081104020700.GA11761@srcf.ucam.org>
References: <20081029200903.GA1678@srcf.ucam.org> <490FAC33.9050808@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490FAC33.9050808@jp.fujitsu.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 10:58:11AM +0900, Kenji Kaneshige wrote:

> - Even with pciehp_passive option, pciehp driver controls hotplug
>  related registers at the initialization time, enabling software
>  notification mechanism for hotplug events, trying to turn power
>  on the slot and so on. Is this your intended behaviour?

Yes, although the most recent version of the patch doesn't do the 
forcible power on if no card is detected.

> - Maybe I don't understand what "pciehp will listen for events..."
>  in your patch description means. But if you expect the pciehp's
>  interrupts for hotplug events, it would not work properly when
>  hotplug control is not granted through _OSC or OSHP.

What do you mean by "not work properly"? The hardware we've tested with 
fires events even without an OSHP method being present. That's the case 
we're trying to deal with.

> > 	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if 
> > 	slot is occupied */
> >-	if (value && pciehp_force) {
> >+	if (value && (pciehp_force || pciehp_passive)) {
> > 		rc = pciehp_enable_slot(t_slot);
> > 		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
> > 			value = 0;

This code no longer runs in the pciehp_passive case. However, by the 
looks of it it still does in the resume case - that probably wants 
fixing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
