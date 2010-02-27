Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030896Ab0B0W6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 17:58:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59936 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965838Ab0B0W6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 17:58:14 -0500
Message-ID: <4B89A359.9020708@zytor.com>
Date: Sat, 27 Feb 2010 14:57:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com, ebiederm@xmission.com,
       garyhade@us.ibm.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, trenn@suse.de
Subject: Re: [tip:x86/apic] x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()
References: <4B882182.4030205@kernel.org> <tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org> <20100227130113.GA18661@elte.hu> <4B8969E2.7000506@kernel.org>
In-Reply-To: <4B8969E2.7000506@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2010 10:52 AM, Yinghai Lu wrote:
> 
> Ingo found:
> | x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()
> cause:
>  arch/x86/kernel/apic/io_apic.c:1042: error: implicit declaration of function ?remap_ioapic_gsi_to_irq?
> 
> actually when !CONFIG_ACPI, we have
> #define acpi_ioapic 0
> 
> somehow we still get warning for
> #if (!0) {
> 	...
> } else {
> 	...
> 	remap_ioapic_gsi_to_irq...
> }
> 
> gcc bug?
> 

You're confusing #if and if ( ) { .. }.

Inside an if () { ... } clause the contents still needs to be correct,
even if it will get optimized out.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

