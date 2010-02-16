Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab0BPFmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 00:42:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63556 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab0BPFmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 00:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=YE6Pyoexqxsd4usT3Fz24Gwfadr41jgLaVs1d+3qwY8xf3WWz5EMXbeoJZ9QS4Ey9J
         1mLlGkPA4uYCGnu+9zI/XNuxiM0BmWNVbxzC8AOEoHi2X7lNr//6bdNETPtOKtegvcDU
         uOIxspCrYy55VPiJvGKZAWcQt55efddXEXG98=
Date: Tue, 16 Feb 2010 08:42:00 +0300
From: Dan Carpenter <error27@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bug list: range checking issues
Message-ID: <20100216054200.GM14210@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a couple more things.

The strcpy is not ideal.  It looks at the size of the string buffers instead
of looking at where the first NULL is.  But probably quite a few of them are
bugs, or could be improved by using strncpy and explicitly setting a NULL 
pointer.

regards,
dan carpenter

drivers/acpi/acpi_pad.c +456 acpi_pad_add(5) error: strcpy() "processor_aggregator" too large for ((device)->pnp.device_class) (21 vs 20)
drivers/acpi/power_meter.c +902 acpi_power_meter_add(17) error: strcpy() "power_meter_resource" too large for ((device)->pnp.device_class) (21 vs 20)
drivers/acpi/sbshc.c +275 acpi_smbus_hc_add(16) error: strcpy() "smbus_host_controller" too large for ((device)->pnp.device_class) (22 vs 20)
drivers/isdn/divert/isdn_divert.c +482 isdn_divert_icall(95) error: strcpy() dv->rule.to_nr too large for ic->parm.setup.phone (35 vs 32)
drivers/isdn/divert/isdn_divert.c +79 deflect_timer_expire(22) error: strcpy() cs->deflect_dest too large for cs->ics.parm.setup.phone (35 vs 32)
drivers/isdn/hardware/eicon/debug.c +927 diva_mnt_add_xdi_adapter(66) error: strcpy() tmp too large for clients[id]->drvName (256 vs 128)
drivers/isdn/hardware/eicon/debug.c +928 diva_mnt_add_xdi_adapter(67) error: strcpy() tmp too large for clients[id]->Dbg.drvName (256 vs 16)
drivers/isdn/hisax/config.c +1231 HiSax_inithardware(21) error: strcpy() id too large for ids (64 vs 20)
drivers/isdn/hisax/config.c +1236 HiSax_inithardware(26) error: strcpy() id too large for ids (64 vs 20)
drivers/isdn/i4l/isdn_net.c +2929 isdn_net_getcfg(42) error: strcpy() lp->slave->name too large for cfg->slave (16 vs 10)
drivers/isdn/i4l/isdn_net.c +2935 isdn_net_getcfg(48) error: strcpy() lp->master->name too large for cfg->master (16 vs 10)
drivers/isdn/sc/interrupt.c +118 interrupt_handler(91) error: strcpy() (sc_adapter[card]->channel+(rcvmsg.phy_link_no-1))->dn too large for setup.eazmsn (50 vs 32)
drivers/media/video/cx231xx/cx231xx-audio.c +498 cx231xx_audio_init(37) error: strcpy() "Conexant cx231xx Audio" too large for card->driver (23 vs 16)
drivers/media/video/cx23885/cx23885-417.c +1358 vidioc_querycap(7) error: strcpy() dev->name too large for cap->driver (32 vs 16)
drivers/media/video/em28xx/em28xx-audio.c +494 em28xx_audio_init(38) error: strcpy() "Empia Em28xx Audio" too large for card->driver (19 vs 16)
drivers/net/ewrk3.c +1785 ewrk3_ioctl(111) error: copy_from_user() tmp->addr too small (3072 vs 6144)
drivers/net/wireless/airo.c +2226 airo_start_xmit11(35) error: buffer overflow 'fids' 6 <= 6
drivers/scsi/qla2xxx/qla_gs.c +1322 qla2x00_fdmi_rhba(74) error: strcpy() ha->model_number too large for eiter->a.model (17 vs 16)
drivers/scsi/qla2xxx/qla_gs.c +1347 qla2x00_fdmi_rhba(99) error: strcpy() ha->adapter_id too large for eiter->a.hw_version (17 vs 16)
drivers/staging/otus/ioctl.c +509 usbdrvwext_giwname(6) error: strcpy() "IEEE 802.11-MIMO" too large for wrq->name (17 vs 16)
drivers/staging/wlan-ng/prism2fw.c +588 mkpdrlist(9) error: buffer overflow 'pda16' 512 <= 512
drivers/staging/wlan-ng/prism2fw.c +628 mkpdrlist(49) error: buffer overflow 'pda16' 512 <= 512
drivers/video/sis/sis_main.c +1848 sisfb_get_fix(6) error: strcpy() ivideo->myid too large for fix->id (40 vs 16)
net/decnet/dn_dev.c +430 dn_dev_ioctl(10) error: copy_from_user() ifr too small (40 vs 42)
net/tipc/bearer.c +274 bearer_name_validate(37) error: strcpy() media_name too large for name_parts->media_name (32 vs 16)
sound/isa/ad1848/ad1848.c +115 snd_ad1848_probe(28) error: strcpy() pcm->name too large for card->shortname (80 vs 32)
sound/isa/cs423x/cs4231.c +114 snd_cs4231_probe(23) error: strcpy() pcm->name too large for card->shortname (80 vs 32)
sound/isa/cs423x/cs4236.c +423 snd_cs423x_probe(41) error: strcpy() pcm->name too large for card->driver (80 vs 16)
sound/isa/cs423x/cs4236.c +424 snd_cs423x_probe(42) error: strcpy() pcm->name too large for card->shortname (80 vs 32)
sound/isa/es1688/es1688.c +145 snd_es1688_probe(25) error: strcpy() pcm->name too large for card->shortname (80 vs 32)
sound/isa/gus/gus_main.c +400 snd_gus_check_version(42) error: strcpy() card->longname too large for card->shortname (80 vs 32)
sound/usb/caiaq/audio.c +642 snd_usb_caiaq_audio_init(30) error: strcpy() dev->product_name too large for dev->pcm->name (255 vs 80)
sound/usb/caiaq/midi.c +138 snd_usb_caiaq_midi_init(13) error: strcpy() device->product_name too large for rmidi->name (255 vs 80)
