Return-Path: <linux-kernel-owner+w=401wt.eu-S1764082AbYBBPUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764082AbYBBPUz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 10:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYBBPUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 10:20:47 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:51689 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYBBPUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 10:20:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YHkcVtc5tqHusfeJXqu9wvfTt/okGmog3YjGAZ0YNKz86ugBS+MaLn3XoUT7QyDKa36RpUVTogDrH0E0FznJaNtZ/xudj2EUD4s7XEEOfco2KJsEIgURcbpj4hFZ4dVr9Dc62/Wm5p1uiCvWWH8+1Hce6lcl+sA+fP3ifDSRiiY=
Message-ID: <804dabb00802020720p2684dd1eyc29d1e1410407e08@mail.gmail.com>
Date: Sat, 2 Feb 2008 23:20:44 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Incompatibility of "const" and __xxxinitdata?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In include/linux/init.h, it is documented that all __xxxinitdata
declaration must not have constant, as show below:

 *
 * static int init_variable __initdata = 0;
 * static char linux_logo[] __initdata = { 0x32, 0x36, ... };
 *
 * Don't forget to initialize data not at file scope, i.e. within a function,
 * as gcc otherwise puts the data into the bss section and not into the init
 * section.
 *
 * Also note, that this data cannot be "const".
 */

In this same init.h is also documented the preferred way of
typecasting the variable with __initdata.

But searching through the source codes, I have found many instances of:

1.   constant occuring in the __xxxinitdata pattern, and
2.   non-conformance of the variable declaration according to the
codingstyle recommended.

Extracted out as below:

./drivers/media/dvb/cinergyT2/cinergyT2.c:
static const struct usb_device_id cinergyt2_table [] __devinitdata = {

./drivers/mmc/host/sdhci.c:
static const struct pci_device_id pci_ids[] __devinitdata = {

./drivers/mmc/host/ricoh_mmc.c:
static const struct pci_device_id pci_ids[] __devinitdata = {

./drivers/video/i810/i810_main.c:
static const char *i810_pci_list[] __devinitdata = {

./drivers/video/aty/aty128fb.c:
static const char *r128_family[] __devinitdata = {

./drivers/video/gxt4500.c:
static const struct fb_videomode defaultmode __devinitdata = {
static const struct fb_fix_screeninfo gxt4500_fix __devinitdata = {

./drivers/video/geode/gx1fb_core.c:
static const struct fb_videomode __initdata gx1_modedb[] = {

./drivers/video/geode/lxfb_core.c:
const struct fb_videomode geode_modedb[] __initdata = {

./drivers/video/geode/gxfb_core.c:
static const struct fb_videomode gx_modedb[] __initdata = {

./drivers/hwmon/w83627ehf.c:
        static const char __initdata sio_name_W83627EHF[] = "W83627EHF";
        static const char __initdata sio_name_W83627EHG[] = "W83627EHG";
        static const char __initdata sio_name_W83627DHG[] = "W83627DHG";

./drivers/hwmon/w83627hf.c:
        static const __initdata char *names[] = {

./drivers/macintosh/macio_asic.c:
static const struct pci_device_id __devinitdata pci_ids [] = { {

./drivers/edac/r82600_edac.c:
static const struct pci_device_id r82600_pci_tbl[] __devinitdata = {

./drivers/edac/i82975x_edac.c:
static const struct pci_device_id i82975x_pci_tbl[] __devinitdata = {

./drivers/edac/e752x_edac.c:
static const struct pci_device_id e752x_pci_tbl[] __devinitdata = {

./drivers/edac/i82875p_edac.c:
static const struct pci_device_id i82875p_pci_tbl[] __devinitdata = {

./drivers/edac/i5000_edac.c:
static const struct pci_device_id i5000_pci_tbl[] __devinitdata = {

./drivers/edac/e7xxx_edac.c:
static const struct pci_device_id e7xxx_pci_tbl[] __devinitdata = {

./drivers/edac/amd76x_edac.c:
static const struct pci_device_id amd76x_pci_tbl[] __devinitdata = {

./drivers/edac/i3000_edac.c:
static const struct pci_device_id i3000_pci_tbl[] __devinitdata = {

./drivers/edac/i82443bxgx_edac.c:
static const struct pci_device_id i82443bxgx_pci_tbl[] __devinitdata = {

./drivers/edac/i82860_edac.c:
static const struct pci_device_id i82860_pci_tbl[] __devinitdata = {

./drivers/ide/legacy/ali14xx.c:
static const int ports[ALI_NUM_PORTS] __initdata =
static const RegInitializer initData[] __initdata = {

./drivers/ide/pci/it821x.c:
static const struct ide_port_info it821x_chipsets[] __devinitdata = {

./drivers/ide/pci/amd74xx.c:
static const struct ide_port_info amd74xx_chipsets[] __devinitdata = {

./drivers/ide/pci/sc1200.c:
static const struct ide_port_info sc1200_chipset __devinitdata = {

./drivers/ide/pci/jmicron.c:
static const struct ide_port_info jmicron_chipset __devinitdata = {

./drivers/ide/pci/triflex.c:
static const struct ide_port_info triflex_device __devinitdata = {

./drivers/ide/pci/hpt34x.c:
static const struct ide_port_info hpt34x_chipsets[] __devinitdata = {

./drivers/ide/pci/cs5520.c:
static const struct ide_port_info cyrix_chipsets[] __devinitdata = {

./drivers/ide/pci/sis5513.c:
static const struct ide_port_info sis5513_chipset __devinitdata = {

./drivers/ide/pci/cy82c693.c:
static const struct ide_port_info cy82c693_chipset __devinitdata = {

./drivers/ide/pci/ns87415.c:
static const struct ide_port_info ns87415_chipset __devinitdata = {

./drivers/ide/pci/cmd64x.c:
static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {

./drivers/ide/pci/rz1000.c:
static const struct ide_port_info rz1000_chipset __devinitdata = {

./drivers/ide/pci/via82cxxx.c:
static const struct ide_port_info via82cxxx_chipset __devinitdata = {

./drivers/ide/pci/sl82c105.c:
static const struct ide_port_info sl82c105_chipset __devinitdata = {

./drivers/ide/pci/tc86c001.c:
static const struct ide_port_info tc86c001_chipset __devinitdata = {

./drivers/ide/pci/it8213.c:
static const struct ide_port_info it8213_chipsets[] __devinitdata = {

./drivers/ide/pci/cs5530.c:
static const struct ide_port_info cs5530_chipset __devinitdata = {

./drivers/ide/pci/cs5535.c:
static const struct ide_port_info cs5535_chipset __devinitdata = {

./drivers/ide/pci/scc_pata.c:
static const struct ide_port_info scc_chipsets[] __devinitdata = {

./drivers/ide/pci/siimage.c:
static const struct ide_port_info siimage_chipsets[] __devinitdata = {

./drivers/ide/pci/piix.c:
static const struct ide_port_info piix_pci_info[] __devinitdata = {

./drivers/ide/pci/serverworks.c:
static const struct ide_port_info serverworks_chipsets[] __devinitdata = {

./drivers/ide/pci/generic.c:
static const struct ide_port_info generic_chipsets[] __devinitdata = {

./drivers/ide/pci/atiixp.c:
static const struct ide_port_info atiixp_pci_info[] __devinitdata = {

./drivers/ide/pci/trm290.c:
static const struct ide_port_info trm290_chipset __devinitdata = {

./drivers/ide/pci/opti621.c:
static const struct ide_port_info opti621_chipsets[] __devinitdata = {

./drivers/ide/pci/hpt366.c:
static const struct hpt_info hpt36x __devinitdata = {
static const struct hpt_info hpt370 __devinitdata = {
static const struct hpt_info hpt370a __devinitdata = {
static const struct hpt_info hpt374 __devinitdata = {
static const struct hpt_info hpt372 __devinitdata = {
static const struct hpt_info hpt372a __devinitdata = {
static const struct hpt_info hpt302 __devinitdata = {
static const struct hpt_info hpt371 __devinitdata = {
static const struct hpt_info hpt372n __devinitdata = {
static const struct hpt_info hpt302n __devinitdata = {
static const struct hpt_info hpt371n __devinitdata = {
static const struct ide_port_info hpt366_chipsets[] __devinitdata = {

./drivers/ide/pci/slc90e66.c:
static const struct ide_port_info slc90e66_chipset __devinitdata = {

./drivers/ide/pci/aec62xx.c:
static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {

./drivers/ide/pci/alim15x3.c:
static const struct ide_port_info ali15x3_chipset __devinitdata = {

./drivers/ide/pci/pdc202xx_new.c:
static const struct ide_port_info pdcnew_chipsets[] __devinitdata = {

./drivers/ide/pci/pdc202xx_old.c:
static const struct ide_port_info pdc202xx_chipsets[] __devinitdata = {

./drivers/watchdog/sbc_epx_c3.c:
static const char banner[] __initdata =

./drivers/scsi/aic94xx/aic94xx_init.c:
static const struct pci_device_id aic94xx_pci_table[] __devinitdata = {

./drivers/char/mbcs.c:
static const struct cx_device_id __devinitdata mbcs_id_table[] = {

./drivers/atm/eni.c:
static const char *media_name[] __devinitdata = {

./drivers/net/tulip/winbond-840.c:
static const struct pci_id_info pci_id_tbl[] __devinitdata = {

./drivers/net/tulip/eeprom.c:
static const char *block_name[] __devinitdata = {

./drivers/net/bnx2x.c:
static const char version[] __devinitdata =

./drivers/net/sis190.c:
        static const u16 __devinitdata ids[] = { 0x0965, 0x0966, 0x0968 };

./drivers/net/bnx2.c:
static const char version[] __devinitdata =

./drivers/net/via-velocity.c:
static const struct velocity_info_tbl chip_info_table[] __devinitdata = {
static const struct pci_device_id velocity_id_table[] __devinitdata = {

./drivers/net/typhoon.c:
static const char version[] __devinitdata =
static const struct typhoon_card_info typhoon_card_info[] __devinitdata = {

./drivers/net/mlx4/main.c:
static const char mlx4_version[] __devinitdata =

./drivers/net/starfire.c:
static const char version[] __devinitdata =

./drivers/net/natsemi.c:
static const char version[] __devinitdata =
static const struct pci_device_id natsemi_pci_tbl[] __devinitdata = {

./drivers/net/fealnx.c:
static const struct chip_info skel_netdrv_tbl[] __devinitdata = {

./drivers/net/sundance.c:
static const struct pci_id_info pci_id_tbl[] __devinitdata = {

./drivers/net/ne3210.c:
static const char *ifmap[] __initdata = {"UTP", "?", "BNC", "AUI"};

./drivers/infiniband/hw/mlx4/main.c:
static const char mlx4_ib_version[] __devinitdata =

./drivers/infiniband/hw/mthca/mthca_main.c:
static const char mthca_version[] __devinitdata =

./drivers/mtd/maps/wr_sbc82xx_flash.c:
static const char *part_probes[] __initdata = {"cmdlinepart", "RedBoot", NULL};

./arch/x86/xen/enlighten.c:
static const struct pv_info xen_info __initdata = {
static const struct pv_init_ops xen_init_ops __initdata = {
static const struct pv_time_ops xen_time_ops __initdata = {
static const struct pv_cpu_ops xen_cpu_ops __initdata = {
static const struct pv_irq_ops xen_irq_ops __initdata = {
static const struct pv_apic_ops xen_apic_ops __initdata = {
static const struct pv_mmu_ops xen_mmu_ops __initdata = {
static const struct smp_ops xen_smp_ops __initdata = {
static const struct machine_ops __initdata xen_machine_ops = {

./arch/mips/mips-boards/malta/malta_setup.c:
        static const int pciclocks[] __initdata = {

./arch/mips/pci/fixup-mpc30x.c:
static const int internal_func_irqs[] __initdata = {
static const int irq_tab_mpc30x[] __initdata = {

./arch/frv/kernel/setup.c:
static const struct clock_cmode __pminitdata *clock_cmodes;

./arch/frv/mb93090-mb00/pci-irq.c:
static const uint8_t __initdata pci_bus0_irq_routing[32][4] = {

./arch/arm/mach-davinci/irq.c:
static const u8 default_priorities[DAVINCI_N_AINTC_IRQ] __initdata = {

./arch/arm/mach-at91/clock.c:
static struct clk *const standard_pmc_clocks[] __initdata = {

./arch/h8300/platform/h8s/ints_h8s.c:
const int __initdata h8300_saved_vectors[]={
const unsigned long __initdata h8300_trap_table[NR_TRAPS]={

./arch/powerpc/platforms/52xx/mpc52xx_pci.c:
const struct of_device_id mpc52xx_pci_ids[] __initdata = {

./net/ipv6/addrlabel.c:
static const __initdata struct ip6addrlbl_init_table

Will someone please comment?   In my personal understanding, it is
possible for __initdata to be both constant and non-constant, and at
the same time to have the __initdata property - two different
independent concept - or did I misunderstood something?

And if the above "const" is wrong, I can help to fix it - which is
basically removing the const and rearranging the __initdata's
position, am I correct?

Thank you very much.
