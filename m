Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZELPAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZELPAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZELPAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:00:38 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:60991 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZELPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:00:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=LjN9Bo2RzMwnOdHSyD7usAxDfFroJnB9ZBEWdHJOLMuqbS9zqq+vrhHNdNS6nUUPY2
         gZEEhTTArnebDGz5I7fEuuLVbD9T4NWTmj8p0oMK4afBg183XoFTH3LSSjW7O6dZCo+q
         CLUhfXTdtjCMSYXKBYUqqe0mK5W3nTPXE45ZE=
Date: Tue, 12 May 2009 19:00:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, eswierk@aristanetworks.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
Message-ID: <20090512150034.GB10220@lenovo>
References: <49FC85A9.2070702@kernel.org> <tip-4797f6b021a3fa399942245d07a1feb30df81bb8@git.kernel.org> <20090512112205.GA12108@elte.hu> <20090512145128.GA10220@lenovo> <20090512145808.GA20587@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090512145808.GA20587@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, May 12, 2009 at 04:58:08PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Ingo Molnar - Tue, May 12, 2009 at 01:22:05PM +0200]
| > | 
| > | this build bug is still unfixed:
| > | 
| > | drivers/pci/hotplug/ibmphp_core.c:165: error: expected identifier before ‘&’ token
| > | drivers/pci/hotplug/ibmphp_core.c:166: error: too few arguments to function ‘IO_APIC_get_PCI_irq_vector’
| > | 
| > | 	Ingo
| > | 
| > 
| > Grrr... this line looks really suspicious inideed
| > 
| > 			for (i = 0; i < 4; i++)
| > 				(*cur_slot)->irq[i] = IO_APIC_get_PCI_irq_vector((int) (*cur_slot)->bus,
| > --->						(int) (*cur_slot)->device, i.
| > 						&ioapic, &ioapic_pin,
| > 						&triggering, &polarity);
| > 
| > but it's _not_ 'cause of this commit, since
| > we didn't even touch this file :) The point
| > symbol should be changed to comma. Just a
| > misprint I believe. Appened patch should do
| > the trick.
| 
| Yinghai touched it:
| 
| e20c06f: x86/pci: add 4 more return parameters to IO_APIC_get_PCI_irq_vector()
| 
| 	Ingo
| 

ah, i see

	-- Cyrill
