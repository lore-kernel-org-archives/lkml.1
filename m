Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYKDFC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYKDFC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 00:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbYKDFCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 00:02:50 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44547 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYKDFCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 00:02:49 -0500
Date: Tue, 4 Nov 2008 05:02:45 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add option to passively listen for PCIE hotplug events
Message-ID: <20081104050245.GA13466@srcf.ucam.org>
References: <20081029200903.GA1678@srcf.ucam.org> <490FAC33.9050808@jp.fujitsu.com> <20081104020700.GA11761@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104020700.GA11761@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 02:07:00AM +0000, Matthew Garrett wrote:
> On Tue, Nov 04, 2008 at 10:58:11AM +0900, Kenji Kaneshige wrote:
> > > 	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if 
> > > 	slot is occupied */
> > >-	if (value && pciehp_force) {
> > >+	if (value && (pciehp_force || pciehp_passive)) {
> > > 		rc = pciehp_enable_slot(t_slot);
> > > 		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
> > > 			value = 0;
> 
> This code no longer runs in the pciehp_passive case. However, by the 
> looks of it it still does in the resume case - that probably wants 
> fixing.

Thinking about this - you said that the problem occurs because 
pciehp_force=1 causes it to try to enable an already enabled slot, and 
then tries to power down the slot as a result? It sounds like this code 
should actually be checking whether the return value is ENODEV or 
EINVAL, and in the latter case not powering the slot down. That sounds 
like a separate bugfix that I'll send later on.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
