Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968678Ab0B0XAE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 18:00:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:48931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966016Ab0B0XAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 18:00:01 -0500
Message-ID: <4B89A398.2090101@kernel.org>
Date: Sat, 27 Feb 2010 14:58:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       garyhade@us.ibm.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, trenn@suse.de
Subject: Re: [tip:x86/apic] x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()
References: <4B882182.4030205@kernel.org>	<tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>	<20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org>	<4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org>	<4B8995FB.9000908@kernel.org> <m1mxyue31g.fsf@fess.ebiederm.org>
In-Reply-To: <m1mxyue31g.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2010 02:18 PM, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> On 02/27/2010 01:30 PM, Eric W. Biederman wrote:
>> then will have all irq_desc for ioapic stay with BSP node.
> 
> This is what I am thinking....
> 
> static void __init setup_IO_APIC_irqs(void)
> {
> 	int apic_id, pin, idx, irq;
> 	int notcon = 0;
> 	struct irq_desc *desc;
> 	struct irq_cfg *cfg;
> 	int node = cpu_to_node(boot_cpu_id);
> 
> 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
> 
> 	for(apic_id = 0; apic_id < nr_ioapics; apic_id++) {
> 		for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
> 			idx = find_irq_entry(apic_id, pin, mp_INT);
> 			if (idx == -1) {
> 				if (!notcon) {
> 					notcon = 1;
> 					apic_printk(APIC_VERBOSE,
> 						KERN_DEBUG " %d-%d",
> 						mp_ioapics[apic_id].apicid, pin);
> 				} else
> 					apic_printk(APIC_VERBOSE, " %d-%d",
> 						mp_ioapics[apic_id].apicid, pin);
> 				continue;
> 			}
> 			if (notcon) {
> 				apic_printk(APIC_VERBOSE,
> 					" (apicid-pin) not connected\n");
> 				notcon = 0;
> 			}
> 			
> 			irq = pin_2_irq(idx, apic_id, pin);
> 
> +			if ((apic_id > 0) && (irq > 16))
> +				continue;
looks right.

YH
