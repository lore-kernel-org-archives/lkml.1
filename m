Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbYGLWq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbYGLWq3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 18:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbYGLWqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 18:46:21 -0400
Received: from mercury.realtime.net ([205.238.132.86]:33861 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752314AbYGLWqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 18:46:19 -0400
In-Reply-To: <e6b3109a0ab047bea58ceecb8734761d@bga.com>
References: <for-27-patch1-0@bga.com> <for-27-patch9@bga.com> <20080712041137.GA5933@kroah.com> <e6b3109a0ab047bea58ceecb8734761d@bga.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <0a67ecbf69649dce778db1b463e59c3a@bga.com>
Content-Transfer-Encoding: 7bit
Cc: Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Date: Sat, 12 Jul 2008 17:48:11 -0500
To: Milton Miller <miltonm@bga.com>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 12, 2008, at 4:08 PM, Milton Miller wrote:

> You left out:
>>> Searching the next-20080709 tree shows the bit is set by exactly 3 
>>> pci
>>> drivers.  However, the use of per-match-entry driver data is much 
>>> more
>>> prevalent: A boot of allyesconfig on a powerpc64 pseries with a 
>>> debug patch
>>> shows 27 drivers apparently use the field for a pointer, 14 use it 
>>> for
>>> setting flags, and 98 use it as a table index.  (Pointers are 
>>> defined as
>>> >PAGE_OFFSET, aka in the 64 bit kernel linear mapping.  Flags are 
>>> defined as
>>> the maximum value exceeds the number of entries in the match table.  
>>> Any
>>> other nonzero value is classified as an index).
>
> I did the work to establish the scope of the problem.
>

For the record or independent investigation, here is the patch and grep 
of
output from the kernel log.   Hopefully you can read them after this 
mailer
mangles them.

milton

[   30.412634] PCI Driver CyberPro(in cyber2000fb) uses data 3/3 times 
for indexes
[   30.418967] PCI Driver aty128fb(in aty128fb) uses data 37/47 times 
for indexes
[   30.419787] PCI Driver radeonfb(in radeonfb) uses data 98/98 times 
for flags
[   30.421104] PCI Driver sisfb(in sisfb) uses data 11/12 times for 
indexes
[   30.422332] PCI Driver savagefb(in savagefb) uses data 23/23 times 
for flags
[   30.423088] PCI Driver neofb(in neofb) uses data 9/9 times for flags
[   30.424431] PCI Driver imsttfb(in imsttfb) uses data 1/2 times for 
indexes
[   30.427089] PCI Driver s3fb(in s3fb) uses data 12/12 times for flags
[   30.428495] PCI Driver sstfb(in sstfb) uses data 1/2 times for 
indexes
[   30.429439] PCI Driver cirrusfb(in cirrusfb) uses data 11/11 times 
for indexes
[   30.431251] PCI Driver gxt4500(in gxt4500) uses data 1/2 times for 
indexes
[   33.082152] PCI Driver epca(in epca) uses data 3/4 times for indexes
[   37.857569] PCI Driver serial(in 8250_pci) uses data 177/180 times 
for indexes
[   37.868296] PCI Driver jsm(in jsm) uses data 4/5 times for indexes
[   37.901045] PCI Driver parport_pc(in parport_pc) uses data 52/53 
times for indexes
[   37.906019] PCI Driver parport_serial(in parport_serial) uses data 
30/31 times for indexes
[   38.253736] PCI Driver DAC960(in DAC960) uses data 7/7 times for 
pointers
[   38.983951] PCI Driver e1000e(in e1000e) uses data 29/38 times for 
indexes
[   39.026014] PCI Driver Sundance Technology IPG Triple-Speed 
Ethernet(in ipg) uses data 5/6 times for indexes
[   39.033218] PCI Driver cxgb(in cxgb) uses data 5/7 times for indexes
[   39.039465] PCI Driver cxgb3(in cxgb3) uses data 9/10 times for 
indexes
[   39.092305] PCI Driver 3c59x(in 3c59x) uses data 37/38 times for 
indexes
[   39.098029] PCI Driver typhoon(in typhoon) uses data 12/13 times for 
indexes
[   39.103976] PCI Driver ne2k-pci(in ne2k_pci) uses data 10/11 times 
for indexes
[   39.122763] PCI Driver e100(in e100) uses data 36/41 times for 
indexes
[   39.129041] PCI Driver tlan(in tlan) uses data 12/13 times for 
indexes
[   39.141155] PCI Driver epic100(in epic100) uses data 2/3 times for 
indexes
[   39.146232] PCI Driver sis190(in sis190) uses data 1/2 times for 
indexes
[   39.151792] PCI Driver sis900(in sis900) uses data 1/2 times for 
indexes
[   39.161699] PCI Driver yellowfin(in yellowfin) uses data 1/2 times 
for indexes
[   39.173144] PCI Driver natsemi(in natsemi) uses data 1/2 times for 
indexes
[   39.184923] PCI Driver fealnx(in fealnx) uses data 2/3 times for 
indexes
[   39.196097] PCI Driver bnx2(in bnx2) uses data 8/9 times for indexes
[   39.201880] PCI Driver bnx2x(in bnx2x) uses data 2/3 times for 
indexes
[   39.347752] PCI Driver sundance(in sundance) uses data 6/7 times for 
indexes
[   39.372095] PCI Driver forcedeth(in forcedeth) uses data 39/39 times 
for flags
[   39.426772] PCI Driver 8139too(in 8139too) uses data 1/23 times for 
indexes
[   39.455602] PCI Driver r8169(in r8169) uses data 3/10 times for 
indexes
[   39.508688] PCI Driver tmspci(in tmspci) uses data 3/4 times for 
indexes
[   39.520548] PCI Driver fst(in farsync) uses data 7/7 times for 
indexes
[   39.530531] PCI Driver pc300(in pc300) uses data 6/6 times for flags
[   39.559427] PCI Driver com20020(in com20020_pci) uses data 16/24 
times for indexes
[   39.832122] PCI Driver iwl3945(in iwl3945) uses data 6/6 times for 
pointers
[   39.839834] PCI Driver iwl4965(in iwl4965) uses data 5/5 times for 
pointers
[   39.845806] PCI Driver rt2400pci(in rt2400pci) uses data 1/1 times 
for pointers
[   39.851029] PCI Driver rt2500pci(in rt2500pci) uses data 1/1 times 
for pointers
[   39.856159] PCI Driver rt61pci(in rt61pci) uses data 3/3 times for 
pointers
[   39.877628] PCI Driver ath5k_pci(in ath5k) uses data 17/19 times for 
indexes
[   39.942037] PCI Driver dmfe(in dmfe) uses data 4/4 times for flags
[   39.949311] PCI Driver winbond-840(in winbond_840) uses data 2/3 
times for indexes
[   39.955770] PCI Driver de2104x(in de2104x) uses data 1/2 times for 
indexes
[   39.961608] PCI Driver tulip(in tulip) uses data 35/35 times for 
indexes
[   39.967483] PCI Driver de4x5(in de4x5) uses data 3/4 times for 
indexes
[   39.974029] PCI Driver uli526x(in uli526x) uses data 2/2 times for 
flags
[   40.101590] PCI Driver via-ircc(in via_ircc) uses data 4/5 times for 
indexes
[   40.150602] PCI Driver sfc(in sfc) uses data 2/2 times for pointers
[   40.273109] PCI Driver saa7134(in saa7134) uses data 169/173 times 
for flags
[   40.385014] PCI Driver Multimedia eXtension Board(in saa7146) uses 
data 1/1 times for pointers
[   40.392699] PCI Driver hexium HV-PCI6 Orion(in saa7146) uses data 
3/3 times for pointers
[   40.399454] PCI Driver hexium gemini(in saa7146) uses data 2/2 times 
for pointers
[   40.405585] PCI Driver dpc7146 demonstration board(in saa7146) uses 
data 1/1 times for pointers
[   40.694876] PCI Driver budget dvb(in saa7146) uses data 9/9 times 
for pointers
[   40.701401] PCI Driver budget_av(in saa7146) uses data 25/25 times 
for pointers
[   40.707745] PCI Driver budget_ci dvb(in saa7146) uses data 7/7 times 
for pointers
[   40.715095] PCI Driver budget_patch dvb(in saa7146) uses data 1/1 
times for pointers
[   40.722309] PCI Driver dvb(in saa7146) uses data 11/11 times for 
pointers
[   40.757291] PCI Driver bt878(in bt878) uses data 12/12 times for 
pointers
[   40.922318] PCI Driver fore_200e(in fore_200e) uses data 1/1 times 
for pointers
[   40.928212] PCI Driver eni(in eni) uses data 1/2 times for indexes
[   41.017464] PCI Driver AEC62xx_IDE(in <NULL>) uses data 4/5 times 
for indexes
[   41.023069] PCI Driver ALI15x3_IDE(in <NULL>) uses data 1/2 times 
for indexes
[   41.028564] PCI Driver AMD_IDE(in <NULL>) uses data 22/23 times for 
indexes
[   41.038241] PCI Driver CMD64x_IDE(in <NULL>) uses data 3/4 times for 
indexes
[   41.043407] PCI Driver Cyrix_IDE(in <NULL>) uses data 1/2 times for 
indexes
[   41.057769] PCI Driver HPT366_IDE(in <NULL>) uses data 5/6 times for 
indexes
[   41.084702] PCI Driver Promise_Old_IDE(in <NULL>) uses data 4/5 
times for indexes
[   41.086387] PCI Driver Promise_IDE(in <NULL>) uses data 6/7 times 
for indexes
[   41.086833] PCI Driver PIIX_IDE(in <NULL>) uses data 24/25 times for 
indexes
[   41.087269] PCI Driver Serverworks_IDE(in <NULL>) uses data 4/5 
times for indexes
[   41.087687] PCI Driver SiI_IDE(in <NULL>) uses data 2/3 times for 
indexes
[   41.090972] PCI Driver VIA_IDE(in <NULL>) uses data 2/5 times for 
indexes
[   41.091405] PCI Driver PCI_IDE(in <NULL>) uses data 14/15 times for 
indexes
[   41.296455] PCI Driver aacraid(in aacraid) uses data 63/64 times for 
indexes
[   41.314088] PCI Driver aic94xx(in aic94xx) uses data 9/9 times for 
indexes
[   41.333209] PCI Driver qla1280(in qla1280) uses data 5/6 times for 
indexes
[   41.370864] PCI Driver dmx3191d(in dmx3191d) uses data 1/1 times for 
flags
[   41.473648] PCI Driver ipr sets use_driver_data
[   41.474349] PCI Driver ipr(in ipr) uses data 11/23 times for indexes
[   50.137032] PCI Driver hptiop(in hptiop) uses data 13/13 times for 
pointers
[   50.137434] PCI Driver stex(in stex) uses data 7/11 times for indexes
[   50.137794] PCI Driver mvsas(in mvsas) uses data 4/5 times for 
indexes
[   50.821457] PCI Driver ahci(in ahci) uses data 24/115 times for 
indexes
[   50.821921] PCI Driver sata_svw(in sata_svw) uses data 3/7 times for 
indexes
[   50.822295] PCI Driver ata_piix(in ata_piix) uses data 46/47 times 
for indexes
[   50.822788] PCI Driver sata_promise(in sata_promise) uses data 13/17 
times for indexes
[   50.823838] PCI Driver sata_sil(in sata_sil) uses data 4/7 times for 
indexes
[   50.824261] PCI Driver sata_sil24(in sata_sil24) uses data 4/6 times 
for indexes
[   50.824675] PCI Driver sata_via(in sata_via) uses data 1/7 times for 
indexes
[   50.826219] PCI Driver sata_nv(in sata_nv) uses data 11/14 times for 
indexes
[   50.826611] PCI Driver sata_uli(in sata_uli) uses data 2/3 times for 
indexes
[   50.826979] PCI Driver sata_mv(in sata_mv) uses data 14/16 times for 
indexes
[   50.828821] PCI Driver pata_amd(in pata_amd) uses data 19/20 times 
for indexes
[   50.829188] PCI Driver pata_artop(in pata_artop) uses data 4/5 times 
for indexes
[   50.830278] PCI Driver pata_cmd64x(in pata_cmd64x) uses data 3/4 
times for flags
[   50.836264] PCI Driver pata_opti(in pata_opti) uses data 1/2 times 
for indexes
[   50.838717] PCI Driver pata_pdc2027x(in pata_pdc2027x) uses data 5/7 
times for indexes
[   50.839105] PCI Driver pata_pdc202xx_old(in pata_pdc202xx_old) uses 
data 4/5 times for indexes
[   50.840546] PCI Driver pata_serverworks(in pata_serverworks) uses 
data 4/5 times for indexes
[   50.843885] PCI Driver ata_generic(in ata_generic) uses data 1/13 
times for indexes
[   50.137032] PCI Driver hptiop(in hptiop) uses data 13/13 times for 
pointers
[   50.137434] PCI Driver stex(in stex) uses data 7/11 times for indexes
[   50.137794] PCI Driver mvsas(in mvsas) uses data 4/5 times for 
indexes
[   50.821457] PCI Driver ahci(in ahci) uses data 24/115 times for 
indexes
[   50.821921] PCI Driver sata_svw(in sata_svw) uses data 3/7 times for 
indexes
[   50.822295] PCI Driver ata_piix(in ata_piix) uses data 46/47 times 
for indexes
[   50.822788] PCI Driver sata_promise(in sata_promise) uses data 13/17 
times for indexes
[   50.823838] PCI Driver sata_sil(in sata_sil) uses data 4/7 times for 
indexes
[   50.824261] PCI Driver sata_sil24(in sata_sil24) uses data 4/6 times 
for indexes
[   50.824675] PCI Driver sata_via(in sata_via) uses data 1/7 times for 
indexes
[   50.826219] PCI Driver sata_nv(in sata_nv) uses data 11/14 times for 
indexes
[   50.826611] PCI Driver sata_uli(in sata_uli) uses data 2/3 times for 
indexes
[   50.826979] PCI Driver sata_mv(in sata_mv) uses data 14/16 times for 
indexes
[   50.828821] PCI Driver pata_amd(in pata_amd) uses data 19/20 times 
for indexes
[   50.829188] PCI Driver pata_artop(in pata_artop) uses data 4/5 times 
for indexes
[   50.830278] PCI Driver pata_cmd64x(in pata_cmd64x) uses data 3/4 
times for flags
[   50.836264] PCI Driver pata_opti(in pata_opti) uses data 1/2 times 
for indexes
[   50.838717] PCI Driver pata_pdc2027x(in pata_pdc2027x) uses data 5/7 
times for indexes
[   50.839105] PCI Driver pata_pdc202xx_old(in pata_pdc202xx_old) uses 
data 4/5 times for indexes
[   50.840546] PCI Driver pata_serverworks(in pata_serverworks) uses 
data 4/5 times for indexes
[   50.843885] PCI Driver ata_generic(in ata_generic) uses data 1/13 
times for indexes
[   52.594478] PCI Driver MTD PCI(in pci) uses data 2/2 times for 
pointers
[   52.784303] PCI Driver yenta_cardbus(in yenta_socket) uses data 
47/49 times for pointers
[   54.779825] PCI Driver ehci_hcd(in ehci_hcd) uses data 1/1 times for 
pointers
[   55.043495] PCI Driver ohci_hcd(in ohci_hcd) uses data 1/1 times for 
pointers
[   55.616852] PCI Driver uhci_hcd(in uhci_hcd) uses data 1/1 times for 
pointers
[   57.372871] PCI Driver i2c_amd756 sets use_driver_data
[   57.372874] PCI Driver amd756_smbus(in i2c_amd756) uses data 4/5 
times for indexes
[   57.375964] PCI Driver i2c_viapro sets use_driver_data
[   57.375968] PCI Driver vt596_smbus(in i2c_viapro) uses data 12/12 
times for flags
[   58.609660] PCI Driver c4(in c4) uses data 2/2 times for flags
[   58.618070] PCI Driver divas(in divas) uses data 11/11 times for 
flags
[   58.660828] PCI Driver hfc4s8s_l1(in hfc4s8s_l1) uses data 4/4 times 
for pointers
[   58.667738] PCI Driver fcpci(in hisax_fcpcipnp) uses data 2/2 times 
for pointers
[   58.725420] PCI Driver sdhci-pci(in sdhci_pci) uses data 7/8 times 
for pointers
[   58.802705] PCI Driver ib_mthca(in ib_mthca) uses data 8/10 times 
for indexes
[   58.908537] PCI Driver trident(in trident) uses data 4/5 times for 
indexes
[   59.167098] PCI Driver ALS300(in snd_als300) uses data 1/2 times for 
indexes
[   59.193937] PCI Driver Bt87x(in snd_bt87x) uses data 10/10 times for 
indexes
[   59.229590] PCI Driver ES1968 (ESS Maestro)(in snd_es1968) uses data 
2/3 times for indexes
[   59.242452] PCI Driver Intel ICH(in snd_intel8x0) uses data 16/23 
times for indexes
[   59.249023] PCI Driver Intel ICH Modem(in snd_intel8x0m) uses data 
5/15 times for indexes
[   59.275975] PCI Driver VIA 82xx Audio(in snd_via82xx) uses data 2/2 
times for indexes
[   59.282351] PCI Driver VIA 82xx Modem(in snd_via82xx_modem) uses 
data 1/1 times for indexes
[   59.293970] PCI Driver au8810(in snd_au8810) uses data 1/1 times for 
indexes
[   59.399694] PCI Driver EMU10K1_Audigy(in snd_emu10k1) uses data 2/3 
times for indexes
[   59.411858] PCI Driver HDA Intel(in snd_hda_intel) uses data 42/51 
times for indexes
[   59.448649] PCI Driver CMI8788(in snd_oxygen) uses data 1/10 times 
for indexes
[   59.454958] PCI Driver AV200(in snd_virtuoso) uses data 2/3 times 
for indexes
[   59.460819] PCI Driver Digigram pcxhr(in snd_pcxhr) uses data 5/6 
times for indexes
[   59.507144] PCI Driver Digigram VX222(in snd_vx222) uses data 1/2 
times for indexes


diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index a13f534..0aeac3a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -696,6 +696,32 @@ int __pci_register_driver(struct pci_driver *drv, 
struct module *owner,
	spin_lock_init(&drv->dynids.lock);
	INIT_LIST_HEAD(&drv->dynids.list);
+
+	{
+		const struct pci_device_id *ids = drv->id_table;
+		unsigned long max_dat = 0;
+		int count = 0, addr = 0, uses = 0;
+
+		while (ids->vendor || ids->subvendor || ids->class_mask) {
+			count++;
+			if (ids->driver_data)
+				uses++;
+
+			if (ids->driver_data >= PAGE_OFFSET)
+				addr++;
+			else
+				max_dat = max(max_dat, ids->driver_data);
+			ids++;
+		}
+		if (drv->dynids.use_driver_data)
+			pr_info("PCI Driver %s sets use_driver_data\n", mod_name);
+		if (uses)
+			pr_info("PCI Driver %s(in %s) uses data %d/%d times for %s\n",
+				drv->name, mod_name, uses, count,
+				addr ? "pointers" :
+				(max_dat > count) ? "flags" : "indexes");
+	}
+
	/* register with core */
	error = driver_register(&drv->driver);
	if (error)

