Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbZAGIbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbZAGIbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 03:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZAGIbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 03:31:00 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:53187 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZAGIa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 03:30:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=YzTLEdvCQACN8j4ppblntjHT9izlqajdK/uL8e3BOXltyRmqkiQhiDVB0Gh1UwiSSg
         oV7XkC8Fadj96mNShr3yBV5rtvZHC8UhPjdHy+msY/I2HckU+TXmd30oY1I+PUp3cu0c
         D/bD3qjTNBd1dcIN1D9FmWTIySY6BFrKeB4mM=
Message-ID: <84144f020901070030k6fb888f6n84255078e4885d28@mail.gmail.com>
Date: Wed, 7 Jan 2009 10:30:56 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [ 286.547348] BUG: unable to handle kernel paging request at 6b6b6b6b
Cc: linux-kernel@vger.kernel.org, "Rusty Russell" <rusty@rustcorp.com.au>,
       heiko.carstens@de.ibm.com
In-Reply-To: <84144f020901062248j5d406656wb21130d914c7749d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4963F368.7080909@gmail.com>
	 <84144f020901062248j5d406656wb21130d914c7749d@mail.gmail.com>
X-Google-Sender-Auth: df7561c80e654219
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 8:48 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Wed, Jan 7, 2009 at 2:12 AM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
>> With pulling git today I'm unable to shut the machine down completely.
>> (the system just sits there with the message on the screen);
>>
>> * will now halt
>> [  286.547348] BUG: unable to handle kernel paging request at 6b6b6b6b
>
> That looks like use-after-free in __stop_machine() so lets cc Rusty.
> If you want, you can convert the oops location into human-readable
> form. Just search for "GDB" in Documentation/BUG-HUNTING for
> instructions how to do that. And don't forget to send your .config.
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

scripts/decodecode gives us:

   0:   c7 05 10 06 62 c0 00    movl   $0x0,0xc0620610
   7:   00 00 00
   a:   a3 f4 05 62 c0          mov    %eax,0xc06205f4
   f:   c7 05 ec 05 62 c0 01    movl   $0x1,0xc06205ec
  16:   00 00 00
  19:   83 cb ff                or     $0xffffffff,%ebx
  1c:   eb 2d                   jmp    0x4b
  1e:   a1 1c 06 62 c0          mov    0xc062061c,%eax
  23:   f7 d0                   not    %eax
  25:   8b 0c 98                mov    (%eax,%ebx,4),%ecx
  28:   8d 41 04                lea    0x4(%ecx),%eax
  2b:   c7 01 00 00 00 00       movl   $0x0,(%ecx)
  31:   89 41 04                mov    %eax,0x4(%ecx)
  34:   89 41 08                mov    %eax,0x8(%ecx)
  37:   c7 41 0c ff 0c 15 c0    movl   $0xc0150cff,0xc(%ecx)
  3e:   89 d8                   mov    %ebx,%eax
   0:   c7 01 00 00 00 00       movl   $0x0,(%ecx)      <-- oops
   6:   89 41 04                mov    %eax,0x4(%ecx)
   9:   89 41 08                mov    %eax,0x8(%ecx)
   c:   c7 41 0c ff 0c 15 c0    movl   $0xc0150cff,0xc(%ecx)
  13:   89 d8                   mov    %ebx,%eax

objdump -S -d kernel/stop_machine.o looks like this on my machine:

        /* Schedule the stop_cpu work on all cpus: hold this CPU so one
         * doesn't hit this CPU until we're ready. */
        get_cpu();
        for_each_online_cpu(i) {
                sm_work = percpu_ptr(stop_machine_work, i);
                INIT_WORK(sm_work, stop_cpu);
  8b:   c7 01 00 00 00 00       movl   $0x0,(%ecx)
  91:   c7 41 0c e0 00 00 00    movl   $0xe0,0xc(%ecx)

where

#define INIT_WORK(_work, _func)                                         \
        do {                                                            \
                (_work)->data = (atomic_long_t) WORK_DATA_INIT();       \

and offset of ->data is zero and WORK_DATA_INIT() expands to
ATOMIC_LONG_INIT(0) so looks to me like 'sm_work' is used after it has
been free'd. Perhaps stop_machine_destroy() was called before or in
parallel to __stop_machine()? So lets cc Heiko as well.

                        Pekka
