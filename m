Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbZGSSK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbZGSSK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 14:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZGSSK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 14:10:27 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33172 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbZGSSK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 14:10:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QqTPb3Gm+/cUYEOkBUgJfUUyBTJf55eyVSZ0j/1PRtu1MHU4z/u8D1PqzVM6m8Gv8D
         cOFmbybkWzWMu0iFJz2quReUO6AdqMCWKdGmRHk9HDABde7q7GI72W9ENRqn704kq3L9
         4UAzg0u21YSlCkz4jV1QgyrMykLPp3orJjAUk=
MIME-Version: 1.0
In-Reply-To: <4A635618.3070507@tuffmail.co.uk>
References: <4A61FE7D.9080409@tuffmail.co.uk>
	 <8db1092f0907181155h3d603a17q11815b9f174ac333@mail.gmail.com>
	 <4A623490.50305@tuffmail.co.uk>
	 <8db1092f0907190028o334371d7g798c1e8cb9a5744b@mail.gmail.com>
	 <4A635618.3070507@tuffmail.co.uk>
Date: Sun, 19 Jul 2009 20:10:23 +0200
Message-ID: <8db1092f0907191110p2d3c2c45je61bda6365ed1468@mail.gmail.com>
Subject: Re: [RFT] hp-wmi: improved rfkill support for wifi
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>, Frans Pop <elendil@planet.nl>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/19 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
> Maciej Rutecki wrote:
>> 2009/7/18 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
>> [...]
>>
>>> I'll try extending this to bluetooth and wwan as Matthew suggested.  If
>>> you have time to run "acpidump" and send me the output, that would help
>>>
>>
>> acpidump in attachment.
>>
>
> Heh, I got lucky borrowing the G7000.  Your acpidump is much less human
> readable, and Matthews lot is the same.  I gave up looking for the right
> bits.
>
> So I had to guess :-).  The interface seems nicely structured, so I
> generalized my changes and applied them to the other rfkill devices.
> Patch follows - apply on top of the first one.
>
> Now if you disable bluetooth in the Windows driver and reboot to linux,
> you should find it stays disabled.
>

2.6.31-rc3+ patches:
http://lkml.org/lkml/2009/7/18/131
http://lkml.org/lkml/2009/7/10/339
http://lkml.org/lkml/2009/7/19/57

Disable bluetooth and wireless in Windows XP
When modprobe hp-wmi during boot:
[    9.648259] input: HP WMI hotkeys as /class/input/input8
[    9.664468] Platform driver 'hp-wmi' needs updating - please use dev_pm_ops
[    9.707352] ------------[ cut here ]------------
[    9.708007] Kernel BUG at f80763b7 [verbose debug info unavailable]
[    9.708007] invalid opcode: 0000 [#1] SMP
[    9.708007] last sysfs file: /sys/class/input/input8/modalias
[    9.708007] Modules linked in: hp_wmi(+) fuse sbp2 loop arc4 ecb
iwl3945 iwlcore snd_hda_codec_si3054 firmware_class pcmcia
snd_hda_codec_analog mac80211 snd_hda_intel snd_hda_codec led_class
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device uhci_hcd cfg80211 ehci_hcd yenta_socket snd ohci1394
b44 rsrc_nonstatic rfkill usbcore intel_agp psmouse ieee1394 ssb
rtc_cmos pcmcia_core video agpgart mii soundcore serio_raw backlight
rtc_core output rtc_lib snd_page_alloc ac evdev fan button battery sg
[    9.708007]
[    9.708007] Pid: 1544, comm: modprobe Not tainted (2.6.31-rc3 #1)
HP Compaq nx6310 (EY501ES#AKD)
[    9.708007] EIP: 0060:[<f80763b7>] EFLAGS: 00010202 CPU: 0
[    9.708007] EIP is at rfkill_init_sw_state+0x57/0x70 [rfkill]
[    9.708007] EAX: f65ad800 EBX: f65ad800 ECX: 00000008 EDX: 00000001
[    9.708007] ESI: 00000001 EDI: 0c0c0c2b EBP: f65b3de0 ESP: f65b3dd4
[    9.708007]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    9.708007] Process modprobe (pid: 1544, ti=f65b2000 task=f7155d00
task.ti=f65b2000)
[    9.708007] Stack:
[    9.708007]  00000000 f6b94308 0c0c0c2b f65b3e00 f8efa18f f8ef68d8
00000001 f6b94300
[    9.708007] <0> ffffffed f6b94308 f8ef74dc f65b3e08 c02f38f1
f65b3e30 c02f28ad 00000000
[    9.708007] <0> 00000000 f6b94300 f6b94308 f65b3e30 f8ef74dc
f6b94308 f6b94308 f65b3e40
[    9.708007] Call Trace:
[    9.708007]  [<f8efa18f>] ? hp_wmi_bios_setup+0x18f/0x211 [hp_wmi]
[    9.708007]  [<c02f38f1>] ? platform_drv_probe+0x11/0x20
[    9.708007]  [<c02f28ad>] ? driver_probe_device+0x6d/0x180
[    9.708007]  [<c02f2aa9>] ? __device_attach+0x49/0x60
[    9.708007]  [<c02f1eb3>] ? bus_for_each_drv+0x53/0x80
[    9.708007]  [<c02f2b6b>] ? device_attach+0x6b/0x70
[    9.708007]  [<c02f2a60>] ? __device_attach+0x0/0x60
[    9.708007]  [<c02f1cb7>] ? bus_attach_device+0x47/0x70
[    9.708007]  [<c02f04ce>] ? device_add+0x4fe/0x640
[    9.708007]  [<c026bad2>] ? kobject_set_name_vargs+0x62/0x70
[    9.708007]  [<c02f4265>] ? platform_device_add+0x145/0x190
[    9.708007]  [<c02f43f4>] ? platform_device_alloc+0x54/0x70
[    9.708007]  [<f8efa211>] ? hp_wmi_init+0x0/0x1aa [hp_wmi]
[    9.708007]  [<f8efa3a7>] ? hp_wmi_init+0x196/0x1aa [hp_wmi]
[    9.708007]  [<c010112f>] ? do_one_initcall+0x2f/0x150
[    9.708007]  [<c017d6d7>] ? tracepoint_module_notify+0x37/0x40
[    9.708007]  [<c0151b0d>] ? notifier_call_chain+0x2d/0x60
[    9.708007]  [<c0151f12>] ? __blocking_notifier_call_chain+0x52/0x60
[    9.708007]  [<c016421f>] ? sys_init_module+0xaf/0x1f0
[    9.708007]  [<c0102ec4>] ? sysenter_do_call+0x12/0x22
[    9.708007] Code: 02 83 c1 02 84 d2 75 1c f7 d1 21 c1 89 4b 0c c6
43 15 01 89 fa 89 d8 e8 98 2f 35 c8 5b 5e 5f c9 c3 8d 76 00 09 c1 89
4b 0c eb e4 <0f> 0b eb fe 90 8d 74 26 00 0f 0b eb fe 8d b6 00 00 00 00
8d bf
[    9.708007] EIP: [<f80763b7>] rfkill_init_sw_state+0x57/0x70
[rfkill] SS:ESP 0068:f65b3dd4
[   10.413477] ---[ end trace 15451c5b7e8810a1 ]---

Try enable bluetooth and wireless:
root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill  list
0: phy0: Wireless LAN
        Soft blocked: yes
        Hard blocked: yes
1: hp-wifi: Wireless LAN
        Soft blocked: yes
        Hard blocked: no
root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill  unblock 0
root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill  list
0: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: yes
1: hp-wifi: Wireless LAN
        Soft blocked: yes
        Hard blocked: no
root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill  unblock 1
root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill  list
0: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
1: hp-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
	
	
root@gumis:/sys/class/rfkill# ls
rfkill0  rfkill1
root@gumis:/sys/class/rfkill# cat rfkill0/state
1
root@gumis:/sys/class/rfkill# cat rfkill1/state
1

Bluetooth still doesn't work. I can enable wifi.

LED from wifi/bluetooth button sometimes flashing(!)

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
