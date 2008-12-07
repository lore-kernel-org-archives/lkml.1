Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYLGXVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYLGXVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 18:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYLGXVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 18:21:06 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:54741 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbYLGXVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 18:21:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ExwD+pTJw5GvFCwm5Z9t7YOAZ8lYIvWslZhsoO4bU6Kr7/IkewkUQPVavjJrwBAP1U
         Zu5HXJkGIjHiQj4D50EQhXAYDuYzz/8yu7GmRfswI3yT/kJDh8COL8LWRXsu5WLtTEve
         fboBwDFo0Pad4ErGMo+5jOcwDd/mVKWqZyCMc=
Message-ID: <12bfabe40812071521j2f668cf8v96655e572af5c514@mail.gmail.com>
Date: Mon, 8 Dec 2008 00:21:02 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <20081207141337.588aede5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <493AE770.5030507@shaw.ca>
	 <12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com>
	 <493AF2EA.4030601@shaw.ca>
	 <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>
	 <493B4242.1040202@shaw.ca>
	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>
	 <20081207141337.588aede5@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 7, 2008 at 11:13 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sun, 7 Dec 2008 22:55:10 +0100
> "Giangiacomo Mariotti" <gg.mariotti@gmail.com> wrote:
>
>> On Sun, Dec 7, 2008 at 4:25 AM, Robert Hancock <hancockr@shaw.ca>
>> wrote:
>> >
>> > If it only happened once then who knows, could be a cosmic ray or
>> > something.. but if it happens again it sounds like you likely have
>> > a bad CPU.
>> >
>> This same MCE happens every time I boot the 2.6.27.8 kernel, but it
>> never happens with kernel 2.6.26.8. It appears every time at log time
>> [  301.7320xx](where the x represent the scale of the approximation).
>> In the previous log it appeared at [  301.732037], now it appeared at
>> [  301.732042]. It happens just once at that moment and then never
>> more until I reboot. No MCE gets logged with kernel 2.6.26.8 nor with
>> Windows Vista 32bit, not even under very heavy load on memory and
>> cpu(like 3d games or 3d mark vintage). Is this really an hardware
>> problem? Why does it get logged only on kernel 2.6.27.8 at that exact
>> moment? Now I'm gonna compile kernel 2.6.28-rc7 and see if there it
>> happens too. Any suggestion? It would be appreciated, because,
>> depending on the final result, I may be forced to change the
>> hardware(It's still guaranteed, but it'd mean some months without a
>> pc).
>
> which video driver are you using?
> While your HW might be defective (MCE's tend to indicate that), if it's
> software dependent it might also indicate that something, usually a
> video driver, gets the system in a really bad state.
> Also, make sure that you have MCE enabled in both kernels (I'm sure you
> do, but it's one of those things worth double checking)
>
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>

About the .config file :
cat config-2.6.26-1-amd64(unaffected/silent debian unstable based on
2.6.26.8) | grep MCE
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y

cat config-2.6.27.8-nodbg001(affected, built by me) | grep MCE
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y

I have an ati hd4850 1GB. It's not supported by the current x.org
server on my distro(7.3(I tried 7.4 in experimental, but hard lock
up)), so x uses the vesa driver. On 2.6.27.8(affected) I get this :
cat config-2.6.27.8-nodbg001 | grep RADEON
CONFIG_DRM_RADEON=m
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set

But lsmod gives this :
Module                  Size  Used by
binfmt_misc            13836  1
kvm_intel              51136  0
kvm                   149272  1 kvm_intel
acpi_cpufreq           12176  0
cpufreq_userspace       8324  0
cpufreq_stats           9160  0
fuse                   57552  3
loop                   20124  0
snd_pcm_oss            41648  0
snd_mixer_oss          18952  1 snd_pcm_oss
snd_seq_dummy           7300  0
snd_seq_oss            34640  0
snd_seq_midi_event     12168  1 snd_seq_oss
snd_hda_intel         447988  1
snd_seq                57400  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
i2c_i801               14492  0
i2c_core               29592  1 i2c_i801
snd_seq_device         12188  3 snd_seq_dummy,snd_seq_oss,snd_seq
pcspkr                  7040  0
evdev                  15520  3
snd_pcm                84016  2 snd_pcm_oss,snd_hda_intel
snd_timer              26784  2 snd_seq,snd_pcm
snd                    67240  10
snd_pcm_oss,snd_mixer_oss,snd_seq_oss,snd_hda_intel,snd_seq,snd_seq_device,snd_pcm,snd_timer
wmi                    11712  0
button                 11680  0
soundcore              12176  1 snd
snd_page_alloc         13328  2 snd_hda_intel,snd_pcm
firewire_sbp2          20144  7
sg                     37304  0
sr_mod                 20004  0
cdrom                  37928  1 sr_mod
jmicron                 7040  0
ide_pci_generic         8708  0
ide_core              101336  2 jmicron,ide_pci_generic
pata_acpi               9344  0
pata_jmicron            8192  0
sd_mod                 31368  14
usbhid                 47488  0
hid                    44320  1 usbhid
ff_memless              9488  1 usbhid
usb_storage           100000  0
ata_generic            10116  0
firewire_ohci          25996  0
ahci                   36620  5
firewire_core          44976  2 firewire_sbp2,firewire_ohci
crc_itu_t               6400  1 firewire_core
libata                176352  4 pata_acpi,pata_jmicron,ata_generic,ahci
r8169                  33436  0
mii                     9984  1 r8169
scsi_mod              166184  6
firewire_sbp2,sg,sr_mod,sd_mod,usb_storage,libata
dock                   14576  1 libata
ehci_hcd               38552  0
uhci_hcd               26408  0
thermal                23208  0
processor              44468  2 acpi_cpufreq,thermal
fan                     8192  0
thermal_sys            18064  3 thermal,processor,fan

I can't find anything related to radeon or ati in here, so I guess
that the kernel too has loaded a vesa driver?

Giangiacomo
