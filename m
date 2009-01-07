Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZAGINl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZAGINl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 03:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbZAGINd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 03:13:33 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:35596 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZAGINc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 03:13:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WgAe0KDCXLF99GFwGk3Jc6qlDvcqu9iibCAnB8+4S54GmguJycOPBSSKlC6jER3iL5
         j2Okxb0ci8l4/VGyP6y5vN8XBnKx6Uh5wX8S3HBbo2erQuoNJZc1O2PITUkTu5XtPah4
         owWxeZMSAPGeWl5blDvJJEZTxTYn2uAIaqKD4=
Message-ID: <49646428.103@gmail.com>
Date: Wed, 07 Jan 2009 00:13:28 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [ 286.547348] BUG: unable to handle kernel paging request at
 6b6b6b6b
References: <4963F368.7080909@gmail.com> <84144f020901062248j5d406656wb21130d914c7749d@mail.gmail.com>
In-Reply-To: <84144f020901062248j5d406656wb21130d914c7749d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Justin,
>
> On Wed, Jan 7, 2009 at 2:12 AM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
>   
>> With pulling git today I'm unable to shut the machine down completely.
>> (the system just sits there with the message on the screen);
>>
>> * will now halt
>> [  286.547348] BUG: unable to handle kernel paging request at 6b6b6b6b
>>     
>
> That looks like use-after-free in __stop_machine() so lets cc Rusty.
> If you want, you can convert the oops location into human-readable
> form. Just search for "GDB" in Documentation/BUG-HUNTING for
> instructions how to do that. And don't forget to send your .config.
>
>   
>> [  286.548940] IP: [<c0150ca4>] __stop_machine+0x88/0xe3
>> [  286.550598] Oops: 0002 [#1] SMP
>> [  286.552206] last sysfs file: /sys/block/sda/removeable
>> [  286.553844] Modules linked in: hidp radeon drm agpgart btusb rfcomm bnep
>> sco l2cap bluetooth fan battery container ipt_LOG xt_limit xt_tcpudp
>> xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
>> nf_conntrack_ftp ipmi_watchdog ipmi_msghandler uvcvideo isight_firmware
>> uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
>> nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp
>> eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand
>> cpufreq_conservative appletouch snd_had_codec_idt ohci1394 ehci_hcd
>> snd_hda_intel snd_hda_codec thermal ath9k uhci_hcd ieee1394 joydev pata_acpi
>> snd_hwdep snd_pcm snd_page_alloc video ac button processor applesmc evdev
>> [  286.560580]
>> [  286.560580] Pid: 3273, comm: halt Not tainted (2.6.28-06127-g238c6d5 #1)
>> MacBookPro2,2
>> [  286.560580] EIP: 0060:[<c0150ca4>] EFLAGS: 00010293 CPU: 0
>> [  286.560580] EIP: is at __stop_machine+0x88/0xe3
>> [  286.560580] EAX: 6b6b6b6b EBX: 00000000 ECX: 6b6b6b6b EDX: 00000000
>> [  286.560580] ESI: c054abe0 EDI: c03d03a4 EBP: f1a29e54 ESP: f1a29e44
>> [  286.560580]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> [  286.560580] Process halt (pid: 3273, ti=f1a28000 task=f4530f30
>> task.ti=f1a28000)
>> [  286.560580] Stack:
>> [  286.560580] f1a29e60 c054abe0 00000001 00000010 f1a29e7c c03d04e4
>> ffffffea 00000010
>> [  286.560580] 00000001 00000003 00000022 00000001 4321fedc c054abe0
>> f1a29e94 c012a57e
>> [  286.560580] 00000000 ffffffff 4321fedc 28121969 f1a29e9c c01360c0
>> f1a29fb0 c0136301
>> [  286.560580] Call Trace:
>> [  286.560580]  [<c03d04e4>] ? _cpu_down+0x10f/0x234
>> [  286.560580]  [<c012a57e>] ? disable_nonboot_cpus+0x58/0xdc
>> [  286.560580]  [<c01360c0>] ? kernel_poweroff+0x22/0x39
>> [  286.560580]  [<c0136301>] ? sys_reboot+0xde/0x14c
>> [  286.560580]  [<c01331b2>] ? complete_signal+0x179/0x191
>> [  286.560580]  [<c0133396>] ? send_signal+0x1cc/0x1e1
>> [  286.560580]  [<c03de418>] ? _spin_unlock_irqrestore+0x2d/0x3c
>> [  286.560580]  [<c0133b65>] ? group_send_signal_info+0x58/0x61
>> [  286.560580]  [<c0133b9e>] ? kill_pid_info+0x30/0x3a
>> [  286.560580]  [<c0133d49>] ? sys_kill+0x75/0x13a
>> [  286.560580]  [<c01a06cb>] ? mntput_no_expire+ox1f/0x101
>> [  286.560580]  [<c019b3b3>] ? dput+0x1e/0x105
>> [  286.560580]  [<c018ef87>] ?  __fput+0x150/0x158
>> [  286.560580]  [<c0157abf>] ? audit_syscall_entry+0x137/0x159
>> [  286.560580]  [<c010329f>] ? sysenter_do_call+0x12/0x34
>> [  286.560580] Code: c7 05 10 06 62 c0 00 00 00 00 a3 f4 05 62 c0 c7 05 ec
>> 05 62 c0 01 00 00 00 83 cb ff eb 2d a1 1c 06 62 c0 f7 d0 8b 0c 98 8d 41 04
>> <c7> 01 00 00 00 00 89 41 04 89 41 08 c7 41 0c ff 0c 15 c0 89 d8
>> [  286.560580] EIP: [<c0150ca4>] __stop_machine+0x88/0xe3 SS:ESP
>> 0068:f1a29e44
>> [  286.639215] ---[ end trace 5b080c1ab14203ae ] ---
>> Segmentation fault
>>
>> after this message appears, if I hold down the start button
>> the system shuts off after a few seconds.
>> (BTW hopefully the number are correct,
>> manually writing this down, is a bit of a pain);
>>
>> regards;
>>
>> Justin P. Mattock
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>     
>
>   
Thats nice, thanks for the info.
I like the idea of using gcc to disassemble
this text.
Since not knowing what I'm doing,
I'll have to do my homework on this.
(really curious to see what this does);

regards;

Justin P. Mattock



