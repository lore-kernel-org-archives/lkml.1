Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYLOReA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYLOReA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 12:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYLORdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 12:33:52 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:35031 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbYLORdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 12:33:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=E1pZ32TbnCjDV0oNPZm3k7haqYLm4TWDNVEmw/r+HQIyJxl0GW9rfBGG5/B0Emc4PW
         TprF8I0RseYz3uQ7P5sOlGu+Rqb/A+oHeQIWj6hqge/+j+7Ls13WXL+D5vzKTAqvsgFu
         UA/6B9g7RYH8CeZWDJNWYVFxPHxogqTH4Xqb0=
Message-ID: <494694F8.6080004@gmail.com>
Date: Mon, 15 Dec 2008 20:33:44 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
References: <gi247o$iog$1@ger.gmane.org> <20081215155655.GA1535@ucw.cz> <gi62fj$bnf$5@ger.gmane.org>
In-Reply-To: <gi62fj$bnf$5@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian J. Murrell wrote:
> On Mon, 15 Dec 2008 16:56:55 +0100, Pavel Machek wrote:
>  
>   
>> Sounds like acpi video driver to me. So you may want to rmmod it before
>> suspend at see what happens. (and cc linux-acpi).
>>     
>
> Please forgive my ignorance.  Which driver would that be?  I currently
> have:
>
> $ lsmod
> Module                  Size  Used by
> af_packet              25088  2 
> i915                   64004  2 
> drm                    93736  3 i915
> rfcomm                 41744  2 
> l2cap                  29312  13 rfcomm
> bluetooth              62436  4 rfcomm,l2cap
> ppdev                  15620  0 
> ipv6                  254836  24 
> acpi_cpufreq           16268  1 
> cpufreq_conservative    14472  0 
> cpufreq_powersave       9856  0 
> cpufreq_ondemand       15244  1 
> cpufreq_userspace      11268  0 
> cpufreq_stats          13188  0 
> freq_table             12672  3 acpi_cpufreq,cpufreq_ondemand,cpufreq_stats
> container              11648  0 
> pci_slot               12680  0 
> sbs                    18952  0 
> sbshc                  13568  1 sbs
> iptable_filter         11008  0 
> ip_tables              19216  1 iptable_filter
> x_tables               22916  1 ip_tables
> parport_pc             40356  0 
> lp                     17156  0 
> parport                42348  3 ppdev,parport_pc,lp
> joydev                 17856  0 
> snd_hda_intel         416052  0 
> snd_seq_dummy          11012  0 
> snd_pcsp               17832  0 
> snd_seq_oss            37248  0 
> snd_pcm_oss            44928  0 
> snd_mixer_oss          22272  1 snd_pcm_oss
> psmouse                49168  0 
> snd_seq_midi           14464  0 
> snd_rawmidi            29184  1 snd_seq_midi
> snd_seq_midi_event     15232  2 snd_seq_oss,snd_seq_midi
> evdev                  17696  6 
> snd_seq                55984  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
> snd_pcm                81156  3 snd_hda_intel,snd_pcsp,snd_pcm_oss
> serio_raw              13444  0 
> snd_timer              28808  2 snd_seq,snd_pcm
> snd_seq_device         15244  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
> iTCO_wdt               19236  0 
> iTCO_vendor_support    11908  1 iTCO_wdt
> video                  25360  0 
>   
this one ^^^^^
> output                 11136  1 video
> snd                    61476  10 snd_hda_intel,snd_pcsp,snd_seq_oss,snd_pcm_oss,snd_mixer_oss,snd_rawmidi,snd_seq,snd_pcm,snd_timer,snd_seq_device
> soundcore              15328  1 snd
> ac                     12420  0 
> snd_page_alloc         17160  2 snd_hda_intel,snd_pcm
> wmi                    14888  0 
> battery                18436  0 
> shpchp                 39828  0 
> pci_hotplug            34976  1 shpchp
> intel_agp              33596  1 
> agpgart                41928  3 drm,intel_agp
> button                 14480  0 
> ext3                  130568  1 
> jbd                    53908  1 ext3
> mbcache                16004  1 ext3
> loop                   22540  2 
> usb_storage            78656  0 
> libusual               30356  1 usb_storage
> sd_mod                 41240  2 
> crc_t10dif             10112  1 sd_mod
> sr_mod                 21956  0 
> cdrom                  42272  1 sr_mod
> sg                     36148  0 
> ahci                   37260  1 
> ata_piix               29700  0 
> pata_acpi              12288  0 
> ata_generic            13060  0 
> 8139too                31744  0 
> 8139cp                 27776  0 
> mii                    13440  2 8139too,8139cp
> libata                176160  4 ahci,ata_piix,pata_acpi,ata_generic
> scsi_mod              156948  5 usb_storage,sd_mod,sr_mod,sg,libata
> ehci_hcd               41996  0 
> uhci_hcd               30352  0 
> usbcore               149392  5 usb_storage,libusual,ehci_hcd,uhci_hcd
> thermal                23708  0 
> processor              49708  4 acpi_cpufreq,thermal
> fan                    12676  0 
> fuse                   58780  3 
>
> Do you mean the i915 driver?  I don't think I will be able to rmmod that
> one given the number of references on it.
>
> Thanx!
>
> b.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

