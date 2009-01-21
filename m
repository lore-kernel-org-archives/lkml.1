Return-Path: <linux-kernel-owner+w=401wt.eu-S1763250AbZAUAoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763250AbZAUAoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbZAUAoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:44:12 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:36841 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbZAUAoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:44:08 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Philipp Kohlbecher <xt28@gmx.de>
Subject: Re: [PATCH] Make PNP IDs all uppercase
Date: Tue, 20 Jan 2009 17:42:08 -0700
User-Agent: KMail/1.9.10
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
       Vojtech Pavlik <vojtech@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       Pau Oliva Fora <pof@eslack.org>, Hans Verkuil <hverkuil@xs4all.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Jaroslav Kysela <perex@perex.cz>, Adam Belay <abelay@mit.edu>,
       Len Brown <lenb@kernel.org>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
References: <49733678.40006@gmx.de>
In-Reply-To: <49733678.40006@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901201742.10155.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2009 07:02:32 am Philipp Kohlbecher wrote:
> If I understand correctly, ACPI _HIDs (including PNP IDs) should be all 
> uppercase, including the hex digits, cf. ACPI Specification 3.0b [1], 
> pp. 162-3

Section 6.1.4, "_HID (Hardware ID)" says:

    A valid PNP ID must be of the form “AAA####” where A is an uppercase
    letter and # is a hex digit.  A valid ACPI ID must be of the form
    “ACPI####” where # is a hex digit.

I don't see the part about requiring the hex digits to be uppercase.
Did I miss it, or is it somewhere else?

> and acpi_glb_hex_to_ascii[] in drivers/acpi/utilities/utglobal.c. 
> 
> Since compare_pnp_id() in drivers/pnp/driver.c is case-insensitive, the 
> case should only matter for the MODULE_DEVICE_TABLE and thus for module 
> aliases, as modprobe uses fnmatch() to match aliases, which is 
> case-sensitive. Therefore, using uppercase letters in PNP IDs can lead 
> to non-functional module aliases.

Your patch converts PNP IDs to uppercase, so you must mean that using
*lowercase* letters can lead to non-functional module aliases.

There are definitely some inconsistencies that it would be nice to
fix, if we can do it safely.  For example, for ISAPNP and PNPBIOS
devices, I think we always generate lowercase hex digits in the PNP
IDs.  For PNPACPI, we generate uppercase digits for numeric _HIDs,
but we use string _HIDs unchanged.

Did you trip over an actual problem that is fixed by this patch?  If
so, can you give any more details?

Bjorn


> This patch converts all PNP IDs to uppercase.
> 
> [1] http://www.acpi.info/spec.htm
> 
> Signed-off-by: Philipp Kohlbecher <xt28@gmx.de>
> 
> ---
> 
> I have successfully tested this patch for drivers/rtc/rtc-cmos.c.
> 
> If you would rather have this as a series of patches, one per file, let 
> me know.
> 
> I hope I did not forget any recipients and that I didn't spam anyone 
> unnecessarily. If I did, I apologize.
> 
>   arch/x86/kernel/rtc.c                 |    2 +-
>   drivers/input/gameport/ns558.c        |    6 ++--
>   drivers/input/serio/i8042-x86ia64io.h |   16 ++++++------
>   drivers/input/touchscreen/htcpen.c    |    2 +-
>   drivers/media/radio/radio-cadet.c     |    2 +-
>   drivers/net/3c509.c                   |    4 +-
>   drivers/net/irda/smsc-ircc2.c         |    2 +-
>   drivers/platform/x86/fujitsu-laptop.c |    2 +-
>   drivers/platform/x86/wmi.c            |    2 +-
>   drivers/pnp/quirks.c                  |    4 +-
>   drivers/pnp/system.c                  |    4 +-
>   drivers/rtc/rtc-cmos.c                |    6 ++--
>   sound/drivers/mpu401/mpu401.c         |    2 +-
>   sound/isa/cs423x/cs4236.c             |   42 
> ++++++++++++++++----------------
>   sound/isa/gus/interwave.c             |    8 +++---
>   sound/isa/sb/sb16.c                   |   36 ++++++++++++++--------------
>   sound/isa/wavefront/wavefront.c       |    4 +-
>   sound/oss/sb_card.h                   |   10 ++++----
>   18 files changed, 77 insertions(+), 77 deletions(-)
> 
> diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
> index dd6f2b7..e9a7cac 100644
> --- a/arch/x86/kernel/rtc.c
> +++ b/arch/x86/kernel/rtc.c
> @@ -224,7 +224,7 @@ static __init int add_rtc_cmos(void)
>   {
>   #ifdef CONFIG_PNP
>   	static const char *ids[] __initconst =
> -	    { "PNP0b00", "PNP0b01", "PNP0b02", };
> +	    { "PNP0B00", "PNP0B01", "PNP0B02", };
>   	struct pnp_dev *dev;
>   	struct pnp_id *id;
>   	int i;
> diff --git a/drivers/input/gameport/ns558.c b/drivers/input/gameport/ns558.c
> index db556b7..5bc2c57 100644
> --- a/drivers/input/gameport/ns558.c
> +++ b/drivers/input/gameport/ns558.c
> @@ -171,11 +171,11 @@ static struct pnp_device_id pnp_devids[] = {
>   	{ .id = "@P@0020", .driver_data = 0 }, /* ALS 200 */
>   	{ .id = "@P@1001", .driver_data = 0 }, /* ALS 100+ */
>   	{ .id = "@P@2001", .driver_data = 0 }, /* ALS 120 */
> -	{ .id = "ASB16fd", .driver_data = 0 }, /* AdLib NSC16 */
> +	{ .id = "ASB16FD", .driver_data = 0 }, /* AdLib NSC16 */
>   	{ .id = "AZT3001", .driver_data = 0 }, /* AZT1008 */
>   	{ .id = "CDC0001", .driver_data = 0 }, /* Opl3-SAx */
>   	{ .id = "CSC0001", .driver_data = 0 }, /* CS4232 */
> -	{ .id = "CSC000f", .driver_data = 0 }, /* CS4236 */
> +	{ .id = "CSC000F", .driver_data = 0 }, /* CS4236 */
>   	{ .id = "CSC0101", .driver_data = 0 }, /* CS4327 */
>   	{ .id = "CTL7001", .driver_data = 0 }, /* SB16 */
>   	{ .id = "CTL7002", .driver_data = 0 }, /* AWE64 */
> @@ -188,7 +188,7 @@ static struct pnp_device_id pnp_devids[] = {
>   	{ .id = "OPT0001", .driver_data = 0 }, /* OPTi Audio16 */
>   	{ .id = "YMH0006", .driver_data = 0 }, /* Opl3-SA */
>   	{ .id = "YMH0022", .driver_data = 0 }, /* Opl3-SAx */
> -	{ .id = "PNPb02f", .driver_data = 0 }, /* Generic */
> +	{ .id = "PNPB02F", .driver_data = 0 }, /* Generic */
>   	{ .id = "", },
>   };
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h 
> b/drivers/input/serio/i8042-x86ia64io.h
> index 6fa2def..9f531ae 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -510,7 +510,7 @@ static int i8042_pnp_aux_probe(struct pnp_dev *dev, 
> const struct pnp_device_id *
> 
>   static struct pnp_device_id pnp_kbd_devids[] = {
>   	{ .id = "PNP0303", .driver_data = 0 },
> -	{ .id = "PNP030b", .driver_data = 0 },
> +	{ .id = "PNP030B", .driver_data = 0 },
>   	{ .id = "", },
>   };
> 
> @@ -523,13 +523,13 @@ static struct pnp_driver i8042_pnp_kbd_driver = {
>   static struct pnp_device_id pnp_aux_devids[] = {
>   	{ .id = "FJC6000", .driver_data = 0 },
>   	{ .id = "FJC6001", .driver_data = 0 },
> -	{ .id = "PNP0f03", .driver_data = 0 },
> -	{ .id = "PNP0f0b", .driver_data = 0 },
> -	{ .id = "PNP0f0e", .driver_data = 0 },
> -	{ .id = "PNP0f12", .driver_data = 0 },
> -	{ .id = "PNP0f13", .driver_data = 0 },
> -	{ .id = "PNP0f19", .driver_data = 0 },
> -	{ .id = "PNP0f1c", .driver_data = 0 },
> +	{ .id = "PNP0F03", .driver_data = 0 },
> +	{ .id = "PNP0F0B", .driver_data = 0 },
> +	{ .id = "PNP0F0E", .driver_data = 0 },
> +	{ .id = "PNP0F12", .driver_data = 0 },
> +	{ .id = "PNP0F13", .driver_data = 0 },
> +	{ .id = "PNP0F19", .driver_data = 0 },
> +	{ .id = "PNP0F1C", .driver_data = 0 },
>   	{ .id = "SYN0801", .driver_data = 0 },
>   	{ .id = "", },
>   };
> diff --git a/drivers/input/touchscreen/htcpen.c 
> b/drivers/input/touchscreen/htcpen.c
> index 62811de..eddfdc1 100644
> --- a/drivers/input/touchscreen/htcpen.c
> +++ b/drivers/input/touchscreen/htcpen.c
> @@ -48,7 +48,7 @@ module_param(invert_y, bool, 0644);
>   MODULE_PARM_DESC(invert_y, "If set, Y axis is inverted");
> 
>   static struct pnp_device_id pnp_ids[] = {
> -	{ .id = "PNP0cc0" },
> +	{ .id = "PNP0CC0" },
>   	{ .id = "" }
>   };
>   MODULE_DEVICE_TABLE(pnp, pnp_ids);
> diff --git a/drivers/media/radio/radio-cadet.c 
> b/drivers/media/radio/radio-cadet.c
> index cb3075a..7d29958 100644
> --- a/drivers/media/radio/radio-cadet.c
> +++ b/drivers/media/radio/radio-cadet.c
> @@ -592,7 +592,7 @@ static struct video_device cadet_radio = {
> 
>   static struct pnp_device_id cadet_pnp_devices[] = {
>   	/* ADS Cadet AM/FM Radio Card */
> -	{.id = "MSM0c24", .driver_data = 0},
> +	{.id = "MSM0C24", .driver_data = 0},
>   	{.id = ""}
>   };
> 
> diff --git a/drivers/net/3c509.c b/drivers/net/3c509.c
> index 535c234..8c2e86d 100644
> --- a/drivers/net/3c509.c
> +++ b/drivers/net/3c509.c
> @@ -402,8 +402,8 @@ static struct pnp_device_id el3_pnp_ids[] = {
>   	{ .id = "TCM5094" }, /* 3Com Etherlink III (combo) */
>   	{ .id = "TCM5095" }, /* 3Com Etherlink III (TPO) */
>   	{ .id = "TCM5098" }, /* 3Com Etherlink III (TPC) */
> -	{ .id = "PNP80f7" }, /* 3Com Etherlink III compatible */
> -	{ .id = "PNP80f8" }, /* 3Com Etherlink III compatible */
> +	{ .id = "PNP80F7" }, /* 3Com Etherlink III compatible */
> +	{ .id = "PNP80F8" }, /* 3Com Etherlink III compatible */
>   	{ .id = "" }
>   };
>   MODULE_DEVICE_TABLE(pnp, el3_pnp_ids);
> diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
> index dd73cce..028e9c5 100644
> --- a/drivers/net/irda/smsc-ircc2.c
> +++ b/drivers/net/irda/smsc-ircc2.c
> @@ -365,7 +365,7 @@ static inline void register_bank(int iobase, int bank)
> 
>   /* PNP hotplug support */
>   static const struct pnp_device_id smsc_ircc_pnp_table[] = {
> -	{ .id = "SMCf010", .driver_data = 0 },
> +	{ .id = "SMCF010", .driver_data = 0 },
>   	/* and presumably others */
>   	{ }
>   };
> diff --git a/drivers/platform/x86/fujitsu-laptop.c 
> b/drivers/platform/x86/fujitsu-laptop.c
> index 65dc415..ee14b57 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -1284,7 +1284,7 @@ 
> MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1E6:*:cvrS6420:*");
>   MODULE_ALIAS("dmi:*:svnFUJITSU:*:pvr:rvnFUJITSU:rnFJNB19C:*:cvrS7020:*");
> 
>   static struct pnp_device_id pnp_ids[] = {
> -	{.id = "FUJ02bf"},
> +	{.id = "FUJ02BF"},
>   	{.id = "FUJ02B1"},
>   	{.id = "FUJ02E3"},
>   	{.id = ""}
> diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
> index 8a8b377..79b8af7 100644
> --- a/drivers/platform/x86/wmi.c
> +++ b/drivers/platform/x86/wmi.c
> @@ -84,7 +84,7 @@ static int acpi_wmi_add(struct acpi_device *device);
> 
>   static const struct acpi_device_id wmi_device_ids[] = {
>   	{"PNP0C14", 0},
> -	{"pnp0c14", 0},
> +	{"PNP0C14", 0},
>   	{"", 0},
>   };
>   MODULE_DEVICE_TABLE(acpi, wmi_device_ids);
> diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
> index 8473fe5..18c9335 100644
> --- a/drivers/pnp/quirks.c
> +++ b/drivers/pnp/quirks.c
> @@ -325,8 +325,8 @@ static struct pnp_fixup pnp_fixups[] = {
>   	{"ADS7181", quirk_add_irq_optional_dependent_sets},
>   	{"AZT0002", quirk_add_irq_optional_dependent_sets},
>   	/* PnP resources that might overlap PCI BARs */
> -	{"PNP0c01", quirk_system_pci_resources},
> -	{"PNP0c02", quirk_system_pci_resources},
> +	{"PNP0C01", quirk_system_pci_resources},
> +	{"PNP0C02", quirk_system_pci_resources},
>   	{""}
>   };
> 
> diff --git a/drivers/pnp/system.c b/drivers/pnp/system.c
> index 59b9092..36720df 100644
> --- a/drivers/pnp/system.c
> +++ b/drivers/pnp/system.c
> @@ -16,9 +16,9 @@
> 
>   static const struct pnp_device_id pnp_dev_table[] = {
>   	/* General ID for reserving resources */
> -	{"PNP0c02", 0},
> +	{"PNP0C02", 0},
>   	/* memory controller */
> -	{"PNP0c01", 0},
> +	{"PNP0C01", 0},
>   	{"", 0}
>   };
> 
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index b6d35f5..f20e5ec 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -1110,9 +1110,9 @@ static void cmos_pnp_shutdown(struct device *pdev)
>   }
> 
>   static const struct pnp_device_id rtc_ids[] = {
> -	{ .id = "PNP0b00", },
> -	{ .id = "PNP0b01", },
> -	{ .id = "PNP0b02", },
> +	{ .id = "PNP0B00", },
> +	{ .id = "PNP0B01", },
> +	{ .id = "PNP0B02", },
>   	{ },
>   };
>   MODULE_DEVICE_TABLE(pnp, rtc_ids);
> diff --git a/sound/drivers/mpu401/mpu401.c b/sound/drivers/mpu401/mpu401.c
> index 5b996f3..9bdd96e 100644
> --- a/sound/drivers/mpu401/mpu401.c
> +++ b/sound/drivers/mpu401/mpu401.c
> @@ -150,7 +150,7 @@ static struct platform_driver snd_mpu401_driver = {
>   #define IO_EXTENT 2
> 
>   static struct pnp_device_id snd_mpu401_pnpids[] = {
> -	{ .id = "PNPb006" },
> +	{ .id = "PNPB006" },
>   	{ .id = "" }
>   };
> 
> diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
> index 019c940..d7c0f3b 100644
> --- a/sound/isa/cs423x/cs4236.c
> +++ b/sound/isa/cs423x/cs4236.c
> @@ -164,21 +164,21 @@ MODULE_DEVICE_TABLE(pnp, snd_cs4232_pnpbiosids);
>   #define CS423X_ISAPNP_DRIVER	"cs4232_isapnp"
>   static struct pnp_card_device_id snd_cs423x_pnpids[] = {
>   	/* Philips PCA70PS */
> -	{ .id = "CSC0d32", .devs = { { "CSC0000" }, { "CSC0010" }, { "PNPb006" 
> } } },
> +	{ .id = "CSC0D32", .devs = { { "CSC0000" }, { "CSC0010" }, { "PNPB006" 
> } } },
>   	/* TerraTec Maestro 32/96 (CS4232) */
> -	{ .id = "CSC1a32", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
> +	{ .id = "CSC1A32", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
>   	/* HP Omnibook 5500 onboard */
>   	{ .id = "CSC4232", .devs = { { "CSC0000" }, { "CSC0002" }, { 
> "CSC0003" } } },
>   	/* Unnamed CS4236 card (Made in Taiwan) */
>   	{ .id = "CSC4236", .devs = { { "CSC0000" }, { "CSC0010" }, { 
> "CSC0003" } } },
>   	/* Turtle Beach TBS-2000 (CS4232) */
> -	{ .id = "CSC7532", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSCb006" 
> } } },
> +	{ .id = "CSC7532", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSCB006" 
> } } },
>   	/* Turtle Beach Tropez Plus (CS4232) */
> -	{ .id = "CSC7632", .devs = { { "CSC0000" }, { "CSC0010" }, { "PNPb006" 
> } } },
> +	{ .id = "CSC7632", .devs = { { "CSC0000" }, { "CSC0010" }, { "PNPB006" 
> } } },
>   	/* SIC CrystalWave 32 (CS4232) */
> -	{ .id = "CSCf032", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
> +	{ .id = "CSCF032", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
>   	/* Netfinity 3000 on-board soundcard */
> -	{ .id = "CSCe825", .devs = { { "CSC0100" }, { "CSC0110" }, { "CSC010f" 
> } } },
> +	{ .id = "CSCE825", .devs = { { "CSC0100" }, { "CSC0110" }, { "CSC010F" 
> } } },
>   	/* --- */
>   	{ .id = "" }	/* end */
>   };
> @@ -196,9 +196,9 @@ static struct pnp_card_device_id snd_cs423x_pnpids[] = {
>   	/* Digital PC 5000 Onboard - CS4236B */
>   	{ .id = "CSC0735", .devs = { { "CSC0000" }, { "CSC0010" } } },
>   	/* some uknown CS4236B */
> -	{ .id = "CSC0b35", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
> +	{ .id = "CSC0B35", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
>   	/* Intel PR440FX Onboard sound */
> -	{ .id = "CSC0b36", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
> +	{ .id = "CSC0B36", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
>   	/* CS4235 on mainboard without MPU */
>   	{ .id = "CSC1425", .devs = { { "CSC0100" }, { "CSC0110" } } },
>   	/* Gateway E1000 Onboard CS4236B */
> @@ -206,7 +206,7 @@ static struct pnp_card_device_id snd_cs423x_pnpids[] = {
>   	/* HP 6330 Onboard sound */
>   	{ .id = "CSC1525", .devs = { { "CSC0100" }, { "CSC0110" }, { 
> "CSC0103" } } },
>   	/* Crystal Computer TidalWave128 */
> -	{ .id = "CSC1e37", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
> +	{ .id = "CSC1E37", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
>   	/* ACER AW37 - CS4235 */
>   	{ .id = "CSC4236", .devs = { { "CSC0000" }, { "CSC0010" }, { 
> "CSC0003" } } },
>   	/* build-in soundcard in EliteGroup P5TX-LA motherboard - CS4237B */
> @@ -234,35 +234,35 @@ static struct pnp_card_device_id 
> snd_cs423x_pnpids[] = {
>   	/* IBM Aptiva 2137 E24 Onboard - CS4237B */
>   	{ .id = "CSC8037", .devs = { { "CSC0000" }, { "CSC0010" }, { 
> "CSC0003" } } },
>   	/* IBM IntelliStation M Pro motherboard */
> -	{ .id = "CSCc835", .devs = { { "CSC0000" }, { "CSC0010" } } },
> +	{ .id = "CSCC835", .devs = { { "CSC0000" }, { "CSC0010" } } },
>   	/* Guillemot MaxiSound 16 PnP - CS4236B */
>   	{ .id = "CSC9836", .devs = { { "CSC0000" }, { "CSC0010" }, { 
> "CSC0003" } } },
>   	/* Gallant SC-70P */
>   	{ .id = "CSC9837", .devs = { { "CSC0000" }, { "CSC0010" }, { 
> "CSC0003" } } },
>   	/* Techmakers MF-4236PW */
> -	{ .id = "CSCa736", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
> +	{ .id = "CSCA736", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
>   	/* TerraTec AudioSystem EWS64XL - CS4236B */
> -	{ .id = "CSCa836", .devs = { { "CSCa800" }, { "CSCa810" }, { "CSCa803" 
> } } },
> +	{ .id = "CSCA836", .devs = { { "CSCA800" }, { "CSCA810" }, { "CSCA803" 
> } } },
>   	/* TerraTec AudioSystem EWS64XL - CS4236B */
> -	{ .id = "CSCa836", .devs = { { "CSCa800" }, { "CSCa810" } } },
> +	{ .id = "CSCA836", .devs = { { "CSCA800" }, { "CSCA810" } } },
>   	/* ACER AW37/Pro - CS4235 */
> -	{ .id = "CSCd925", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
> +	{ .id = "CSCD925", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
>   	/* ACER AW35/Pro - CS4237B */
> -	{ .id = "CSCd937", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
> +	{ .id = "CSCD937", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
>   	/* CS4235 without MPU401 */
> -	{ .id = "CSCe825", .devs = { { "CSC0100" }, { "CSC0110" } } },
> +	{ .id = "CSCE825", .devs = { { "CSC0100" }, { "CSC0110" } } },
>   	/* Unknown SiS530 - CS4235 */
>   	{ .id = "CSC4825", .devs = { { "CSC0100" }, { "CSC0110" } } },
>   	/* IBM IntelliStation M Pro 6898 11U - CS4236B */
> -	{ .id = "CSCe835", .devs = { { "CSC0000" }, { "CSC0010" } } },
> +	{ .id = "CSCE835", .devs = { { "CSC0000" }, { "CSC0010" } } },
>   	/* IBM PC 300PL Onboard - CS4236B */
> -	{ .id = "CSCe836", .devs = { { "CSC0000" }, { "CSC0010" } } },
> +	{ .id = "CSCE836", .devs = { { "CSC0000" }, { "CSC0010" } } },
>   	/* Some noname CS4236 based card */
> -	{ .id = "CSCe936", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
> +	{ .id = "CSCE936", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
>   	/* CS4236B */
> -	{ .id = "CSCf235", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
> +	{ .id = "CSCF235", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
>   	/* CS4236B */
> -	{ .id = "CSCf238", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
> +	{ .id = "CSCF238", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" 
> } } },
>   	/* --- */
>   	{ .id = "" }	/* end */
>   };
> diff --git a/sound/isa/gus/interwave.c b/sound/isa/gus/interwave.c
> index 5faecfb..6bbf6f2 100644
> --- a/sound/isa/gus/interwave.c
> +++ b/sound/isa/gus/interwave.c
> @@ -142,19 +142,19 @@ static struct pnp_card_device_id 
> snd_interwave_pnpids[] = {
>   	/* Gravis UltraSound Plug & Play */
>   	{ .id = "GRV0001", .devs = { { .id = "GRV0000" } } },
>   	/* STB SoundRage32 */
> -	{ .id = "STB011a", .devs = { { .id = "STB0010" } } },
> +	{ .id = "STB011A", .devs = { { .id = "STB0010" } } },
>   	/* MED3210 */
>   	{ .id = "DXP3201", .devs = { { .id = "DXP0010" } } },
>   	/* Dynasonic Pro */
>   	/* This device also have CDC1117:DynaSonix Pro Audio Effects Processor */
>   	{ .id = "CDC1111", .devs = { { .id = "CDC1112" } } },
>   	/* Panasonic PCA761AW Audio Card */
> -	{ .id = "ADV55ff", .devs = { { .id = "ADV0010" } } },
> +	{ .id = "ADV55FF", .devs = { { .id = "ADV0010" } } },
>   	/* InterWave STB without TEA6330T */
> -	{ .id = "ADV550a", .devs = { { .id = "ADV0010" } } },
> +	{ .id = "ADV550A", .devs = { { .id = "ADV0010" } } },
>   #else
>   	/* InterWave STB with TEA6330T */
> -	{ .id = "ADV550a", .devs = { { .id = "ADV0010" }, { .id = "ADV0015" } } },
> +	{ .id = "ADV550A", .devs = { { .id = "ADV0010" }, { .id = "ADV0015" } } },
>   #endif
>   	{ .id = "" }
>   };
> diff --git a/sound/isa/sb/sb16.c b/sound/isa/sb/sb16.c
> index 2c201f7..65430f6 100644
> --- a/sound/isa/sb/sb16.c
> +++ b/sound/isa/sb/sb16.c
> @@ -161,12 +161,12 @@ static struct pnp_card_device_id snd_sb16_pnpids[] = {
>   	/* Sound Blaster 16 PnP */
>   	{ .id = "CTL0029", .devs = { { "CTL0031" } } },
>   	/* Sound Blaster 16 PnP */
> -	{ .id = "CTL002a", .devs = { { "CTL0031" } } },
> +	{ .id = "CTL002A", .devs = { { "CTL0031" } } },
>   	/* Sound Blaster 16 PnP */
>   	/* Note: This card has also a CTL0051:StereoEnhance device!!! */
> -	{ .id = "CTL002b", .devs = { { "CTL0031" } } },
> +	{ .id = "CTL002B", .devs = { { "CTL0031" } } },
>   	/* Sound Blaster 16 PnP */
> -	{ .id = "CTL002c", .devs = { { "CTL0031" } } },
> +	{ .id = "CTL002C", .devs = { { "CTL0031" } } },
>   	/* Sound Blaster Vibra16S */
>   	{ .id = "CTL0051", .devs = { { "CTL0001" } } },
>   	/* Sound Blaster Vibra16C */
> @@ -177,9 +177,9 @@ static struct pnp_card_device_id snd_sb16_pnpids[] = {
>   	/* but ct4131 on a sticker on the board.. */
>   	{ .id = "CTL0086", .devs = { { "CTL0041" } } },
>   	/* Sound Blaster Vibra16X */
> -	{ .id = "CTL00f0", .devs = { { "CTL0043" } } },
> +	{ .id = "CTL00F0", .devs = { { "CTL0043" } } },
>   	/* Sound Blaster 16 (Virtual PC 2004) */
> -	{ .id = "tBA03b0", .devs = { {.id="PNPb003" } } },
> +	{ .id = "TBA03B0", .devs = { {.id="PNPB003" } } },
>   #else  /* SNDRV_SBAWE defined */
>   	/* Sound Blaster AWE 32 PnP */
>   	{ .id = "CTL0035", .devs = { { "CTL0031" }, { "CTL0021" } } },
> @@ -204,31 +204,31 @@ static struct pnp_card_device_id snd_sb16_pnpids[] = {
>   	/* Sound Blaster AWE 32 PnP */
>   	{ .id = "CTL0054", .devs = { { "CTL0031" }, { "CTL0021" } } },
>   	/* Sound Blaster AWE 32 PnP */
> -	{ .id = "CTL009a", .devs = { { "CTL0041" }, { "CTL0021" } } },
> +	{ .id = "CTL009A", .devs = { { "CTL0041" }, { "CTL0021" } } },
>   	/* Sound Blaster AWE 32 PnP */
> -	{ .id = "CTL009c", .devs = { { "CTL0041" }, { "CTL0021" } } },
> +	{ .id = "CTL009C", .devs = { { "CTL0041" }, { "CTL0021" } } },
>   	/* Sound Blaster 32 PnP */
> -	{ .id = "CTL009f", .devs = { { "CTL0041" }, { "CTL0021" } } },
> +	{ .id = "CTL009F", .devs = { { "CTL0041" }, { "CTL0021" } } },
>   	/* Sound Blaster AWE 64 PnP */
> -	{ .id = "CTL009d", .devs = { { "CTL0042" }, { "CTL0022" } } },
> +	{ .id = "CTL009D", .devs = { { "CTL0042" }, { "CTL0022" } } },
>   	/* Sound Blaster AWE 64 PnP Gold */
> -	{ .id = "CTL009e", .devs = { { "CTL0044" }, { "CTL0023" } } },
> +	{ .id = "CTL009E", .devs = { { "CTL0044" }, { "CTL0023" } } },
>   	/* Sound Blaster AWE 64 PnP Gold */
> -	{ .id = "CTL00b2", .devs = { { "CTL0044" }, { "CTL0023" } } },
> +	{ .id = "CTL00B2", .devs = { { "CTL0044" }, { "CTL0023" } } },
>   	/* Sound Blaster AWE 64 PnP */
> -	{ .id = "CTL00c1", .devs = { { "CTL0042" }, { "CTL0022" } } },
> +	{ .id = "CTL00C1", .devs = { { "CTL0042" }, { "CTL0022" } } },
>   	/* Sound Blaster AWE 64 PnP */
> -	{ .id = "CTL00c3", .devs = { { "CTL0045" }, { "CTL0022" } } },
> +	{ .id = "CTL00C3", .devs = { { "CTL0045" }, { "CTL0022" } } },
>   	/* Sound Blaster AWE 64 PnP */
> -	{ .id = "CTL00c5", .devs = { { "CTL0045" }, { "CTL0022" } } },
> +	{ .id = "CTL00C5", .devs = { { "CTL0045" }, { "CTL0022" } } },
>   	/* Sound Blaster AWE 64 PnP */
> -	{ .id = "CTL00c7", .devs = { { "CTL0045" }, { "CTL0022" } } },
> +	{ .id = "CTL00C7", .devs = { { "CTL0045" }, { "CTL0022" } } },
>   	/* Sound Blaster AWE 64 PnP */
> -	{ .id = "CTL00e4", .devs = { { "CTL0045" }, { "CTL0022" } } },
> +	{ .id = "CTL00E4", .devs = { { "CTL0045" }, { "CTL0022" } } },
>   	/* Sound Blaster AWE 64 PnP */
> -	{ .id = "CTL00e9", .devs = { { "CTL0045" }, { "CTL0022" } } },
> +	{ .id = "CTL00E9", .devs = { { "CTL0045" }, { "CTL0022" } } },
>   	/* Sound Blaster 16 PnP (AWE) */
> -	{ .id = "CTL00ed", .devs = { { "CTL0041" }, { "CTL0070" } } },
> +	{ .id = "CTL00ED", .devs = { { "CTL0041" }, { "CTL0070" } } },
>   	/* Generic entries */
>   	{ .id = "CTLXXXX" , .devs = { { "CTL0031" }, { "CTL0021" } } },
>   	{ .id = "CTLXXXX" , .devs = { { "CTL0041" }, { "CTL0021" } } },
> diff --git a/sound/isa/wavefront/wavefront.c 
> b/sound/isa/wavefront/wavefront.c
> index 4c095bc..b303cc5 100644
> --- a/sound/isa/wavefront/wavefront.c
> +++ b/sound/isa/wavefront/wavefront.c
> @@ -91,9 +91,9 @@ static int pnp_registered;
> 
>   static struct pnp_card_device_id snd_wavefront_pnpids[] = {
>   	/* Tropez */
> -	{ .id = "CSC7532", .devs = { { "CSC0000" }, { "CSC0010" }, { "PnPb006" 
> }, { "CSC0004" } } },
> +	{ .id = "CSC7532", .devs = { { "CSC0000" }, { "CSC0010" }, { "PNPB006" 
> }, { "CSC0004" } } },
>   	/* Tropez+ */
> -	{ .id = "CSC7632", .devs = { { "CSC0000" }, { "CSC0010" }, { "PnPb006" 
> }, { "CSC0004" } } },
> +	{ .id = "CSC7632", .devs = { { "CSC0000" }, { "CSC0010" }, { "PNPB006" 
> }, { "CSC0004" } } },
>   	{ .id = "" }
>   };
> 
> diff --git a/sound/oss/sb_card.h b/sound/oss/sb_card.h
> index 5535cff..3f6fb43 100644
> --- a/sound/oss/sb_card.h
> +++ b/sound/oss/sb_card.h
> @@ -37,13 +37,13 @@ static struct pnp_card_device_id sb_pnp_card_table[] = {
>   	/* Sound Blaster 16 */
>   	{.id = "CTL0029", .driver_data = 0, .devs = { {.id="CTL0031"}, } },
>   	/* Sound Blaster 16 */
> -	{.id = "CTL002a", .driver_data = 0, .devs = { {.id="CTL0031"}, } },
> +	{.id = "CTL002A", .driver_data = 0, .devs = { {.id="CTL0031"}, } },
>   	/* Sound Blaster 16 */
> -	{.id = "CTL002b", .driver_data = 0, .devs = { {.id="CTL0031"}, } },
> +	{.id = "CTL002B", .driver_data = 0, .devs = { {.id="CTL0031"}, } },
>   	/* Sound Blaster 16 */
> -	{.id = "CTL002c", .driver_data = 0, .devs = { {.id="CTL0031"}, } },
> +	{.id = "CTL002C", .driver_data = 0, .devs = { {.id="CTL0031"}, } },
>   	/* Sound Blaster 16 */
> -	{.id = "CTL00ed", .driver_data = 0, .devs = { {.id="CTL0041"}, } },
> +	{.id = "CTL00ED", .driver_data = 0, .devs = { {.id="CTL0041"}, } },
>   	/* Sound Blaster 16 */
>   	{.id = "CTL0086", .driver_data = 0, .devs = { {.id="CTL0041"}, } },
>   	/* Sound Blaster Vibra16S */
> @@ -141,7 +141,7 @@ static struct pnp_card_device_id sb_pnp_card_table[] = {
>   						     {.id="@X@2001"},
>   						     {.id="@H@0001"}, } },
>   	/* Sound Blaster 16 (Virtual PC 2004) */
> -	{.id = "tBA03b0", .driver_data = 0, .devs = { {.id="PNPb003"}, } },
> +	{.id = "TBA03B0", .driver_data = 0, .devs = { {.id="PNPB003"}, } },
>   	/* -end- */
>   	{.id = "", }
>   };
> 
> 


