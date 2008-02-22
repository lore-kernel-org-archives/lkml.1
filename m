Return-Path: <linux-kernel-owner+w=401wt.eu-S933915AbYBVCk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915AbYBVCk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 21:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYBVCku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 21:40:50 -0500
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:53577 "EHLO
	QMTA06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667AbYBVCks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 21:40:48 -0500
X-Authority-Analysis: v=1.0 c=1 a=bojhYoMd2USPMMK5XVEeMQ==:17
 a=VwQbUJbxAAAA:8 a=D19gQVrFAAAA:8 a=iJjXVrw5C3vwA4nb9hUA:9
 a=_Ayk2URJd7knBYdhaAIA:7 a=wHP4tCVvZRHsj0h7IQqMsHSaeVoA:4 a=KUJAPYlYduUA:10
 a=NGZ4GenLPXtwg8WMGAoA:9 a=5T83RzT95IWuBjbdDFh96TaPm1UA:4 a=EvFsD9_1mWgA:10
 a=E_3L3C9wAYWFqiRHxHUA:9 a=8KmEY9pgPVe379_MdlpELJdBpHoA:4 a=AdgF1SG24AkA:10
 a=nvkOlbG-Rbcw6eoSUbAA:9 a=E3y84McwGaHyOqBK2xRx1gaegMcA:4 a=5xtMX0l_OgIA:10
 a=E5kuEPVFmiF69HLpMNYA:9 a=wJ8Tkz0akcfLJ0s-2mUA:7
 a=8iWkZXvRdtGHs4Xw7S4n5rWd04AA:4 a=UfEgg7rCM0AA:10
From: kelk1@comcast.net (Quel Qun)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
Date: Fri, 22 Feb 2008 02:40:41 +0000
Message-Id: <022220080240.25836.47BE362900072A1C000064EC2200761394CE05040A05@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct 30 2007)
X-Authenticated-Sender: a2VsazFAY29tY2FzdC5uZXQ=
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NextPart_Webmail_9m3u9jl4l_25836_1203648041_0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NextPart_Webmail_9m3u9jl4l_25836_1203648041_0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit


 -------------- Original message ----------------------
From: Thomas Gleixner <tglx@linutronix.de>
> On Thu, 21 Feb 2008, Quel Qun wrote:
> > > >  > Not that I'm aware off, but this might as well be some old use after
> > > >  > free bug which got exposed by some unrelated change. The good news is
> > > >  > that it is reproducible. I'll hack up some nasty debug patch which
> > > >  > lets us - hopefully - decode where the timer was armed.
> > > >
> > > >  Quel, before I do that, is there any chance that you retest with the
> > > >  latest mainline git version ?
> > > >
> > > >  
> > > 
> http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.25-rc2-git4.bz2
> > > 
> > > And please test with this patch as well:
> > > 
> > > http://lkml.org/lkml/2008/2/20/121
> > > 
> > Same kind of result unfortunately with this last patch on top of git4:
> 
> At least it is fully reproducible. Please apply the patch below to
> your git4 tree and do not change your .config. The output should show,
> which code armed the timer.
> 
Thomas,

Thanks for the patch, but that did not work, I never got the trace.

I switched to git5 and applied the patch.

First crash (= attached kernlog.9) showed some hald process, so I decided to reduce the number of services and processes to a maximum. Attached are process list before starting sdptool browse and crashing, list of modules and list of services.

Second crash:

BUG: unable to handle kernel paging request at 6b6b6b6b
IP: [<c012d51d>] get_next_timer_interrupt+0x11f/0x234
*pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: hidp rfcomm l2cap nfsd exportfs nfs lockd nfs_acl sunrpc autofs4 af_packet binfmt_misc loop nls_iso8859_1 nls_cp437 vfat fat fuse snd_pcm_oss snd_mixer_oss snd_intel8x0 snd_ac97_codec hci_usb ac97_bus snd_pcm parport_pc snd_timer snd sr_mod i2c_i801 rtc_cmos iTCO_wdt i2c_core parport soundcore iTCO_vendor_support pcspkr snd_page_alloc bluetooth button thermal processor evdev dcdbas tg3 sg ide_disk piix ide_core ata_piix ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]

Pid: 0, comm: swapper Not tainted (2.6.25-rc2-git5kk1 #1)
EIP: 0060:[<c012d51d>] EFLAGS: 00010002 CPU: 0
EIP is at get_next_timer_interrupt+0x11f/0x234
EAX: 6b6b6b6b EBX: 3ffda6f6 ECX: c0432744 EDX: 6b6b6b6b
ESI: 00000027 EDI: c043260c EBP: c03b1ee8 ESP: c03b1eac
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c03b0000 task=c03813a0 task.ti=c03b0000)
Stack: fffda6f6 c0431e00 00000000 fffda700 00000001 000000f7 00000027 00fffda7
       c043260c c043280c c0432a0c c0432c0c c18090c0 0643e180 fffda6f6 c03b1f2c
       c013fb78 00000001 c03a3b08 00000046 c03b1f20 0644b3c1 00000022 0643e180
Call Trace:
 [<c013fb78>] ? tick_nohz_stop_sched_tick+0x130/0x337
 [<c0129a54>] ? irq_exit+0x55/0x6e
 [<c01146e7>] ? smp_apic_timer_interrupt+0x59/0x92
 [<c010582c>] ? apic_timer_interrupt+0x28/0x30
 [<c013007b>] ? get_signal_to_deliver+0x2d8/0x332
 [<c011879f>] ? native_safe_halt+0x5/0x7
 [<c0103965>] ? default_idle+0x4d/0x7f
 [<c0103918>] ? default_idle+0x0/0x7f
 [<c01037c4>] ? cpu_idle+0x6f/0x100
 [<c02e2e89>] ? rest_init+0x49/0x50
 =======================
Code: 85 e0 8b 4d e0 83 e1 3f 89 4d dc 89 ce 8b 04 f7 8b 10 0f 18 02 90 8d 0c f7 39 c8 0f 84 8d 00 00 00 8b 40 08 39 d8 0f 48 d8 89 d0 <8b> 12 0f 18 02 90 39 c8 75 ec c7 45 cc 01 00 00 00 8b 7d dc 85
EIP: [<c012d51d>] get_next_timer_interrupt+0x11f/0x234

$ addr2line -e vmlinux c012d51d
/usr/src/linux-2.6.25-rc2-git5kk1/kernel/timer.c:770

Crap, that is on the next list_for_each_entry in timer.c :(

I tried to make a similar test loop as you did a few lines above:

@@ -718,6 +767,14 @@
 
 		index = slot = timer_jiffies & TVN_MASK;
 		do {
+			struct list_head *tmp;
+
+			__list_for_each(tmp, varp->vec + slot) {
+				nte = (struct timer_list *) tmp;
+				if (nte->entry.next == (void *)0x6b6b6b6b)
+					ttrace_find_timer(nte);
+			}
+
 			list_for_each_entry(nte, varp->vec + slot, entry) {
 				found = 1;
 				if (time_before(nte->expires, expires))

I thought I got it on the next crash, but the system locked too fast, and the only thing I saw was:

TTRACE timer f7b52858 fn f8e7c608 addr c012d776
TTRACE fn l2cap_info_timeout
TTRACE addr mod_timer
BUG: unable to handle kernel paging request at 6b6b6b6b
IP:

$ addr2line -e vmlinux.kk1 c012d776
/usr/src/linux-2.6.25-rc2-git5kk1/kernel/timer.c:533

int mod_timer(struct timer_list *timer, unsigned long expires)
{
        BUG_ON(!timer->function);

        timer_stats_timer_set_start_info(timer);
        /*
         * This is a common optimization triggered by the
         * networking code - if the timer is re-modified
         * to be the same thing then just return:
         */
        if (timer->expires == expires && timer_pending(timer))
                return 1;

        return __mod_timer(timer, expires);
}     <<<< line 533 is here

Unfortunately, I never got anything more. After that, the only thing I got, even without my changes, was:

list_add corruption. prev->next should be next (c0432764), but was 6b6b6b6b. (prev=f6d6e908).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:33!
invalid opcode: 0000 [#1] SMP
Modules linked in: hidp rfcomm l2cap binfmt_misc loop nls_iso8859_1 nls_cp437 vfat fat fuse snd_pcm_oss snd_mixer_oss snd_intel8x0 sr_mod snd_ac97_codec ac97_bus snd_pcm parport_pc snd_timer parport snd soundcore i2c_i801 i2c_core hci_usb snd_page_alloc bluetooth rtc_cmos pcspkr iTCO_wdt iTCO_vendor_support tg3 processor button evdev dcdbas sg ide_disk piix ide_core ata_piix ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]

Pid: 8, comm: events/0 Not tainted (2.6.25-rc2-git5kk1 #3)
EIP: 0060:[<c01f5703>] EFLAGS: 00010086 CPU: 0
EIP is at __list_add+0x5a/0x5e
EAX: 00000061 EBX: c18093d0 ECX: 00000001 EDX: 00000096
ESI: c18093d0 EDI: c0431e00 EBP: f788defc ESP: f788dee8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process events/0 (pid: 8, ti=f788c000 task=f785cc60 task.ti=f788c000)
Stack: c035609c c0432764 6b6b6b6b f6d6e908 fffd277d f788df0c c012cba2 c18093d0
       c0431e00 f788df2c c012d2cc fffd2b64 00000000 00000286 c18093c0 c18093d0
       f7811690 f788df44 c0133ee6 ffffffff c18093c0 000003e8 f7811690 f788df5c
Call Trace:
 [<c012cba2>] ? internal_add_timer+0x53/0xb4
 [<c012d2cc>] ? __mod_timer+0xe9/0x102
 [<c0133ee6>] ? queue_delayed_work_on+0x84/0xb7
 [<c0133f71>] ? queue_delayed_work+0x40/0x48
 [<c0169025>] ? vmstat_update+0x0/0x28
 [<c0133f9b>] ? schedule_delayed_work+0x22/0x26
 [<c016904b>] ? vmstat_update+0x26/0x28
 [<c01337d4>] ? run_workqueue+0xc1/0x150
 [<c0134022>] ? worker_thread+0x83/0xd9
 [<c013676e>] ? autoremove_wake_function+0x0/0x38
 [<c0133f9f>] ? worker_thread+0x0/0xd9
 [<c01364c4>] ? kthread+0x37/0x59
 [<c013648d>] ? kthread+0x0/0x59
 [<c01059bb>] ? kernel_thread_helper+0x7/0x1c
 =======================
Code: 54 24 04 c7 04 24 4c 60 35 c0 e8 f1 fe f2 ff 0f 0b eb fe 89 44 24 0c 89 54 24 08 89 4c 24 04 c7 04 24 9c 60 35 c0 e8 d5 fe f2 ff <0f> 0b eb fe 55 89 e5 8b 0a e8 98 ff ff ff 5d c3 90 55 89 e5 53
EIP: [<c01f5703>] __list_add+0x5a/0x5e SS:ESP 0068:f788dee8
---[ end trace bd4e31c9ceb47c4f ]---

I hope the tiny bit of trace can trigger some idea. At least l2cap has something to do with bluetooth. l2cap_info_timeout is line 360 of net/bluetooth/l2cap.c, apparently only called from l2cap_conn_add, line 391: setup_timer(&conn->info_timer, l2cap_info_timeout, (unsigned long)conn);

After four hours and ten crashes today, it is the little I got. Kernel stuff is tough...
--
kk1

--NextPart_Webmail_9m3u9jl4l_25836_1203648041_0
Content-Type: application/octet-stream; name="mod_list"
Content-Transfer-Encoding: 7bit

Module                  Size  Used by
binfmt_misc            12552  1 
loop                   17284  0 
nls_iso8859_1           7936  1 
nls_cp437               9600  1 
vfat                   14208  1 
fat                    47136  1 vfat
ac97_bus                5632  0 
i2c_i801               12688  0 
hci_usb                16924  1 
parport_pc             27300  0 
pcspkr                  6528  0 
i2c_core               22036  1 i2c_i801
rtc_cmos               12192  0 
iTCO_wdt               13984  0 
parport                34028  1 parport_pc
iTCO_vendor_support     7172  1 iTCO_wdt
sr_mod                 18372  0 
bluetooth              51812  1 hci_usb
tg3                   110724  0 
button                 10128  0 
thermal                19228  0 
processor              36400  1 thermal
evdev                  12544  0 
dcdbas                 10656  0 
sg                     33844  0 
ide_disk               15616  0 
piix                   10376  0 [permanent]
ide_core               92448  2 ide_disk,piix
ata_piix               20484  0 
ahci                   26500  6 
libata                137744  2 ata_piix,ahci
sd_mod                 28824  7 
scsi_mod              127528  4 sr_mod,sg,libata,sd_mod
ext3                  120712  4 
jbd                    42132  1 ext3
uhci_hcd               24464  0 
ehci_hcd               33420  0 
usbcore               119920  4 hci_usb,uhci_hcd,ehci_hcd

--NextPart_Webmail_9m3u9jl4l_25836_1203648041_0
Content-Type: application/octet-stream; name="ps_list"
Content-Transfer-Encoding: 7bit

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  1.1  0.0   1668   556 ?        Ss   15:49   0:01 init [3]                                                                
root         2  0.0  0.0      0     0 ?        S<   15:49   0:00 [kthreadd]
root         3  0.0  0.0      0     0 ?        S<   15:49   0:00 [migration/0]
root         4  0.0  0.0      0     0 ?        S<   15:49   0:00 [ksoftirqd/0]
root         5  0.0  0.0      0     0 ?        S<   15:49   0:00 [migration/1]
root         6  0.0  0.0      0     0 ?        S<   15:49   0:00 [ksoftirqd/1]
root         7  0.0  0.0      0     0 ?        S<   15:49   0:00 [group_balance]
root         8  0.0  0.0      0     0 ?        S<   15:49   0:00 [events/0]
root         9  0.0  0.0      0     0 ?        S<   15:49   0:00 [events/1]
root        10  0.0  0.0      0     0 ?        S<   15:49   0:00 [khelper]
root        47  0.0  0.0      0     0 ?        S<   15:49   0:00 [kblockd/0]
root        48  0.0  0.0      0     0 ?        S<   15:49   0:00 [kblockd/1]
root        50  0.0  0.0      0     0 ?        S<   15:49   0:00 [kacpid]
root        51  0.0  0.0      0     0 ?        S<   15:49   0:00 [kacpi_notify]
root       128  0.0  0.0      0     0 ?        S<   15:49   0:00 [kseriod]
root       163  0.0  0.0      0     0 ?        S    15:49   0:00 [pdflush]
root       164  0.0  0.0      0     0 ?        S    15:49   0:00 [pdflush]
root       165  0.0  0.0      0     0 ?        S<   15:49   0:00 [kswapd0]
root       245  0.0  0.0      0     0 ?        S<   15:49   0:00 [aio/0]
root       246  0.0  0.0      0     0 ?        S<   15:49   0:00 [aio/1]
root       896  0.0  0.0      0     0 ?        S<   15:49   0:00 [kpsmoused]
root       917  0.0  0.0      0     0 ?        S<   15:49   0:00 [ksuspend_usbd]
root       918  0.0  0.0      0     0 ?        S<   15:49   0:00 [khubd]
root       944  0.0  0.0      0     0 ?        S<   15:49   0:00 [ata/0]
root       945  0.0  0.0      0     0 ?        S<   15:49   0:00 [ata/1]
root       946  0.0  0.0      0     0 ?        S<   15:49   0:00 [ata_aux]
root       950  0.0  0.0      0     0 ?        S<   15:49   0:00 [scsi_eh_0]
root       951  0.0  0.0      0     0 ?        S<   15:49   0:00 [scsi_eh_1]
root       952  0.0  0.0      0     0 ?        S<   15:49   0:00 [scsi_eh_2]
root       953  0.0  0.0      0     0 ?        S<   15:49   0:00 [scsi_eh_3]
root       957  0.0  0.0      0     0 ?        S<   15:49   0:00 [scsi_eh_4]
root       958  0.0  0.0      0     0 ?        S<   15:49   0:00 [scsi_eh_5]
root       974  0.0  0.0      0     0 ?        S<   15:49   0:00 [kjournald]
root      1060  0.7  0.1   2584  1488 ?        S<s  15:49   0:00 /sbin/udevd -d
root      2116  0.0  0.0      0     0 ?        S<   15:49   0:00 [btaddconn]
root      2124  0.0  0.0      0     0 ?        S<   15:49   0:00 [btdelconn]
root      2457  0.0  0.0      0     0 ?        S<   15:49   0:00 [kjournald]
root      2478  0.0  0.0      0     0 ?        S<   15:49   0:00 [kjournald]
root      2479  0.0  0.0      0     0 ?        S<   15:49   0:00 [kjournald]
root      2826  0.0  0.0   1724   616 ?        Ss   15:50   0:00 syslogd -m 0 -a /var/spool/postfix/dev/log
root      2838  0.0  0.0   1656   552 ?        Ss   15:50   0:00 /usr/sbin/acpid
root      2876  0.0  0.0   1668   408 ?        Ss   15:50   0:00 klogd -x
root      2890  0.0  0.0   3904  1024 ?        Ss   15:50   0:00 crond
root      2926  0.0  0.1   2744  1352 ?        Ss   15:50   0:00 login -- root     
root      2929  0.0  0.0   1652   460 tty2     Ss+  15:50   0:00 /sbin/mingetty tty2
root      2930  0.0  0.0   1652   460 tty3     Ss+  15:50   0:00 /sbin/mingetty tty3
root      2931  0.0  0.0   1652   460 tty4     Ss+  15:50   0:00 /sbin/mingetty tty4
root      2932  0.0  0.0   1652   460 tty5     Ss+  15:50   0:00 /sbin/mingetty tty5
root      2934  0.0  0.0   1652   460 tty6     Ss+  15:50   0:00 /sbin/mingetty tty6
root      2966  0.0  0.0      0     0 ?        S<   15:50   0:00 [kauditd]
root      2967  0.0  0.1   3924  1764 tty1     Ss   15:50   0:00 -bash
root      3201  0.0  0.0   2428   904 tty1     R+   15:52   0:00 ps aux

--NextPart_Webmail_9m3u9jl4l_25836_1203648041_0
Content-Type: application/octet-stream; name="serv_list"
Content-Transfer-Encoding: 7bit

acpid          	0:off	1:off	2:off	3:on	4:on	5:on	6:off
anacron        	0:off	1:off	2:on	3:on	4:on	5:on	6:off
crond          	0:off	1:off	2:on	3:on	4:on	5:on	6:off
kheader        	0:off	1:off	2:on	3:on	4:off	5:on	6:off
numlock        	0:off	1:off	2:off	3:on	4:on	5:on	6:off
syslog         	0:off	1:off	2:on	3:on	4:on	5:on	6:off

--NextPart_Webmail_9m3u9jl4l_25836_1203648041_0
Content-Type: application/octet-stream; name="kernlog.9"
Content-Transfer-Encoding: 7bit

hci_cmd_task: hci0 command tx timeout
list_add corruption. prev->next should be next (c043268c), but was 6b6b6b6b. (prev=f620b388).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:33!
invalid opcode: 0000 [#1] SMP 
Modules linked in: hidp rfcomm l2cap nfsd exportfs nfs lockd nfs_acl sunrpc autofs4 af_packet binfmt_misc loop nls_iso8859_1 nls_cp437 vfat fat fuse snd_pcm_oss snd_mixer_oss hci_usb snd_intel8x0 snd_ac97_codec i2c_i801 parport_pc ac97_bus sr_mod rtc_cmos parport iTCO_wdt snd_pcm i2c_core snd_timer iTCO_vendor_support snd pcspkr bluetooth soundcore snd_page_alloc thermal tg3 button processor evdev dcdbas sg ide_disk piix ide_core ata_piix ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]

Pid: 3518, comm: hald-addon-stor Not tainted (2.6.25-rc2-git5kk1 #1)
EIP: 0060:[<c01f5703>] EFLAGS: 00010086 CPU: 0
EIP is at __list_add+0x5a/0x5e
EAX: 00000061 EBX: f6d8fbf0 ECX: 00000001 EDX: 00000092
ESI: f6d8fbf0 EDI: c0431e00 EBP: f6d8fbb0 ESP: f6d8fb9c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process hald-addon-stor (pid: 3518, ti=f6d8e000 task=f7238630 task.ti=f6d8e000)
Stack: c035609c c043268c 6b6b6b6b f620b388 fffd8934 f6d8fbc0 c012cba2 f6d8fbf0 
       c0431e00 f6d8fbe0 c012d2cc fffd90f6 00000000 00000286 f6d8fbf0 fffd90f6 
       000007bc f6d8fc28 c02eebf5 f6d8fc50 f6c64400 00000000 c018da26 fffd90f6 
Call Trace:
 [<c012cba2>] ? internal_add_timer+0x53/0xb4
 [<c012d2cc>] ? __mod_timer+0xe9/0x102
 [<c02eebf5>] ? schedule_timeout+0x3f/0xa4
 [<c018da26>] ? __pollwait+0x67/0xcb
 [<c012cfda>] ? process_timeout+0x0/0xa
 [<c02eebf5>] ? schedule_timeout+0x3f/0xa4
 [<c018ce20>] ? do_sys_poll+0x25f/0x37e
 [<c018d9bf>] ? __pollwait+0x0/0xcb
 [<c011e330>] ? default_wake_function+0x0/0xd
 [<c011b816>] ? dequeue_task+0xd/0x18
 [<c02f0093>] ? __reacquire_kernel_lock+0x1f/0x40
 [<c02ee715>] ? schedule+0x591/0x6e6
 [<c02eec20>] ? schedule_timeout+0x6a/0xa4
 [<c01ed6d9>] ? kobject_put+0x14/0x16
 [<c017c90a>] ? check_bytes_and_report+0x21/0xb9
 [<c017c690>] ? slab_pad_check+0x56/0xc5
 [<c017cc34>] ? check_object+0xe3/0x1d2
 [<c017d5ea>] ? __slab_free+0x1b5/0x237
 [<c017c90a>] ? check_bytes_and_report+0x21/0xb9
 [<c017c690>] ? slab_pad_check+0x56/0xc5
 [<c017cc34>] ? check_object+0xe3/0x1d2
 [<c017d5ea>] ? __slab_free+0x1b5/0x237
 [<f8d86dca>] ? scsi_execute_req+0x7f/0xc8 [scsi_mod]
 [<f8d86dca>] ? scsi_execute_req+0x7f/0xc8 [scsi_mod]
 [<f8d86dca>] ? scsi_execute_req+0x7f/0xc8 [scsi_mod]
 [<f8d82911>] ? ioctl_internal_command+0x52/0x16d [scsi_mod]
 [<f8e9c1e8>] ? sr_lock_door+0x16/0x18 [sr_mod]
 [<c025bf4b>] ? cdrom_release+0xb3/0x209
 [<c0129690>] ? __do_softirq+0xda/0xf6
 [<c01ed6d9>] ? kobject_put+0x14/0x16
 [<c024fb00>] ? put_device+0xf/0x11
 [<f8d81100>] ? scsi_device_put+0x3e/0x42 [scsi_mod]
 [<c0192930>] ? iput+0x38/0x66
 [<c01a3f65>] ? bdput+0xb/0xd
 [<c01a40b1>] ? __blkdev_put+0x14a/0x14c
 [<c0195297>] ? mntput_no_expire+0x16/0x68
 [<c01822e8>] ? __fput+0x140/0x172
 [<c013b4f2>] ? getnstimeofday+0x34/0xdf
 [<c01f2891>] ? copy_to_user+0x33/0x42
 [<c018df16>] ? sys_poll+0x2d/0x77
 [<c0104d00>] ? sysenter_past_esp+0x6d/0xa5
 =======================
Code: 54 24 04 c7 04 24 4c 60 35 c0 e8 f1 fe f2 ff 0f 0b eb fe 89 44 24 0c 89 54 24 08 89 4c 24 04 c7 04 24 9c 60 35 c0 e8 d5 fe f2 ff <0f> 0b eb fe 55 89 e5 8b 0a e8 98 ff ff ff 5d c3 90 55 89 e5 53 
EIP: [<c01f5703>] __list_add+0x5a/0x5e SS:ESP 0068:f6d8fb9c
---[ end trace a3cd70cd749e26e8 ]---

--NextPart_Webmail_9m3u9jl4l_25836_1203648041_0--
