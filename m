Return-Path: <linux-kernel-owner+w=401wt.eu-S965223AbYBAAOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223AbYBAAOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965037AbYBAAOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:14:20 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:54668 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965012AbYBAAOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:14:19 -0500
Date: Thu, 31 Jan 2008 18:14:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
 sound card
In-reply-to: <20080131145820.44171af2.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: avuton@gmail.com, yakui.zhao@intel.com, shaohua.li@intel.com,
       bjorn.helgaas@hp.com, trenn@suse.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Message-id: <47A2644B.4000905@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no>
 <479CCAAD.4080706@shaw.ca> <20080131145820.44171af2.akpm@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> There was a patch floating around to ignore PnPACPI reservations which 
>> conflict with PCI BARs, which appears to be what's happening in this 
>> case. That patch originally worked for any board, but was later made 
>> specific to a certain Supermicro motherboard which had the sata_nv 
>> controller MMIO regions marked as reserved, preventing the driver from 
>> loading. We may need a more general solution. See:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=313491
> 
> Thanks.  If we were to remove the supermicro-specificity, would this be a
> sufficiently general solution?

I think so. There was one objection that it introduced a dependency on 
pnpacpi loading after PCI bus enumeration, though.

Linus also suggested that pnpacpi could be marking the resources as 
"present but unused" so that drivers can request those regions but we 
still prevent dynamically assigning resources into them.
