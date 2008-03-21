Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbYCUSbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbYCUSbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYCUSa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:30:56 -0400
Received: from 26.mail-out.ovh.net ([91.121.27.225]:37183 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752885AbYCUSaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:30:55 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2008 14:30:55 EDT
Subject: Re: BUG: soft lockup detected on Phenom with Debian 2.6.24-4
From: Laurent GUERBY <laurent@guerby.net>
Reply-To: laurent@guerby.net
To: Peter Oruba <peter.oruba@amd.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47E26A5D.40401@amd.com>
References: <1205013615.15075.409.camel@localhost>
	 <1205678588.15075.563.camel@localhost>
	 <1206015619.15075.666.camel@localhost>  <47E26A5D.40401@amd.com>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 19:23:56 +0100
Message-Id: <1206123836.15075.699.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 82.235.162.148 (gut75-4-82-235-162-148.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
X-Ovh-Tracer-Id: 18260970590232059415
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 14:45 +0100, Peter Oruba wrote:
> Laurent,
> 
> you may have triggered the L2 eviction bug (E298).
> 
> Please try
> 
> hexdump -s 0xc0010015 -n 8 -C /dev/cpu/0/msr
> 
> Output is little-endian, so the left-most byte must have bit 3 enabled meaning 
> TLB caching is disabled.

Hi Peter,

Since I did not have /dev/cpu I did after some searching:

for i in 0 1 2 3; do
	mkdir -p /dev/cpu/$i
	mknod -m 444 /dev/cpu/$i/msr c 202 $i
	mknod -m 444 /dev/cpu/$i/cpuid c 203 $i
done
modprobe msr

Then:

# hexdump -s 0xc0010015 -n 8 -C /dev/cpu/0/msr
# echo $?
0
# cat /proc/version 
Linux version 2.6.24-1-amd64 (Debian 2.6.24-4) (waldi@debian.org) (gcc
version 4.1.3 20080114 (prerelease) (Debian 4.1.2-19)) #1 SMP Mon Feb 11
13:47:43 UTC 2008

When I look at hexdump -v it's only zeroes for as long as I run it.

What am I doing wrong?

Thanks for your help!

Laurent

# lsmod
Module                  Size  Used by
msr                     8968  0 
nfs                   258800  0 
tun                    16512  1 
cpufreq_userspace       9604  4 
nfsd                  261416  17 
lockd                  73136  3 nfs,nfsd
nfs_acl                 8192  2 nfs,nfsd
auth_rpcgss            53152  1 nfsd
sunrpc                201096  11 nfs,nfsd,lockd,nfs_acl,auth_rpcgss
exportfs                9472  1 nfsd
ac                     11400  0 
battery                19976  0 
ipv6                  286248  28 
it87                   28432  0 
hwmon_vid               7424  1 it87
k8temp                 10496  0 
eeprom                 12688  0 
powernow_k8            18464  0 
freq_table              9728  1 powernow_k8
loop                   22788  0 
snd_hda_intel         362024  0 
parport_pc             42408  0 
parport                44812  1 parport_pc
serio_raw              11908  0 
snd_pcm                89352  1 snd_hda_intel
snd_timer              28552  1 snd_pcm
snd                    65896  3 snd_hda_intel,snd_pcm,snd_timer
soundcore              13216  1 snd
snd_page_alloc         15248  2 snd_hda_intel,snd_pcm
pcspkr                  7808  0 
i2c_piix4              13708  0 
psmouse                45724  0 
i2c_core               29824  2 eeprom,i2c_piix4
shpchp                 38428  0 
button                 13984  0 
pci_hotplug            35504  1 shpchp
evdev                  17024  0 
ext3                  139024  1 
jbd                    55976  1 ext3
mbcache                13952  1 ext3
dm_mirror              27008  0 
dm_snapshot            21960  0 
dm_mod                 67832  2 dm_mirror,dm_snapshot
ata_generic            13060  0 
sd_mod                 33408  3 
generic                 9732  0 [permanent]
usbhid                 35168  0 
hid                    41792  1 usbhid
atiixp                  9488  0 [permanent]
ahci                   34436  2 
ide_core              144920  2 generic,atiixp
libata                162736  2 ata_generic,ahci
ehci_hcd               39692  0 
ohci_hcd               28164  0 
scsi_mod              170296  2 sd_mod,libata
r8169                  36740  0 
thermal                22688  0 
processor              45032  2 powernow_k8,thermal
fan                     9864  0 


