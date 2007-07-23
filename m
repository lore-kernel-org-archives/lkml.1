Return-Path: <linux-kernel-owner+w=401wt.eu-S1762607AbXGWQ0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762607AbXGWQ0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbXGWQ0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:26:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:48681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbXGWQ0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:26:44 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: 2.6.23rc1 git: EIP is at acpi_processor_throttling_seq_show+0x8b/0xdd [processor]
Date: Mon, 23 Jul 2007 12:26:35 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <200707231740.38263.arekm@maven.pl>
In-Reply-To: <200707231740.38263.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231226.35183.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 11:40, Arkadiusz Miskiewicz wrote:
> 
> After booting fresh 2.6.23rc1 taken from git I noticed oops in dmesg:

> [   46.274038] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
> [   46.274042]  printing eip:
> [   46.274044] f8b5b2dc
> [   46.274045] *pde = 00000000
> [   46.274048] Oops: 0000 [#1]
> [   46.274050] Modules linked in: radeon drm binfmt_misc ipv6 sch_sfq mmc_block rfcomm l2cap bluetooth ircomm_tty ircomm cpufreq_powersave cpufreq_ondemand acpi_cpufreq freq_table hdaps video output thermal processor fan container button battery ac tun capability commoncap usbhid hid ff_memless firewire_ohci firewire_core ahci ata_generic crc_itu_t pcmcia joydev nsc_ircc sdhci thinkpad_acpi hwmon backlight ohci1394 mmc_core ieee1394 snd_hda_intel generic yenta_socket rsrc_nonstatic pcmcia_core ipw2200 ieee80211 ieee80211_crypt firmware_class ehci_hcd ide_core snd_pcm snd_timer psmouse evdev tg3 intel_agp agpgart uhci_hcd snd soundcore serio_raw usbcore irda iTCO_wdt iTCO_vendor_support nvram i2c_i801 snd_page_alloc rtc_cmos rtc_core rtc_lib crc_ccitt i2c_core sr_mod cdrom xfs scsi_wait_scan sd_mod ata_piix libata scsi_mod
> [   46.274103] CPU:    0
> [   46.274104] EIP:    0060:[<f8b5b2dc>]    Not tainted VLI
> [   46.274105] EFLAGS: 00010292   (2.6.23-rc1 #88)
> [   46.274114] EIP is at acpi_processor_throttling_seq_show+0x8b/0xdd [processor]
> [   46.274116] eax: 00000000   ebx: f4828940   ecx: 00000000   edx: 00000008
> [   46.274119] esi: f7cea400   edi: 00000000   ebp: f20aff14   esp: f20afee8
> [   46.274121] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> [   46.274124] Process powersaved (pid: 3696, ti=f20ae000 task=f7acc730 task.ti=f20ae000)
> [   46.274126] Stack: f4828940 f8b5d7ef 00000008 00000000 00000000 00000007 f7fff7c0 f20aff14 
> [   46.274131]        f20aff40 f4828940 00000001 f20aff54 c017032c 00000400 b7fbb000 f25672c0 
> [   46.274135]        f4828960 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
> [   46.274139] Call Trace:
> [   46.274141]  [<c0104b47>] show_trace_log_lvl+0x1a/0x2f
> [   46.274147]  [<c0104bf7>] show_stack_log_lvl+0x9b/0xa3
> [   46.274150]  [<c0104db3>] show_registers+0x1b4/0x286
> [   46.274154]  [<c0104f66>] die+0xe1/0x1bd
> [   46.274156]  [<c01148c5>] do_page_fault+0x495/0x564
> [   46.274159]  [<c028421a>] error_code+0x6a/0x70
> [   46.274164]  [<c017032c>] seq_read+0xeb/0x25f
> [   46.274169]  [<c01859c0>] proc_reg_read+0x38/0x4a
> [   46.274173]  [<c015bc79>] vfs_read+0xad/0x15f
> [   46.274178]  [<c015bfde>] sys_read+0x3d/0x61
> [   46.274181]  [<c0103c62>] sysenter_past_esp+0x5f/0x85
> [   46.274184]  =======================
> [   46.274185] Code: c7 44 24 04 ef d7 b5 f8 89 1c 24 89 44 24 0c e8 a6 4b 61 c7 ba 45 d8 b5 f8 89 d8 e8 88 49 61 c7 eb 49 8b 8e 04 03 00 00 6b c7 28 <8b> 14 08 8b 4c 08 04 b8 20 00 00 00 89 55 ec ba 2a 00 00 00 89 
> [   46.274205] EIP: [<f8b5b2dc>] acpi_processor_throttling_seq_show+0x8b/0xdd [processor] SS:ESP 0068:f20afee8
> [   47.633540] [drm] Setting GART location based on new memory map
> [   47.634482] [drm] Loading R300 Microcode
> [   47.634532] [drm] writeback test succeeded in 1 usecs
> [  119.542883] Clocksource tsc unstable (delta = -224143297 ns)

Please try the patch below -- seems that I somehow neglected to include it in my rc1 batch.

thanks,
-Len

Subject: fix oops due to typo in new throttling code
From: Luming Yu <luming.yu@gmail.com>


Signed-off-by: Luming Yu <luming.yu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>

---

 drivers/acpi/processor_throttling.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

Index: linus/drivers/acpi/processor_throttling.c
===================================================================
--- linus.orig/drivers/acpi/processor_throttling.c
+++ linus/drivers/acpi/processor_throttling.c
@@ -658,18 +658,20 @@ static int acpi_processor_throttling_seq
 		   pr->throttling.state_count - 1);
 
 	seq_puts(seq, "states:\n");
-	if (acpi_processor_get_throttling == acpi_processor_get_throttling_fadt)
+	if (pr->throttling.acpi_processor_get_throttling ==
+			acpi_processor_get_throttling_fadt) {
 		for (i = 0; i < pr->throttling.state_count; i++)
 			seq_printf(seq, "   %cT%d:                  %02d%%\n",
 				   (i == pr->throttling.state ? '*' : ' '), i,
 				   (pr->throttling.states[i].performance ? pr->
 				    throttling.states[i].performance / 10 : 0));
-	else
+	} else {
 		for (i = 0; i < pr->throttling.state_count; i++)
 			seq_printf(seq, "   %cT%d:                  %02d%%\n",
 				   (i == pr->throttling.state ? '*' : ' '), i,
 				   (int)pr->throttling.states_tss[i].
 				   freqpercentage);
+	}
 
       end:
 	return 0;
