Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYGQG1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYGQG1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYGQG1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:27:36 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59553 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYGQG1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:27:35 -0400
Subject: Re: KVM overflows the stack
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
In-Reply-To: <1216248527.11664.9.camel@nimitz>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
	 <1206550329.7883.5.camel@nimitz.home.sr71.net>
	 <47EA80AC.4070204@qumranet.com>
	 <1206551794.7883.7.camel@nimitz.home.sr71.net>
	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>
	 <1206629709.7883.30.camel@nimitz.home.sr71.net>
	 <47EBB63E.2060306@qumranet.com>
	 <1212445810.8211.9.camel@nimitz.home.sr71.net>
	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>
	 <48512028.3070104@qumranet.com>  <1216148242.25942.6.camel@nimitz>
	 <1216244660.8711.6.camel@nimitz>  <1216248527.11664.9.camel@nimitz>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 23:27:29 -0700
Message-Id: <1216276049.11664.16.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A newer gcc (4.2) makes this a wee bit better, but probably still
worrisome.

dave@nimitz:~/src/kvm-userspace-virgin/kernel$ objdump -d *.ko | perl /home/dave/kernels/linux-2.6.git-t61/scripts/checkstack.pl i386
0x00007b33 kvm_arch_vm_ioctl [kvm]:			1164
0x000072e8 kvm_arch_vcpu_ioctl [kvm]:			1060
0x00007497 kvm_arch_vcpu_ioctl [kvm]:			1060
0x0000adad kvm_pv_mmu_op [kvm]:				564
0x0000ae6b kvm_pv_mmu_op [kvm]:				564
0x00002553 kvm_vcpu_ioctl [kvm]:			468
0x0000d7e8 paging64_prefetch_page [kvm]:		304
0x0000d926 paging64_prefetch_page [kvm]:		304
0x0000d936 paging64_prefetch_page [kvm]:		304
0x0000c118 paging32_prefetch_page [kvm]:		300
0x0000c146 paging32_prefetch_page [kvm]:		300
0x0000c286 paging32_prefetch_page [kvm]:		300
0x0000f1eb x86_emulate_insn [kvm]:			192
0x0000f372 x86_emulate_insn [kvm]:			192
0x0000f5f2 x86_emulate_insn [kvm]:			192
0x00005373 kvm_task_switch [kvm]:			172
0x00001466 __kvm_set_memory_region [kvm]:		164
0x000014da __kvm_set_memory_region [kvm]:		164
0x0000dae8 paging64_page_fault [kvm]:			156
0x0000db06 paging64_page_fault [kvm]:			156
0x0000db67 paging64_page_fault [kvm]:			156
0x0000dcd5 paging64_page_fault [kvm]:			156
0x0000dcf1 paging64_page_fault [kvm]:			156
0x0000c356 kvm_mmu_pte_write [kvm]:			152
0x0000c50a kvm_mmu_pte_write [kvm]:			152
0x0000df28 paging32_page_fault [kvm]:			144
0x0000df46 paging32_page_fault [kvm]:			144
0x0000dfa7 paging32_page_fault [kvm]:			144
0x0000e115 paging32_page_fault [kvm]:			144
0x0000e131 paging32_page_fault [kvm]:			144
0x00014ed3 apic_mmio_read [kvm]:			108

-- Dave

