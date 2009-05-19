Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbZESSim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbZESSim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 14:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZESSif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 14:38:35 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:62311 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbZESSie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 14:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type;
        b=EvLmejtcNgMFG+CEGT9XvMnU4oKcmwXSbwuWCXdzX2i8w4jFxKwBbuCDMpLz6OMpq5
         IL2tCM5lmH0Ibvywq+LFITVlVvzrsd8IuFNNredkFodpqgNc81C86D0WRjffqzdTFg0i
         LN44yU5PFA71yhy6mpro9OCf2d7bPlsKauVJs=
Message-ID: <4A12FCB2.6090409@gmail.com>
Date: Tue, 19 May 2009 20:38:42 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b5pre) Gecko/20090518 Shredder/3.0b3pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: blank screen - unless keyboard/synaptic combo
Content-Type: multipart/mixed;
 boundary="------------040905060405010100080705"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040905060405010100080705
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi there,

I have a strange problem in that during a resume from hibernate my text 
console (or X) remains blank - that is, until I simultaneously press a 
keyboard key and touch the synaptic pad.

It is not sufficient to press just one or the other, it needs to be done 
simultaneously and it resumes fine after doing this. I might be wrong 
but to me actually looks like the first resume script 
(/usr/lib/pm-utils/sleep.d/99info) is only invoked after this 
"recovery", since I notice a "Resuming" message without a command-line 
prompt in the first few seconds after recovery, so it has just started 
or is still executing the resume scripts.

After the grub menu, the laptop will actually display vesafb output 
(vga=791) until just after 100% loading of the hibernation image, then 
the display will go blank. The laptop is a Lenovo W500 with 'hybrid' 
graphics, and the Intel Mobile 4 integrated adapter is set to active.

This happens in 2.6.28, 2.6.29 and up to 2.6.30-rc6. I have had a slight 
few occurrences where this did not happen (not recently), but I could 
never find an explanation for the difference.

I eventually gave up on bisecting this, but it definitely still happened 
in bisects just after ext4dev was renamed to ext4 somewhere after 2.6.27.

Any ideas on what I can do next? I have even tried enabling extra ACPI 
debugging, but I simply do not see any debugging messages happen during 
that key/synaptic combination.

Would the fact that it happens in a text console session perhaps imply 
that it is ACPI or vesafb related?

Thanks in advance!
Niel

--------------040905060405010100080705
Content-Type: text/x-log;
 name="pm-suspend.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pm-suspend.log"

2009-05-19 17:41:13.992560206 +0200: running 'hibernate'/'hibernate'/'' hooks.
===== 2009-05-19 17:41:14.087960120 running hook: /usr/lib/pm-utils/sleep.d/00clear =====
===== 2009-05-19 17:41:14.154333370 running hook: /usr/lib/pm-utils/sleep.d/01logging =====
hibernate initiated: Tue May 19 17:41:14 SAST 2009

Linux linux-7vph 2.6.30-rc6-pae #47 SMP Mon May 18 00:42:36 SAST 2009 i686 i686 i386 GNU/Linux
kernel command line: 'root=/dev/disk/by-id/ata-HITACHI_HTS722020K9SA00_FDE_080726DP0470DTGMUNPC-part6 resume=/dev/disk/by-id/ata-HITACHI_HTS722020K9SA00_FDE_080726DP0470DTGMUNPC-part5 splash=silent showopts vga=791'
Module                  Size  Used by
usbhid                 31700  0
hid                    34812  1 usbhid
nls_utf8                1500  0
tun                    11476  0
i915                  144076  0
drm                   125048  1 i915
i2c_algo_bit            4792  1 i915
af_packet              15580  0
ip6t_LOG                4948  8
xt_tcpudp               2536  10
xt_pkttype              1368  3
ipt_LOG                 4912  9
xt_limit                2044  17
snd_pcm_oss            38248  0
snd_mixer_oss          13788  1 snd_pcm_oss
snd_seq                45068  0
binfmt_misc             7204  1
ip6t_REJECT             3140  3
nf_conntrack_ipv6      11540  6
ip6table_raw            1744  1
xt_NOTRACK              1372  4
ipt_REJECT              2516  3
xt_state                1784  12
iptable_raw             1752  1
iptable_filter          2268  1
cpufreq_conservative     6580  0
cpufreq_userspace       2692  0
ip6table_mangle         2196  0
cpufreq_powersave       1300  0
acpi_cpufreq            7600  0
nf_conntrack_netbios_ns     2100  0
nf_conntrack_ipv4       7244  6
speedstep_lib           3812  0
nf_conntrack           49016  5 nf_conntrack_ipv6,xt_NOTRACK,xt_state,nf_conntrack_netbios_ns,nf_conntrack_ipv4
nf_defrag_ipv4          1564  1 nf_conntrack_ipv4
ip_tables              10032  2 iptable_raw,iptable_filter
ip6table_filter         2180  1
ip6_tables             11016  4 ip6t_LOG,ip6table_raw,ip6table_mangle,ip6table_filter
x_tables               12092  11 ip6t_LOG,xt_tcpudp,xt_pkttype,ipt_LOG,xt_limit,ip6t_REJECT,xt_NOTRACK,ipt_REJECT,xt_state,ip_tables,ip6_tables
ipv6                  216400  27 ip6t_REJECT,nf_conntrack_ipv6,ip6table_mangle
microcode               8296  0
fuse                   48456  9
loop                   13380  0
dm_mod                 47072  0
snd_usb_audio          75372  0
snd_usb_lib            13820  1 snd_usb_audio
snd_rawmidi            18552  1 snd_usb_lib
snd_seq_device          5980  2 snd_seq,snd_rawmidi
arc4                    1580  0
ecb                     2396  0
iwlcore                80604  0
thinkpad_acpi          56216  0
rfkill                  8652  3 iwlcore,thinkpad_acpi
ohci1394               25892  0
led_class               3496  2 iwlcore,thinkpad_acpi
mac80211              148200  1 iwlcore
battery                10332  0
ac                      4156  0
video                  19160  1 i915
ieee1394               67476  1 ohci1394
nvram                   6004  1 thinkpad_acpi
rtc_cmos                9444  0
rtc_core               14588  1 rtc_cmos
rtc_lib                 2204  1 rtc_core
output                  2416  1 video
wmi                     5596  0
snd_hda_codec_conexant    23712  1
snd_hda_intel          23972  0
snd_hda_codec          52592  2 snd_hda_codec_conexant,snd_hda_intel
snd_hwdep               6416  2 snd_usb_audio,snd_hda_codec
snd_pcm                63392  4 snd_pcm_oss,snd_usb_audio,snd_hda_intel,snd_hda_codec
snd_timer              17972  2 snd_seq,snd_pcm
snd                    49816  13 snd_pcm_oss,snd_mixer_oss,snd_seq,snd_usb_audio,snd_usb_lib,snd_rawmidi,snd_seq_device,snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
soundcore               5416  1 snd
button                  5380  0
iTCO_wdt               10228  0
intel_agp              23076  1
snd_page_alloc          7472  2 snd_hda_intel,snd_pcm
e1000e                100340  0
agpgart                26992  2 drm,intel_agp
iTCO_vendor_support     2708  1 iTCO_wdt
cfg80211               53828  2 iwlcore,mac80211
i2c_i801                8384  0
i2c_core               17772  4 i915,drm,i2c_algo_bit,i2c_i801
sr_mod                 12424  0
joydev                  8964  0
cdrom                  28916  1 sr_mod
sg                     25260  0
sd_mod                 24140  7
ehci_hcd               30436  0
uhci_hcd               19364  0
usbcore               119720  6 usbhid,snd_usb_audio,snd_usb_lib,ehci_hcd,uhci_hcd
ext4                  189060  1
jbd2                   55080  1 ext4
crc16                   1608  1 ext4
edd                     7180  0
ext3                  110744  1
mbcache                 6256  2 ext4,ext3
jbd                    46980  1 ext3
fan                     4080  0
ahci                   28240  6
libata                137636  1 ahci
scsi_mod              125084  4 sr_mod,sg,sd_mod,libata
thermal                13944  0
processor              39740  3 acpi_cpufreq

             total       used       free     shared    buffers     cached
Mem:       2018872     863040    1155832          0     110480     716580
-/+ buffers/cache:      35980    1982892
Swap:      2099328      10812    2088516

===== 2009-05-19 17:41:14.203097953 running hook: /usr/lib/pm-utils/sleep.d/02rtcwake =====
rtcwake alarm not enabled in /etc/pm/config.d/rtcwake.config, doing nothing...
===== 2009-05-19 17:41:14.216141442 running hook: /usr/lib/pm-utils/sleep.d/05led =====
===== 2009-05-19 17:41:14.227658409 running hook: /usr/lib/pm-utils/sleep.d/06autofs =====
===== 2009-05-19 17:41:14.352373002 running hook: /usr/lib/pm-utils/sleep.d/10NetworkManager =====
method return sender=:1.6 -> dest=:1.424 reply_serial=2
===== 2009-05-19 17:41:14.467820843 running hook: /usr/lib/pm-utils/sleep.d/30s2disk-check =====
INFO: checking for suspend-to-disk prerequisites...
  using userspace suspend method
  setting resume device to /dev/sda5
  setting image size to 930296217
  adding these parameters from /etc/suspend.conf:
===== 2009-05-19 17:41:14.519640212 running hook: /usr/lib/pm-utils/sleep.d/45pcmcia =====
ejecting PCMCIA cards...
===== 2009-05-19 17:41:14.549873943 running hook: /usr/lib/pm-utils/sleep.d/50modules =====
===== 2009-05-19 17:41:14.586688750 running hook: /usr/lib/pm-utils/sleep.d/80acpi-fan =====
===== 2009-05-19 17:41:14.597395280 running hook: /usr/lib/pm-utils/sleep.d/80videobios =====
===== 2009-05-19 17:41:14.608098318 running hook: /usr/lib/pm-utils/sleep.d/94cpufreq =====
===== 2009-05-19 17:41:14.658163206 running hook: /usr/lib/pm-utils/sleep.d/95led =====
===== 2009-05-19 17:41:14.661601422 running hook: /usr/lib/pm-utils/sleep.d/95packagekit =====
===== 2009-05-19 17:41:14.680630798 running hook: /usr/lib/pm-utils/sleep.d/98video =====
===== 2009-05-19 17:41:14.704497938 running hook: /usr/lib/pm-utils/sleep.d/99Zgrub =====
INFO: running prepare-grub
  Skipping grub entry #2, because it has the noresume option
  Skipping grub entry #4, because it has the noresume option
  Skipping grub entry #7, because it has the noresume option
  Skipping grub entry #10, because it has the noresume option
stat: cannot stat `UUID=3a6813e1-ea3c-403b-8b0a-cc8577e07d76': No such file or directory
  Skipping grub entry #12, because its root= parameter (UUID=3a6813e1-ea3c-403b-8b0a-cc8577e07d76)
    does not match the current root device (/dev/sda6).
  running kernel is grub menu entry 0 (vmlinuz-2.6.30-rc6-pae)
  preparing boot-loader: selecting entry 0, kernel /boot/2.6.30-rc6-pae
  grub-once:   saving original /boot/grub/default
  running '/usr/sbin/grubonce 0'
Using entry #0: openSUSE 11.1 - 2.6.30-rc6
    time needed for sync: 0.0 seconds, time needed for grub: 0.0 seconds.
===== 2009-05-19 17:41:14.837061431 running hook: /usr/lib/pm-utils/sleep.d/99info =====
2009-05-19 17:41:14.840612580: done running hibernate/hibernate hooks.
+ /usr/sbin/s2disk --config /var/lib/s2disk.conf
+ RET=0
+ set +x
2009-05-19 18:36:28.616375442 +0200: running 'hibernate'/'thaw'/'reverse' hooks.
===== 2009-05-19 18:36:28.642346413 running hook: /usr/lib/pm-utils/sleep.d/99info =====
===== 2009-05-19 18:36:28.649111310 running hook: /usr/lib/pm-utils/sleep.d/99Zgrub =====
INFO: running grub-once-restore
  restoring original /boot/grub/default
===== 2009-05-19 18:36:28.655889826 running hook: /usr/lib/pm-utils/sleep.d/98video =====
===== 2009-05-19 18:36:28.664100717 running hook: /usr/lib/pm-utils/sleep.d/95packagekit =====
method return sender=:1.426 -> dest=:1.425 reply_serial=2
===== 2009-05-19 18:36:29.323587290 running hook: /usr/lib/pm-utils/sleep.d/95led =====
===== 2009-05-19 18:36:29.327582141 running hook: /usr/lib/pm-utils/sleep.d/94cpufreq =====
===== 2009-05-19 18:36:29.341824106 running hook: /usr/lib/pm-utils/sleep.d/80videobios =====
===== 2009-05-19 18:36:29.357218591 running hook: /usr/lib/pm-utils/sleep.d/80acpi-fan =====
===== 2009-05-19 18:36:29.362773837 running hook: /usr/lib/pm-utils/sleep.d/50modules =====
===== 2009-05-19 18:36:29.374189325 running hook: /usr/lib/pm-utils/sleep.d/45pcmcia =====
inserting PCMCIA cards...
===== 2009-05-19 18:36:29.380685891 running hook: /usr/lib/pm-utils/sleep.d/30s2disk-check =====
===== 2009-05-19 18:36:29.386997029 running hook: /usr/lib/pm-utils/sleep.d/10NetworkManager =====
method return sender=:1.6 -> dest=:1.428 reply_serial=2
===== 2009-05-19 18:36:29.490646653 running hook: /usr/lib/pm-utils/sleep.d/06autofs =====
===== 2009-05-19 18:36:29.514802724 running hook: /usr/lib/pm-utils/sleep.d/05led =====
===== 2009-05-19 18:36:29.526302717 running hook: /usr/lib/pm-utils/sleep.d/02rtcwake =====
===== 2009-05-19 18:36:29.538773715 running hook: /usr/lib/pm-utils/sleep.d/01logging =====
===== 2009-05-19 18:36:29.549998534 running hook: /usr/lib/pm-utils/sleep.d/00clear =====
2009-05-19 18:36:29.572226566: done running hibernate/thaw hooks.

--------------040905060405010100080705
Content-Type: text/plain;
 name="messages"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="messages"

TWF5IDE5IDE3OjQxOjEzIGxpbnV4LTd2cGggcG0taGliZXJuYXRlWzE5OTg2XTogRW50ZXJp
bmcgaGliZXJuYXRlLiBJbiBjYXNlIG9mIHByb2JsZW1zLCBwbGVhc2UgY2hlY2sgL3Zhci9s
b2cvcG0tc3VzcGVuZC5sb2cKTWF5IDE5IDE3OjQxOjE0IGxpbnV4LTd2cGggYXZhaGktZGFl
bW9uWzI0NzBdOiBXaXRoZHJhd2luZyBhZGRyZXNzIHJlY29yZCBmb3IgZmU4MDo6MjFjOjI1
ZmY6ZmU5NTo5M2VjIG9uIGV0aDAuCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIC0tIE1B
UksgLS0KTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBTeW5jaW5nIGZpbGVz
eXN0ZW1zIC4uLiBkb25lLgpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBzeXNsb2ctbmdb
MjgzOF06IExvZyBzdGF0aXN0aWNzOyBkcm9wcGVkPSdwaXBlKC9kZXYveGNvbnNvbGUpPTAn
LCBkcm9wcGVkPSdwaXBlKC9kZXYvdHR5MTApPTAnLCBwcm9jZXNzZWQ9J2NlbnRlcihxdWV1
ZWQpPTM1NjAnLCBwcm9jZXNzZWQ9J2NlbnRlcihyZWNlaXZlZCk9MjgzNScsIHByb2Nlc3Nl
ZD0nZGVzdGluYXRpb24obmV3c25vdGljZSk9MCcsIHByb2Nlc3NlZD0nZGVzdGluYXRpb24o
YWNwaWQpPTEwJywgcHJvY2Vzc2VkPSdkZXN0aW5hdGlvbihmaXJld2FsbCk9NDk3JywgcHJv
Y2Vzc2VkPSdkZXN0aW5hdGlvbihudWxsKT0yMzknLCBwcm9jZXNzZWQ9J2Rlc3RpbmF0aW9u
KG1haWwpPTYnLCBwcm9jZXNzZWQ9J2Rlc3RpbmF0aW9uKG1haWxpbmZvKT02JywgcHJvY2Vz
c2VkPSdkZXN0aW5hdGlvbihjb25zb2xlKT0yMzUnLCBwcm9jZXNzZWQ9J2Rlc3RpbmF0aW9u
KG5ld3NlcnIpPTAnLCBwcm9jZXNzZWQ9J2Rlc3RpbmF0aW9uKG5ld3Njcml0KT0wJywgcHJv
Y2Vzc2VkPSdkZXN0aW5hdGlvbihtZXNzYWdlcyk9MTM5MScsIHByb2Nlc3NlZD0nZGVzdGlu
YXRpb24obWFpbHdhcm4pPTAnLCBwcm9jZXNzZWQ9J2Rlc3RpbmF0aW9uKGxvY2FsbWVzc2Fn
ZXMpPTAnLCBwcm9jZXNzZWQ9J2Rlc3RpbmF0aW9uKG5ldG1nbSk9NjkyJywgcHJvY2Vzc2Vk
PSdkZXN0aW5hdGlvbihtYWlsZXJyKT0wJywgcHJvY2Vzc2VkPSdkZXN0aW5hdGlvbih4Y29u
c29sZSk9MjM1JywgcHJvY2Vzc2VkPSdkZXN0aW5hdGlvbih3YXJuKT0yNDknLCBwcm9jZXNz
ZWQ9J3NvdXJjZShzcmMpPTI4MzUnCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5l
bDogRnJlZXppbmcgdXNlciBzcGFjZSBwcm9jZXNzZXMgLi4uIChlbGFwc2VkIDAuMDAgc2Vj
b25kcykgZG9uZS4KTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBGcmVlemlu
ZyByZW1haW5pbmcgZnJlZXphYmxlIHRhc2tzIC4uLiAoZWxhcHNlZCAwLjAwIHNlY29uZHMp
IGRvbmUuCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogUE06IFNocmlua2lu
ZyBtZW1vcnkuLi4gZG9uZSAoNDIyMCBwYWdlcyBmcmVlZCkKTWF5IDE5IDE4OjM1OjUzIGxp
bnV4LTd2cGgga2VybmVsOiBQTTogRnJlZWQgMTY4ODAga2J5dGVzIGluIDAuMjQgc2Vjb25k
cyAoNzAuMzMgTUIvcykKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBTdXNw
ZW5kaW5nIGNvbnNvbGUocykgKHVzZSBub19jb25zb2xlX3N1c3BlbmQgdG8gZGVidWcpCk1h
eSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogc2QgMDowOjA6MDogW3NkYV0gU3lu
Y2hyb25pemluZyBTQ1NJIGNhY2hlCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5l
bDogQUNQSSBoYW5kbGUgaGFzIG5vIGNvbnRleHQhCk1heSAxOSAxODozNTo1MyBsaW51eC03
dnBoIGtlcm5lbDogZWhjaV9oY2QgMDAwMDowMDoxZC43OiBQQ0kgSU5UIEQgZGlzYWJsZWQK
TWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBlaGNpX2hjZCAwMDAwOjAwOjFk
Ljc6IFBNRSMgZGlzYWJsZWQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiB1
aGNpX2hjZCAwMDAwOjAwOjFkLjI6IFBDSSBJTlQgQyBkaXNhYmxlZApNYXkgMTkgMTg6MzU6
NTMgbGludXgtN3ZwaCBrZXJuZWw6IHVoY2lfaGNkIDAwMDA6MDA6MWQuMTogUENJIElOVCBC
IGRpc2FibGVkCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogdWhjaV9oY2Qg
MDAwMDowMDoxZC4wOiBQQ0kgSU5UIEEgZGlzYWJsZWQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4
LTd2cGgga2VybmVsOiBIREEgSW50ZWwgMDAwMDowMDoxYi4wOiBQQ0kgSU5UIEIgZGlzYWJs
ZWQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBlaGNpX2hjZCAwMDAwOjAw
OjFhLjc6IFBDSSBJTlQgRCBkaXNhYmxlZApNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBr
ZXJuZWw6IGVoY2lfaGNkIDAwMDA6MDA6MWEuNzogUE1FIyBkaXNhYmxlZApNYXkgMTkgMTg6
MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IHVoY2lfaGNkIDAwMDA6MDA6MWEuMjogUENJIElO
VCBDIGRpc2FibGVkCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogdWhjaV9o
Y2QgMDAwMDowMDoxYS4xOiBQQ0kgSU5UIEIgZGlzYWJsZWQKTWF5IDE5IDE4OjM1OjUzIGxp
bnV4LTd2cGgga2VybmVsOiB1aGNpX2hjZCAwMDAwOjAwOjFhLjA6IFBDSSBJTlQgQSBkaXNh
YmxlZApNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IGUxMDAwZSAwMDAwOjAw
OjE5LjA6IFBDSSBJTlQgQSBkaXNhYmxlZApNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBr
ZXJuZWw6IGUxMDAwZSAwMDAwOjAwOjE5LjA6IFBNRSMgZW5hYmxlZApNYXkgMTkgMTg6MzU6
NTMgbGludXgtN3ZwaCBrZXJuZWw6IGUxMDAwZSAwMDAwOjAwOjE5LjA6IHdha2UtdXAgY2Fw
YWJpbGl0eSBlbmFibGVkIGJ5IEFDUEkKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2Vy
bmVsOiBBQ1BJOiBQcmVwYXJpbmcgdG8gZW50ZXIgc3lzdGVtIHNsZWVwIHN0YXRlIFM0Ck1h
eSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogUE06IFNhdmluZyBwbGF0Zm9ybSBO
VlMgbWVtb3J5Ck1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogRGlzYWJsaW5n
IG5vbi1ib290IENQVXMgLi4uCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDog
Q1BVIDEgaXMgbm93IG9mZmxpbmUKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVs
OiBTTVAgYWx0ZXJuYXRpdmVzOiBzd2l0Y2hpbmcgdG8gVVAgY29kZQpNYXkgMTkgMTg6MzU6
NTMgbGludXgtN3ZwaCBrZXJuZWw6IENQVTAgYXR0YWNoaW5nIE5VTEwgc2NoZWQtZG9tYWlu
LgpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IENQVTEgYXR0YWNoaW5nIE5V
TEwgc2NoZWQtZG9tYWluLgpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IENQ
VTAgYXR0YWNoaW5nIE5VTEwgc2NoZWQtZG9tYWluLgpNYXkgMTkgMTg6MzU6NTMgbGludXgt
N3ZwaCBrZXJuZWw6IENQVTEgaXMgZG93bgpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBr
ZXJuZWw6IEV4dGVuZGVkIENNT1MgeWVhcjogMjAwMApNYXkgMTkgMTg6MzU6NTMgbGludXgt
N3ZwaCBrZXJuZWw6IFBNOiBDcmVhdGluZyBoaWJlcm5hdGlvbiBpbWFnZTogCk1heSAxOSAx
ODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogUE06IE5lZWQgdG8gY29weSAyMjUyMTMgcGFn
ZXMKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiB4ODYgUEFUIGVuYWJsZWQ6
IGNwdSAwLCBvbGQgMHg3MDQwNjAwMDcwNDA2LCBuZXcgMHg3MDEwNjAwMDcwMTA2Ck1heSAx
OSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogSW50ZWwgbWFjaGluZSBjaGVjayBhcmNo
aXRlY3R1cmUgc3VwcG9ydGVkLgpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6
IEludGVsIG1hY2hpbmUgY2hlY2sgcmVwb3J0aW5nIGVuYWJsZWQgb24gQ1BVIzAuCk1heSAx
OSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogUE06IFJlc3RvcmluZyBwbGF0Zm9ybSBO
VlMgbWVtb3J5Ck1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogRXh0ZW5kZWQg
Q01PUyB5ZWFyOiAyMDAwCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogRW5h
Ymxpbmcgbm9uLWJvb3QgQ1BVcyAuLi4KTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2Vy
bmVsOiBTTVAgYWx0ZXJuYXRpdmVzOiBzd2l0Y2hpbmcgdG8gU01QIGNvZGUKTWF5IDE5IDE4
OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBCb290aW5nIHByb2Nlc3NvciAxIEFQSUMgMHgx
IGlwIDB4NjAwMApNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IEluaXRpYWxp
emluZyBDUFUjMQpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IENhbGlicmF0
aW5nIGRlbGF5IHVzaW5nIHRpbWVyIHNwZWNpZmljIHJvdXRpbmUuLiAxMzIzNi43MCBCb2dv
TUlQUyAobHBqPTI2NDczNDExKQpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6
IENQVTogTDEgSSBjYWNoZTogMzJLLCBMMSBEIGNhY2hlOiAzMksKTWF5IDE5IDE4OjM1OjUz
IGxpbnV4LTd2cGgga2VybmVsOiBDUFU6IEwyIGNhY2hlOiA2MTQ0SwpNYXkgMTkgMTg6MzU6
NTMgbGludXgtN3ZwaCBrZXJuZWw6IENQVTogUGh5c2ljYWwgUHJvY2Vzc29yIElEOiAwCk1h
eSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogQ1BVOiBQcm9jZXNzb3IgQ29yZSBJ
RDogMQpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IEludGVsIG1hY2hpbmUg
Y2hlY2sgYXJjaGl0ZWN0dXJlIHN1cHBvcnRlZC4KTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2
cGgga2VybmVsOiBJbnRlbCBtYWNoaW5lIGNoZWNrIHJlcG9ydGluZyBlbmFibGVkIG9uIENQ
VSMxLgpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IHg4NiBQQVQgZW5hYmxl
ZDogY3B1IDEsIG9sZCAweDcwNDA2MDAwNzA0MDYsIG5ldyAweDcwMTA2MDAwNzAxMDYKTWF5
IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBDUFUxOiBJbnRlbChSKSBDb3JlKFRN
KTIgRHVvIENQVSAgICAgVDk0MDAgIEAgMi41M0dIeiBzdGVwcGluZyAwNgpNYXkgMTkgMTg6
MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IENQVTAgYXR0YWNoaW5nIE5VTEwgc2NoZWQtZG9t
YWluLgpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IFN3aXRjaGVkIHRvIGhp
Z2ggcmVzb2x1dGlvbiBtb2RlIG9uIENQVSAxCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBo
IGtlcm5lbDogQ1BVMCBhdHRhY2hpbmcgc2NoZWQtZG9tYWluOgpNYXkgMTkgMTg6MzU6NTMg
bGludXgtN3ZwaCBrZXJuZWw6ICBkb21haW4gMDogc3BhbiAwLTEgbGV2ZWwgTUMKTWF5IDE5
IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiAgIGdyb3VwczogMCAxCk1heSAxOSAxODoz
NTo1MyBsaW51eC03dnBoIGtlcm5lbDogQ1BVMSBhdHRhY2hpbmcgc2NoZWQtZG9tYWluOgpN
YXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6ICBkb21haW4gMDogc3BhbiAwLTEg
bGV2ZWwgTUMKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiAgIGdyb3Vwczog
MSAwCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogbWljcm9jb2RlOiBmYWls
ZWQgdG8gaW5pdCBDUFUxCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogQ1BV
MSBpcyB1cApNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IEFDUEk6IFdha2lu
ZyB1cCBmcm9tIHN5c3RlbSBzbGVlcCBzdGF0ZSBTNApNYXkgMTkgMTg6MzU6NTMgbGludXgt
N3ZwaCBrZXJuZWw6IHBjaSAwMDAwOjAwOjAyLjA6IHJlc3RvcmluZyBjb25maWcgc3BhY2Ug
YXQgb2Zmc2V0IDB4MSAod2FzIDB4OTAwMDA3LCB3cml0aW5nIDB4OTAwNDAzKQpNYXkgMTkg
MTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IHVoY2lfaGNkIDAwMDA6MDA6MWEuMDogcG93
ZXIgc3RhdGUgY2hhbmdlZCBieSBBQ1BJIHRvIEQwCk1heSAxOSAxODozNTo1MyBsaW51eC03
dnBoIGtlcm5lbDogdWhjaV9oY2QgMDAwMDowMDoxYS4yOiBwb3dlciBzdGF0ZSBjaGFuZ2Vk
IGJ5IEFDUEkgdG8gRDAKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBIREEg
SW50ZWwgMDAwMDowMDoxYi4wOiByZXN0b3JpbmcgY29uZmlnIHNwYWNlIGF0IG9mZnNldCAw
eDEgKHdhcyAweDEwMDEwNiwgd3JpdGluZyAweDEwMDEwMikKTWF5IDE5IDE4OjM1OjUzIGxp
bnV4LTd2cGgga2VybmVsOiB1aGNpX2hjZCAwMDAwOjAwOjFkLjA6IHBvd2VyIHN0YXRlIGNo
YW5nZWQgYnkgQUNQSSB0byBEMApNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6
IGFoY2kgMDAwMDowMDoxZi4yOiByZXN0b3JpbmcgY29uZmlnIHNwYWNlIGF0IG9mZnNldCAw
eDEgKHdhcyAweDJiMDA0MDMsIHdyaXRpbmcgMHgyYjAwNDA3KQpNYXkgMTkgMTg6MzU6NTMg
bGludXgtN3ZwaCBrZXJuZWw6IHBjaSAwMDAwOjAzOjAwLjA6IHJlc3RvcmluZyBjb25maWcg
c3BhY2UgYXQgb2Zmc2V0IDB4MSAod2FzIDB4MTAwMTA2LCB3cml0aW5nIDB4MTAwMTAyKQpN
YXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IHBjaSAwMDAwOjAwOjAyLjA6IFBN
RSMgZGlzYWJsZWQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBwY2kgMDAw
MDowMDowMi4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKTWF5IDE5IDE4OjM1OjUz
IGxpbnV4LTd2cGgga2VybmVsOiBwY2kgMDAwMDowMDowMi4xOiBQTUUjIGRpc2FibGVkCk1h
eSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogcGNpIDAwMDA6MDA6MDMuMDogUE1F
IyBkaXNhYmxlZApNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IGUxMDAwZSAw
MDAwOjAwOjE5LjA6IFBDSSBJTlQgQSAtPiBHU0kgMjAgKGxldmVsLCBsb3cpIC0+IElSUSAy
MApNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IGUxMDAwZSAwMDAwOjAwOjE5
LjA6IHBjaV9lbmFibGVfcGNpZV9lcnJvcl9yZXBvcnRpbmcgZmFpbGVkIDB4ZmZmZmZmZmIK
TWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBlMTAwMGUgMDAwMDowMDoxOS4w
OiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2
cGgga2VybmVsOiBlMTAwMGUgMDAwMDowMDoxOS4wOiB3YWtlLXVwIGNhcGFiaWxpdHkgZGlz
YWJsZWQgYnkgQUNQSQpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IGUxMDAw
ZSAwMDAwOjAwOjE5LjA6IFBNRSMgZGlzYWJsZWQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2
cGgga2VybmVsOiBlMTAwMGUgMDAwMDowMDoxOS4wOiB3YWtlLXVwIGNhcGFiaWxpdHkgZGlz
YWJsZWQgYnkgQUNQSQpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IGUxMDAw
ZSAwMDAwOjAwOjE5LjA6IFBNRSMgZGlzYWJsZWQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2
cGgga2VybmVsOiBlMTAwMGUgMDAwMDowMDoxOS4wOiBpcnEgMjkgZm9yIE1TSS9NU0ktWApN
YXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IHVoY2lfaGNkIDAwMDA6MDA6MWEu
MDogUENJIElOVCBBIC0+IEdTSSAyMCAobGV2ZWwsIGxvdykgLT4gSVJRIDIwCk1heSAxOSAx
ODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogdWhjaV9oY2QgMDAwMDowMDoxYS4wOiBzZXR0
aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2Vy
bmVsOiB1aGNpX2hjZCAwMDAwOjAwOjFhLjE6IFBDSSBJTlQgQiAtPiBHU0kgMjEgKGxldmVs
LCBsb3cpIC0+IElSUSAyMQpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IHVo
Y2lfaGNkIDAwMDA6MDA6MWEuMTogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0Ck1heSAx
OSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogdWhjaV9oY2QgMDAwMDowMDoxYS4yOiBQ
Q0kgSU5UIEMgLT4gR1NJIDIyIChsZXZlbCwgbG93KSAtPiBJUlEgMjIKTWF5IDE5IDE4OjM1
OjUzIGxpbnV4LTd2cGgga2VybmVsOiB1aGNpX2hjZCAwMDAwOjAwOjFhLjI6IHNldHRpbmcg
bGF0ZW5jeSB0aW1lciB0byA2NApNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6
IGVoY2lfaGNkIDAwMDA6MDA6MWEuNzogUE1FIyBkaXNhYmxlZApNYXkgMTkgMTg6MzU6NTMg
bGludXgtN3ZwaCBrZXJuZWw6IGVoY2lfaGNkIDAwMDA6MDA6MWEuNzogUENJIElOVCBEIC0+
IEdTSSAyMyAobGV2ZWwsIGxvdykgLT4gSVJRIDIzCk1heSAxOSAxODozNTo1MyBsaW51eC03
dnBoIGtlcm5lbDogZWhjaV9oY2QgMDAwMDowMDoxYS43OiBzZXR0aW5nIGxhdGVuY3kgdGlt
ZXIgdG8gNjQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBlaGNpX2hjZCAw
MDAwOjAwOjFhLjc6IFBNRSMgZGlzYWJsZWQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgg
a2VybmVsOiBIREEgSW50ZWwgMDAwMDowMDoxYi4wOiBQQ0kgSU5UIEIgLT4gR1NJIDE3IChs
ZXZlbCwgbG93KSAtPiBJUlEgMTcKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVs
OiBIREEgSW50ZWwgMDAwMDowMDoxYi4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQK
TWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiB1aGNpX2hjZCAwMDAwOjAwOjFk
LjA6IFBDSSBJTlQgQSAtPiBHU0kgMTYgKGxldmVsLCBsb3cpIC0+IElSUSAxNgpNYXkgMTkg
MTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IHVoY2lfaGNkIDAwMDA6MDA6MWQuMDogc2V0
dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0Ck1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtl
cm5lbDogdWhjaV9oY2QgMDAwMDowMDoxZC4xOiBQQ0kgSU5UIEIgLT4gR1NJIDE3IChsZXZl
bCwgbG93KSAtPiBJUlEgMTcKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiB1
aGNpX2hjZCAwMDAwOjAwOjFkLjE6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApNYXkg
MTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IHVoY2lfaGNkIDAwMDA6MDA6MWQuMjog
UENJIElOVCBDIC0+IEdTSSAxOCAobGV2ZWwsIGxvdykgLT4gSVJRIDE4Ck1heSAxOSAxODoz
NTo1MyBsaW51eC03dnBoIGtlcm5lbDogdWhjaV9oY2QgMDAwMDowMDoxZC4yOiBzZXR0aW5n
IGxhdGVuY3kgdGltZXIgdG8gNjQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVs
OiBlaGNpX2hjZCAwMDAwOjAwOjFkLjc6IFBNRSMgZGlzYWJsZWQKTWF5IDE5IDE4OjM1OjUz
IGxpbnV4LTd2cGgga2VybmVsOiBlaGNpX2hjZCAwMDAwOjAwOjFkLjc6IFBDSSBJTlQgRCAt
PiBHU0kgMTkgKGxldmVsLCBsb3cpIC0+IElSUSAxOQpNYXkgMTkgMTg6MzU6NTMgbGludXgt
N3ZwaCBrZXJuZWw6IGVoY2lfaGNkIDAwMDA6MDA6MWQuNzogc2V0dGluZyBsYXRlbmN5IHRp
bWVyIHRvIDY0Ck1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogZWhjaV9oY2Qg
MDAwMDowMDoxZC43OiBQTUUjIGRpc2FibGVkCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBo
IGtlcm5lbDogcGNpIDAwMDA6MDA6MWUuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0
Ck1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogYWhjaSAwMDAwOjAwOjFmLjI6
IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApNYXkgMTkgMTg6MzU6NTMgbGludXgtN3Zw
aCBrZXJuZWw6IHBjaSAwMDAwOjAzOjAwLjA6IFBNRSMgZGlzYWJsZWQKTWF5IDE5IDE4OjM1
OjUzIGxpbnV4LTd2cGgga2VybmVsOiBwY2kgMDAwMDoxNTowMC4wOiBQQ0kgSU5UIEEgLT4g
R1NJIDE2IChsZXZlbCwgbG93KSAtPiBJUlEgMTYKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2
cGgga2VybmVsOiBvaGNpMTM5NDogZnctaG9zdDA6IE9IQ0ktMTM5NCAxLjEgKFBDSSk6IElS
UT1bMTddICBNTUlPPVtmNDgwMTAwMC1mNDgwMTdmZl0gIE1heCBQYWNrZXQ9WzIwNDhdICBJ
Ui9JVCBjb250ZXh0cz1bNC80XQpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6
IHBjaSAwMDAwOjE1OjAwLjI6IFBNRSMgZGlzYWJsZWQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4
LTd2cGgga2VybmVsOiBwY2kgMDAwMDoxNTowMC4zOiBQTUUjIGRpc2FibGVkCk1heSAxOSAx
ODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogcGNpIDAwMDA6MTU6MDAuNDogUE1FIyBkaXNh
YmxlZApNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IHBjaSAwMDAwOjE1OjAw
LjU6IFBNRSMgZGlzYWJsZWQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBz
ZCAwOjA6MDowOiBbc2RhXSBTdGFydGluZyBkaXNrCk1heSAxOSAxODozNTo1MyBsaW51eC03
dnBoIGtlcm5lbDogYXRhMTogU0FUQSBsaW5rIHVwIDEuNSBHYnBzIChTU3RhdHVzIDExMyBT
Q29udHJvbCAzMDApCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogYXRhMjog
U0FUQSBsaW5rIHVwIDEuNSBHYnBzIChTU3RhdHVzIDExMyBTQ29udHJvbCAzMDApCk1heSAx
OSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogYXRhMS4wMDogQUNQSSBjbWQgZWYvMDI6
MDA6MDA6MDA6MDA6YTAgc3VjY2VlZGVkCk1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtl
cm5lbDogYXRhMS4wMDogQUNQSSBjbWQgZjUvMDA6MDA6MDA6MDA6MDA6YTAgZmlsdGVyZWQg
b3V0Ck1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogYXRhMS4wMDogQUNQSSBj
bWQgZWYvNWY6MDA6MDA6MDA6MDA6YTAgc3VjY2VlZGVkCk1heSAxOSAxODozNTo1MyBsaW51
eC03dnBoIGtlcm5lbDogYXRhMS4wMDogQUNQSSBjbWQgZWYvMTA6MDM6MDA6MDA6MDA6YTAg
ZmlsdGVyZWQgb3V0Ck1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogYXRhMS4w
MDogQUNQSSBjbWQgZWYvMDI6MDA6MDA6MDA6MDA6YTAgc3VjY2VlZGVkCk1heSAxOSAxODoz
NTo1MyBsaW51eC03dnBoIGtlcm5lbDogYXRhMS4wMDogQUNQSSBjbWQgZjUvMDA6MDA6MDA6
MDA6MDA6YTAgZmlsdGVyZWQgb3V0Ck1heSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5l
bDogYXRhMS4wMDogQUNQSSBjbWQgZWYvNWY6MDA6MDA6MDA6MDA6YTAgc3VjY2VlZGVkCk1h
eSAxOSAxODozNTo1MyBsaW51eC03dnBoIGtlcm5lbDogYXRhMS4wMDogQUNQSSBjbWQgZWYv
MTA6MDM6MDA6MDA6MDA6YTAgZmlsdGVyZWQgb3V0Ck1heSAxOSAxODozNTo1MyBsaW51eC03
dnBoIGtlcm5lbDogYXRhMS4wMDogY29uZmlndXJlZCBmb3IgVURNQS8xMzMKTWF5IDE5IDE4
OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBhdGEyLjAwOiBBQ1BJIGNtZCBlMy8wMDoxZjow
MDowMDowMDphMCBzdWNjZWVkZWQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVs
OiBhdGEyLjAwOiBBQ1BJIGNtZCBlMy8wMDowMjowMDowMDowMDphMCBzdWNjZWVkZWQKTWF5
IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBhdGEyLjAwOiBBQ1BJIGNtZCBlMy8w
MDoxZjowMDowMDowMDphMCBzdWNjZWVkZWQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgg
a2VybmVsOiBhdGEyLjAwOiBBQ1BJIGNtZCBlMy8wMDowMjowMDowMDowMDphMCBzdWNjZWVk
ZWQKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBhdGExOiBleGNlcHRpb24g
RW1hc2sgMHgxMCBTQWN0IDB4MCBTRXJyIDB4MCBhY3Rpb24gMHg5IHQ0Ck1heSAxOSAxODoz
NTo1MyBsaW51eC03dnBoIGtlcm5lbDogYXRhMTogaXJxX3N0YXQgMHgwMDQwMDA0MCwgY29u
bmVjdGlvbiBzdGF0dXMgY2hhbmdlZApNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJu
ZWw6IGF0YTEuMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTMzCk1heSAxOSAxODozNTo1MyBs
aW51eC03dnBoIGtlcm5lbDogYXRhMTogRUggY29tcGxldGUKTWF5IDE5IDE4OjM1OjUzIGxp
bnV4LTd2cGgga2VybmVsOiBhdGEyLjAwOiBjb25maWd1cmVkIGZvciBVRE1BLzEzMwpNYXkg
MTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IGF0YTI6IGV4Y2VwdGlvbiBFbWFzayAw
eDEwIFNBY3QgMHgwIFNFcnIgMHgwIGFjdGlvbiAweDkgdDQKTWF5IDE5IDE4OjM1OjUzIGxp
bnV4LTd2cGgga2VybmVsOiBhdGEyOiBpcnFfc3RhdCAweDQwMDAwMDAxCk1heSAxOSAxODoz
NTo1MyBsaW51eC03dnBoIGtlcm5lbDogYXRhMi4wMDogY29uZmlndXJlZCBmb3IgVURNQS8x
MzMKTWF5IDE5IDE4OjM1OjUzIGxpbnV4LTd2cGgga2VybmVsOiBhdGEyOiBFSCBjb21wbGV0
ZQpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IHBjaSAwMDAwOjAwOjAyLjA6
IHJlc3RvcmluZyBjb25maWcgc3BhY2UgYXQgb2Zmc2V0IDB4MSAod2FzIDB4OTAwNDA3LCB3
cml0aW5nIDB4OTAwNDAzKQpNYXkgMTkgMTg6MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IHBj
aSAwMDAwOjAwOjAyLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApNYXkgMTkgMTg6
MzU6NTMgbGludXgtN3ZwaCBrZXJuZWw6IFJlc3RhcnRpbmcgdGFza3MgLi4uIGRvbmUuCk1h
eSAxOSAxODozNjoyOSBsaW51eC03dnBoIGtlcm5lbDogZTEwMDBlIDAwMDA6MDA6MTkuMDog
aXJxIDI5IGZvciBNU0kvTVNJLVgKTWF5IDE5IDE4OjM2OjI5IGxpbnV4LTd2cGgga2VybmVs
OiBlMTAwMGUgMDAwMDowMDoxOS4wOiBpcnEgMjkgZm9yIE1TSS9NU0ktWApNYXkgMTkgMTg6
MzY6MjkgbGludXgtN3ZwaCBrZXJuZWw6IEFERFJDT05GKE5FVERFVl9VUCk6IGV0aDA6IGxp
bmsgaXMgbm90IHJlYWR5Ck1heSAxOSAxODozNjo0MCBsaW51eC03dnBoIGluaXQ6IFN3aXRj
aGluZyB0byBydW5sZXZlbDogNQoK
--------------040905060405010100080705--
