Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbYDNJPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbYDNJPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750710AbYDNJOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:14:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:25639 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYDNJOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:14:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=KlgOfogHbqYWfoAGk079Rga0dBfdDrFGZKNHvpyO98JlKs9+B1PdXJSiS9NIEFF5HjnUC1+mb0X3Kgit3LK5USqHlgXu+3n0KMAjVEjFxlnBmBMVEMnR5E1dcoHokjoWHWVn22aTrBQmu3c2WoEdgKdNaujthec5ToXa/GkYmkY=
Message-ID: <48031FA7.9050803@gmail.com>
Date: Mon, 14 Apr 2008 11:11:03 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pgtable_32.h - prototype and section mismatch fixes
References: <48022990.3060104@gmail.com> <20080414072645.GG16163@elte.hu> <20080414084127.GA11372@uranus.ravnborg.org> <20080414085307.GG19865@elte.hu> <20080414085927.GC11372@uranus.ravnborg.org>
In-Reply-To: <20080414085927.GC11372@uranus.ravnborg.org>
Content-Type: multipart/mixed;
 boundary="------------030105050004050500020904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030105050004050500020904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sam Ravnborg pisze:
> On Mon, Apr 14, 2008 at 10:53:07AM +0200, Ingo Molnar wrote:
>> * Sam Ravnborg <sam@ravnborg.org> wrote:
>>
>>>> hm, that's an interesting case: we need those annotations probably 
>>>> because gcc decided to not inline those functions. (this is possible 
>>>> via the new CONFIG_OPTIMIZE_INLINING=y option) Sam, what's your take 
>>>> on that?
>>> gcc uses different heuristics for inlining between the different 
>>> versions. Therefore to achieve somehow predictable results I added 
>>> -fno-inline-functions-called-once when CONFIG_DEBUG_SECTION_MISMATCH 
>>> is enabled.
>>>
>>> So in the above case for any normal kernel build we would see that gcc 
>>> inlined the above and everything is fine. But for the 
>>> CONFIG_DEBUG_SECTION_MISMTCH cases we do not inline and thus we see 
>>> that we have a section mismatch.
>> ah, ok. So i guess this will result in a few isolated cases of __init 
>> annotations added to inline functions - Jacek fixed one such case - but 
>> it should not result in the general spreading of __init annotations to 
>> inline functions, correct? (which i was worried about)
> I do not think so. The need for small isolated inline functions
> in the init paths are minimal and last I did a section mismatch free
> sweep on the kernel it was only few if any inline functions(*) I had
> to annotate.
> 
> (*) Considering only the minimal amount of function that ought
> to be annotated inlined.

There's a lot of inline __init functions already - which, on the other hand
should not result in more of such. Attached you can find grep on tree which
shows all inline __init functions (you won't find my paravirt_pagetable_setup_*
functions in output as I removed __init for test).

Sam, do -fno-inline-functions-called-once could affect
paravirt_pagetable_setup_done? In general there was no section mismatch warning
for this function, but I've annotated it also.

-Jacek



--------------030105050004050500020904
Content-Type: text/plain;
 name="inline__init.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="inline__init.log"

1225:static inline int __init ace_of_register(void)
1237:static inline int __init ace_of_register(void) { return 0; }
./drivers/block/xsysace.c
809:static inline int __init hwicap_of_register(void)
821:static inline int __init hwicap_of_register(void) { return 0; }
./drivers/char/xilinx_hwicap/xilinx_hwicap.c
195:static inline int __init
./drivers/net/wan/sbni.c
776:static inline void __init fs_subset_descriptors(void)
876:static inline void __init hs_subset_descriptors(void)
./drivers/usb/gadget/ether.c
47:static inline void __init show_version (void) {
./drivers/atm/ambassador.c
57:static inline void __init show_version (void) {
./drivers/atm/horizon.c
66:static inline void __init set_phy_reg(struct ti_ohci *ohci, u8 addr, u8 data)
81:static inline void __init init_ohci1394_soft_reset(struct ti_ohci *ohci) {
95:static inline void __init init_ohci1394_initialize(struct ti_ohci *ohci)
167:static inline void __init init_ohci1394_wait_for_busresets(struct ti_ohci *ohci)
185:static inline void __init init_ohci1394_enable_physical_dma(struct ti_ohci *hci)
196:static inline void __init init_ohci1394_reset_and_init_dma(struct ti_ohci *ohci)
225:static inline void __init init_ohci1394_controller(int num, int slot, int func)
./drivers/ieee1394/init_ohci1394_dma.c
91:static inline int __init doccheck(void __iomem *potential, unsigned long physadr)
./drivers/mtd/devices/docprobe.c
1111:static inline int __init nftl_partscan(struct mtd_info *mtd, struct mtd_partition *parts)
1214:static inline int __init inftl_partscan(struct mtd_info *mtd, struct mtd_partition *parts)
1433:static inline int __init doc2000_init(struct mtd_info *mtd)
1450:static inline int __init doc2001_init(struct mtd_info *mtd)
1481:static inline int __init doc2001plus_init(struct mtd_info *mtd)
./drivers/mtd/nand/diskonchip.c
975:static inline int __init
./drivers/parisc/pdc_stable.c
19:static inline void __init pcmcia_setup_ioctl(void) { return; }
./drivers/pcmcia/ds_internal.h
616:static inline int __init ulite_of_register(void)
628:static inline int __init ulite_of_register(void) { return 0; }
./drivers/serial/uartlite.c
480:static inline int __init xilinxfb_of_register(void)
492:static inline int __init xilinxfb_of_register(void) { return 0; }
./drivers/video/xilinxfb.c
136:static inline void __init eat(unsigned n)
./init/initramfs.c
3290:static inline void __init set_pageblock_order(unsigned int order)
./mm/page_alloc.c
1086:static inline int __init
./net/irda/irnet/irnet_ppp.c
352:static inline int __init probe_pas(struct address_info *hw_config)
./sound/oss/pas2_card.c
257:static inline int __init probe_v_midi(struct address_info *hw_config)
./sound/oss/v_midi.c
2071:static inline void __init unlock_ExtINT_logic(void)
2129:static inline void __init check_timer(void)
./arch/x86/kernel/io_apic_32.c
493:static inline void __init construct_default_ISA_mptable(int mpc_default_type)
./arch/x86/kernel/mpparse.c
126:static inline int __init
146:static inline int __init
./arch/x86/kernel/e820_64.c
1602:static inline void __init unlock_ExtINT_logic(void)
1657:static inline void __init check_timer(void)
./arch/x86/kernel/io_apic_64.c
1259:static inline int __init determine_tce_table_size(u64 ram)
./arch/x86/kernel/pci-calgary_64.c
540:static inline void __init reserve_crashkernel(void)
./arch/x86/kernel/setup_32.c
259:static inline void __init reserve_crashkernel(void)
./arch/x86/kernel/setup_64.c
596:static inline int __init check_vmi_rom(struct vrom_header *rom)
663:static inline int __init probe_vmi_rom(void)
744:static inline int __init activate_vmi(void)
./arch/x86/kernel/vmi_32.c
478:static inline void __init early_set_fixmap(enum fixed_addresses idx,
487:static inline void __init early_clear_fixmap(enum fixed_addresses idx)
./arch/x86/mm/ioremap.c
84:static inline void __init
96:static inline void __init
./arch/alpha/kernel/smp.c
193:static inline int __init
223:static inline int __init
238:static inline void __init
245:static inline void __init
294:static inline int __init
311:static inline void __init
./arch/alpha/kernel/sys_cabriolet.c
57:static inline void __init
147:static inline int __init
186:static inline int __init
205:static inline void __init
214:static inline void __init
./arch/alpha/kernel/sys_sio.c
123:static inline void __init sdp2430_init_smc91x(void)
./arch/arm/mach-omap2/board-2430sdp.c
186:static inline void __init apollon_init_smc91x(void)
./arch/arm/mach-omap2/board-apollon.c
256:static inline void __init h4_init_debug(void)
./arch/arm/mach-omap2/board-h4.c
82:static inline void __init omap_serial_reset(struct plat_serial8250_port *p)
./arch/arm/mach-omap2/serial.c
254:static inline void __init setup_crashkernel(unsigned long total, int *n)
386:static inline int __init
./arch/ia64/kernel/setup.c
203:static inline int __init is_shub_1_1(int nasid)
696:static inline int __init board_needs_cnode(int type)
./arch/ia64/sn/kernel/setup.c
148:static inline int __init indy_sc_probe(void)
./arch/mips/mm/sc-ip22.c
55:static inline int __init mips_sc_probe(void)
./arch/mips/mm/sc-mips.c
80:static inline int __init r5k_sc_probe(void)
./arch/mips/mm/sc-r5k.c
270:static inline void __init
./arch/parisc/kernel/processor.c
171:static inline void __init sio_write(u8 val, u8 index)
./arch/powerpc/platforms/chrp/setup.c
60:static inline int __init
./arch/ppc/platforms/lopec.c
27:static inline int __init
./arch/ppc/platforms/pal4_pci.c
300:static inline int __init
./arch/ppc/platforms/powerpmc250.c
166:static inline void __init reserve_crashkernel(void)
./arch/sh/kernel/setup.c
46:static inline void __init smp_store_cpu_info(unsigned int cpu)
./arch/sh/kernel/smp.c
777:static inline void __init gdb_vbr_init(void)
./arch/sh/kernel/traps_32.c
16:static inline void __init check_bugs(void)
./include/asm-mn10300/bugs.h
36:static inline void __init smpboot_setup_io_apic(void)
./include/asm-x86/mach-default/smpboot_hooks.h

--------------030105050004050500020904--
