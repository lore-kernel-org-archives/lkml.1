Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbXIBFQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbXIBFQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 01:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbXIBFQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 01:16:15 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60118 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbXIBFQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 01:16:14 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 2 Sep 2007 01:04:41 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Denis Cheng <crquan@gmail.com>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/ipv4/af_inet.c: use ARRAY_SIZE macro from kernel.h
 instead
In-Reply-To: <11887091471748-git-send-email-crquan@gmail.com>
Message-ID: <Pine.LNX.4.64.0709020100180.17742@localhost.localdomain>
References: <11887091471748-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007, Denis Cheng wrote:

> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  net/ipv4/af_inet.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index e681034..d5e8b67 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -939,7 +939,7 @@ static struct inet_protosw inetsw_array[] =
>         }
>  };
>
> -#define INETSW_ARRAY_LEN (sizeof(inetsw_array) / sizeof(struct inet_protosw))
> +#define INETSW_ARRAY_LEN ARRAY_SIZE(inetsw_array)
>
>  void inet_register_protosw(struct inet_protosw *p)
>  {

denis:

if you're planning on doing this ARRAY_SIZE cleanup fairly rigorously,
here's an overview of what you're looking (based on a fairly dumb
scanning script that undoubtedly generates some false positives).  of
course, the respective subsystem maintainers are welcome to deal with
them first, of course.

p.s.  and when you submit those patches, it's necessary to submit them
to only the appropriate subsystem mailing lists, not to the LKML in
general.


===== Where ARRAY_SIZE() might be used ...

./Documentation/CodingStyle:  #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
./Documentation/hpet.txt:	for (i = 0; i < (sizeof (hpet_command) / sizeof (hpet_command[0])); i++)
./Documentation/spi/spidev_test.c:#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
./include/acpi/acmacros.h:#define ACPI_ARRAY_LENGTH(x)            (sizeof(x) / sizeof((x)[0]))
./include/linux/netfilter/xt_sctp.h:#define ELEMCOUNT(x) (sizeof(x)/sizeof(x[0]))
./include/linux/kernel.h:#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
./include/asm-parisc/mmzone.h:	BUG_ON(i >= sizeof(pfnnid_map) / sizeof(pfnnid_map[0]));
./include/asm-sh/hw_irq.h:#define _INTC_ARRAY(a) a, sizeof(a)/sizeof(*a)
./include/video/sgivw.h:#define DBE_VT_SIZE  (sizeof(dbeVTimings)/sizeof(dbeVTimings[0]))
./include/net/ip_vs.h:#define IP_VS_INIT_HASH_TABLE(t) ip_vs_init_hash_table(t, sizeof(t)/sizeof(t[0]))
./kernel/compat.c:		for (j = 0; j < sizeof(m)/sizeof(um); j++) {
./kernel/compat.c:		for (j = 0; j < sizeof(m)/sizeof(um); j++) {
./arch/m68k/amiga/amisound.c:#define DATA_SIZE	(sizeof(sine_data)/sizeof(sine_data[0]))
./arch/i386/boot/compressed/relocs.c:#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
./arch/x86_64/kernel/smpboot.c:	for (i = 0; i < sizeof(regs) / sizeof(*regs); i++) {
./arch/mips/au1000/common/dbdma.c:#define DBDEV_TAB_SIZE (sizeof(dbdev_tab) / sizeof(dbdev_tab_t))
./arch/cris/arch-v10/kernel/setup.c:	if (revision >= sizeof cpu_info/sizeof *cpu_info)
./arch/cris/arch-v10/kernel/setup.c:		info = &cpu_info[sizeof cpu_info/sizeof *cpu_info - 1];
./arch/um/include/user.h:#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
./arch/um/kernel/tt/ptproxy/ptrace.c:		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
./arch/um/kernel/tt/ptproxy/ptrace.c:		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
./arch/um/kernel/tt/ptproxy/ptrace.c:		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
./arch/um/kernel/tt/ptproxy/ptrace.c:		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
./arch/um/kernel/tt/ptproxy/ptrace.c:		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
./arch/um/kernel/tt/ptproxy/ptrace.c:		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
./arch/arm/kernel/dma-isa.c:		for (i = 0; i < sizeof(dma_resources) / sizeof(dma_resources[0]); i++)
./arch/avr32/mach-at32ap/time-tc.c:	int divs_size = sizeof(divs) / sizeof(*divs);
./arch/powerpc/platforms/celleb/scc_sio.c:	for(i = 0; i < sizeof(txx9_scc_tab)/sizeof(txx9_scc_tab[0]); i++) {
./arch/powerpc/boot/types.h:#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
./scripts/mod/file2alias.c:#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
./drivers/char/synclink_gt.c:	static unsigned int count = sizeof(patterns)/sizeof(patterns[0]);
./drivers/mtd/nand/excite_nandflash.c:				   sizeof partition_info / sizeof partition_info[0]);
./drivers/message/fusion/mptbase.c:		if (u16cnt < sizeof(ioc->hs_reply) / sizeof(ioc->hs_reply[0]))
./drivers/serial/mcfserial.c:			(sizeof(mcfrs_baud_table)/sizeof(mcfrs_baud_table[0]))
./drivers/serial/68328serial.c:#define BAUD_TABLE_SIZE (sizeof(baud_table)/sizeof(baud_table[0]))
./drivers/serial/68328serial.c:	for (i = 0; i < sizeof(baud_table) / sizeof(baud_table[0]); i++)
./drivers/serial/68328serial.c:	if (i >= sizeof(baud_table) / sizeof(baud_table[0])) {
./drivers/zorro/names.c:#define MANUF( manuf, name )		{ 0x##manuf, sizeof(__prods_##manuf) / sizeof(struct zorro_prod_info), __manufstr_##manuf, __prods_##manuf },
./drivers/media/video/saa7134/saa7134-tvaudio.c:#define TVAUDIO (sizeof(tvaudio)/sizeof(struct saa7134_tvaudio))
./drivers/media/video/tveeprom.c:#define STRM(array,i) (i < sizeof(array)/sizeof(char*) ? array[i] : "unknown")
./drivers/media/video/mxb.c:	.num_stds	= sizeof(standard)/sizeof(struct saa7146_standard),
./drivers/media/video/dpc7146.c:	.num_stds	= sizeof(standard)/sizeof(struct saa7146_standard),
./drivers/media/dvb/ttpci/budget-av.c:	.num_stds = sizeof(standard) / sizeof(struct saa7146_standard),
./drivers/pcmcia/i82365.c:#define PCIC_COUNT	(sizeof(pcic)/sizeof(pcic_t))
./drivers/isdn/hardware/eicon/message.c:      i<(sizeof(ftable)/sizeof(struct _ftable));
./drivers/net/zorro8390.c:	for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++) {
./drivers/net/lp486e.c:#define SIZE(x)	(sizeof(x)/sizeof((x)[0]))
./drivers/net/irda/actisys-sir.c:#define MAX_SPEEDS (sizeof(baud_rates)/sizeof(baud_rates[0]))
./drivers/net/ne-h8300.c:		for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++)
./drivers/net/cs89x0.c:			if (i >= sizeof(cs8900_irq_map)/sizeof(cs8900_irq_map[0]))
./drivers/net/cs89x0.c:		for (i = 0; i != sizeof(cs8900_irq_map)/sizeof(cs8900_irq_map[0]); i++)
./drivers/net/cs89x0.c:		if (i == sizeof(cs8900_irq_map)/sizeof(cs8900_irq_map[0]))
./drivers/net/netxen/netxen_nic_hw.c:		for (i = 0; i < (sizeof(locs) / sizeof(locs[0])); i++) {
./drivers/net/skfp/smt.c:#define N_SMT_PLEN	(sizeof(smt_pdef)/sizeof(smt_pdef[0]))
./drivers/net/skfp/srf.c:#define MAX_EVCS	(sizeof(smc->evcs)/sizeof(smc->evcs[0]))
./drivers/net/skfp/srf.c:#define MAX_INIT_EVC	(sizeof(evc_inits)/sizeof(evc_inits[0]))
./drivers/net/apne.c:	for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++) {
./drivers/net/ne2k-pci.c:		for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++)
./drivers/net/atl1/atl1_hw.c:	if (hw->flash_vendor >= sizeof(flash_table) / sizeof(flash_table[0]))
./drivers/net/pcmcia/axnet_cs.c:    for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++)
./drivers/net/pcmcia/pcnet_cs.c:#define NR_INFO		(sizeof(hw_info)/sizeof(hw_info_t))
./drivers/net/pcmcia/pcnet_cs.c:    for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++)
./drivers/net/arm/am79c961a.c:	for (i = 0; i < sizeof(multi_hash) / sizeof(multi_hash[0]); i++)
./drivers/net/ne.c:		for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++)
./drivers/net/ibm_emac/ibm_emac_debug.c:	if (idx >= sizeof(__emacs) / sizeof(__emacs[0])) {
./drivers/net/ibm_emac/ibm_emac_debug.c:	if (idx >= sizeof(__mals) / sizeof(__mals[0])) {
./drivers/net/ibm_emac/ibm_emac_debug.c:	for (i = 0; i < sizeof(__mals) / sizeof(__mals[0]); ++i)
./drivers/net/ibm_emac/ibm_emac_debug.c:	for (i = 0; i < sizeof(__emacs) / sizeof(__emacs[0]); ++i)
./drivers/net/fec_8xx/fec_mii.c:	for (i = 0, phy = phy_info; i < sizeof(phy_info) / sizeof(phy_info[0]);
./drivers/net/fec_8xx/fec_mii.c:	if (i >= sizeof(phy_info) / sizeof(phy_info[0])) {
./drivers/net/atarilance.c:#define	N_LANCE_ADDR	(sizeof(lance_addr_list)/sizeof(*lance_addr_list))
./drivers/net/ne2.c:		for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++)
./drivers/net/wireless/libertas/fw.c:	for (i = 0; i < sizeof(adapter->wep_keys) / sizeof(adapter->wep_keys[0]);
./drivers/net/wireless/libertas/main.c:	end = sizeof(region_cfp_table)/sizeof(struct region_cfp_table);
./net/atm/proc.c:	    vcc->qos.aal >= sizeof(aal_name)/sizeof(aal_name[0]) ? "err" :


rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
