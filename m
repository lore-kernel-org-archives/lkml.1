Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZDUOEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZDUOEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbZDUOE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:04:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:52725 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbZDUOE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t01fTOpeyW0JziAIubybPeeP9YBnXI9F2PccxeaJJZJVepbhZFgVMUjrQfon6HC/00
         CIJ1NxIFaEaz0SJrmXzMLwki6ztpfF0U/3Q4pKxmozXqFNWbxzpO7AcuKzLoPMpVmLAW
         bBMiAMSC5danE23MPu3UIKRGIdAWn9WkwSUkQ=
Date: Tue, 21 Apr 2009 18:04:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, weidong.han@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: x2apic, IR: Move eoi_ioapic_irq() into a
	CONFIG_INTR_REMAP section
Message-ID: <20090421140416.GB10856@lenovo>
References: <20090420200450.271099000@linux-os.sc.intel.com> <tip-25629d810a52176758401184d9b437fbb7f79195@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-25629d810a52176758401184d9b437fbb7f79195@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[tip-bot for Suresh Siddha - Tue, Apr 21, 2009 at 08:07:00AM +0000]
| Commit-ID:  25629d810a52176758401184d9b437fbb7f79195
| Gitweb:     http://git.kernel.org/tip/25629d810a52176758401184d9b437fbb7f79195
| Author:     Suresh Siddha <suresh.b.siddha@intel.com>
| AuthorDate: Mon, 20 Apr 2009 13:02:28 -0700
| Committer:  Ingo Molnar <mingo@elte.hu>
| CommitDate: Tue, 21 Apr 2009 09:08:26 +0200
| 
| x86: x2apic, IR: Move eoi_ioapic_irq() into a CONFIG_INTR_REMAP section
| 
| Address the following complier warning:
| 
|    arch/x86/kernel/apic/io_apic.c:2543: warning: `eoi_ioapic_irq' defined but not used
| 
| By moving that function (and eoi_ioapic_irq()) into an existing
| #ifdef CONFIG_INTR_REMAP section of the code.
| 
| [ Impact: cleanup ]
| 
| Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
| Cc: dwmw2@infradead.org
| Cc: Weidong Han <weidong.han@intel.com>
| LKML-Reference: <20090420200450.271099000@linux-os.sc.intel.com>
| Signed-off-by: Ingo Molnar <mingo@elte.hu>
| Cc: Weidong Han <weidong.han@intel.com>
| 
| 
| ---
|  arch/x86/kernel/apic/io_apic.c |   66 ++++++++++++++++++++--------------------
|  1 files changed, 33 insertions(+), 33 deletions(-)
| 
...  
|  #ifdef CONFIG_INTR_REMAP
| +static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
| +{
| +	int apic, pin;
| +	struct irq_pin_list *entry;
| +
| +	entry = cfg->irq_2_pin;
| +	for (;;) {
| +
| +		if (!entry)
| +			break;
| +
| +		apic = entry->apic;
| +		pin = entry->pin;
| +		io_apic_eoi(apic, pin);
| +		entry = entry->next;
| +	}
| +}
| +
...

Btw, maybe we better could use plain "while(entry) {...}" here?

        Cyrill
