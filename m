Return-Path: <linux-kernel-owner+w=401wt.eu-S964976AbXCOCkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976AbXCOCkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 22:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965013AbXCOCkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 22:40:19 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:38215 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976AbXCOCkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 22:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=d0I5L+mXLtqhQ+HlM5P6M1WPVzpjkbP4ddlrOo237E8WTl9eCyv3ReZzZxyP3FwfUHRGqBTXVS4SzWlYAJju6OlU9RzmFb+eJOReaDXHRddnE33wG4oyB61C1jcF5k5lXVG9E07SQLNeikUwNrAcAYqR42py0SDfhseJHgWLBgw=
Message-ID: <45F8B1FE.5060406@gmail.com>
Date: Thu, 15 Mar 2007 11:39:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: gregkh@suse.de, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       michal.k.k.piotrowski@gmail.com, linux-ide@vger.kernel.org,
       tglx@linutronix.de, shemminger@linux-foundation.org, mlord@pobox.com,
       linux-pm@lists.osdl.org
Subject: Re: [PATCH/RFC] PCI prepare/activate instead of enable to avoid IRQ
 storm and rogue DMA access
References: <20070314152302.GB15600@htj.dyndns.org> <p73fy878pmg.fsf@bingen.suse.de>
In-Reply-To: <p73fy878pmg.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Tejun Heo <htejun@gmail.com> writes:
>> Let's assume there's a device which shares its INTX IRQ line with
>> another device and the other one is already initialized.  During boot,
>> due to BIOS's fault, bad hardware design or sheer bad luck, the device
>> has got a pending IRQ.
> 
> This seems to be also common after kexec during kexec crashdumps
> where the device just continues doing what it did before the crash.
> 
>> This patch expands the pci_set_master() approach.  Instead of enabling
>> the device in one go, it's done in two steps - prepare and activate.
>> 'prepare' enables access to PCI configuration,
> 
> I hope there aren't any new erratas triggered by this. Perhaps it would
> make sense to add some paranoia sleeps at least before touching other
> state? 

Do you mean between disabling IRQ mechanisms and enabling PCI device in 
pcim_prepare_device()?

Thanks.

-- 
tejun
