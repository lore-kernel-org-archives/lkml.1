Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZKRJDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZKRJDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZKRJDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:03:47 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:54490 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbZKRJDn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:03:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H0RP40HHqiDoRjzyzeuuRha+TML5+n9oYUYcfUOhqRI02gAlYtzRKXNF9g4mzqZG2m
         bIun04165WWczV1Ck0oZc8OU8tSX3euIHt2S7/0Yyt7qpm/jHZzP5NxOoyhU9SNwvuJv
         FEihUnFfngc0K5QNT6wlcphtLN7myZFiggq0U=
MIME-Version: 1.0
In-Reply-To: <4B038BB7.2050902@qualcomm.com>
References: <d45a3acc0911171730kc3a03d5iacec6d9ef4b1874c@mail.gmail.com>
	 <4B035081.8040900@qualcomm.com>
	 <d45a3acc0911171814i310bbd16t8ff3fba2410e9375@mail.gmail.com>
	 <4B038BB7.2050902@qualcomm.com>
Date: Wed, 18 Nov 2009 20:03:49 +1100
Message-ID: <d45a3acc0911180103q69499cc6yf610117ea44186d7@mail.gmail.com>
Subject: Re: [PATCH] Documentation, clarify tuntap IPX example.
From: andrew hendry <andrew.hendry@gmail.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Max,

Thanks. TUNSETLINK looks like exactly what I need.
I'll have to have a closer look at kernel x.25 next, i don't think it
likes the tunx25 going away with routes still too it.

deb32:~# cat /proc/net/x25/route
Address          Digits  Device
000000000000000  0       @���
                              �@�

[  662.425648] BUG: unable to handle kernel NULL pointer dereference at 00000017
[  662.426291] IP: [<c10b5908>] dup_fd+0x21f/0x2fa
[  662.427849] *pde = 00000000
[  662.428028] Oops: 0002 [#1] SMP
[  662.428028] last sysfs file: /sys/class/net/lo/operstate
[  662.428028] Modules linked in: x25 tun ipv6 loop ac button
parport_pc parport snd_pcm snd_timer serio_raw psmouse snd soundcore
snd_page_alloc pcspkr i2c_piix4 i2c_core evdev ext3 jbd mbcache
ide_cd_mod cdrom ide_gd_mod ata_generic ata_piix libata scsi_mod
ide_pci_generic piix floppy pcnet32 mii ide_core thermal fan
thermal_sys [last unloaded: tun]
[  662.428028]
[  662.428028] Pid: 12252, comm: net.agent Not tainted (2.6.31.6 #1) VirtualBox
[  662.428028] EIP: 0060:[<c10b5908>] EFLAGS: 00010286 CPU: 0
[  662.428028] EIP is at dup_fd+0x21f/0x2fa
[  662.428028] EAX: 00000017 EBX: ce5262a0 ECX: 00000220 EDX: ffffffff
[  662.428028] ESI: 00000088 EDI: ce41e400 EBP: 00000100 ESP: c2849eec
[  662.428028]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
[  662.428028] Process net.agent (pid: 12252, ti=c2848000
task=ce9d51c0 task.ti=c2848000)
[  662.428028] Stack:
[  662.428028]  00000202 00000020 00000008 cf466cc0 cf466cc4 cf4667c0
ce41e400 00000078
[  662.428028] <0> ce5262c0 cf466d00 cf4667c8 ce02bc00 ce18db60
00000000 00000000 ce9d51c0
[  662.428028] <0> c102d03b 080a8120 cf649668 c2849fb4 bfe05a6c
01200011 ce18dca4 fffffff4
[  662.428028] Call Trace:
[  662.428028]  [<c102d03b>] ? copy_process+0x469/0xf96
[  662.428028]  [<c102dc7d>] ? do_fork+0x115/0x282
[  662.428028]  [<c10a4965>] ? vfs_llseek+0x30/0x34
[  662.428028]  [<c1001d8e>] ? sys_clone+0x21/0x27
[  662.428028]  [<c10030c9>] ? syscall_call+0x7/0xb
[  662.428028] Code: 4c 24 08 8b 70 08 f3 a5 8b 4c 24 04 83 e1 03 74
02 f3 a4 31 c9 31 f6 89 6c 24 1c eb 29 8b 7c 24 18 8b 14 0f 85 d2 74
09 8d 42 18 <3e> ff 42 18 eb 06 8b 43 0c 0f b3 30 8b 44 24 2c 46 89 14
08 83
[  662.428028] EIP: [<c10b5908>] dup_fd+0x21f/0x2fa SS:ESP 0069:c2849eec
[  662.428028] CR2: 0000000000000017
[  662.452941] ---[ end trace aab1610cb3ca8b89 ]---

Message from syslogd@deb32 at Nov 19 06:58:56 ...
 kernel:[  904.324109] unregister_netdevice: waiting for xotdtun to
become free. Usage count = -3


Andrew

On Wed, Nov 18, 2009 at 4:52 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
> andrew hendry wrote:
>> Hi Max,
>>
>> I started looking through the documentation because im looking to use
>> tun for X.25 over TCP. The IPX example sounded similar but i couldn't
>> get it to work as I was expecting. Looking for a hint in the right
>> direction.
> Ah, X25 is different.
>
>> There is an old non-mainline patch called x25tap (clone of obsolete
>> ethertap). I'm hoping to replace x25tap with tun.
>>
>> The old x25tap creates a device like:
>> x25tap0   Link encap:generic X.25  HWaddr
>>           UP BROADCAST RUNNING NOARP MULTICAST  MTU:1024  Metric:1
>>           RX packets:3040785 errors:0 dropped:0 overruns:0 frame:0
>>           TX packets:2895530 errors:0 dropped:0 overruns:0 carrier:0
>>           collisions:0 txqueuelen:10
>>           RX bytes:138787339 (132.3 Mb)  TX bytes:91395983 (87.1 Mb)
>> When the x25tap is loaded it has dev->type = ARPHRD_X25, after which
>> x.25 routing and AF_X25 sockets can be created.  Along with an XoT
>> userspace program which handles some basic headers and TCP port 1998
>> it works well.
>>
>> If using tun, how does something get registered to handle protocol AF_X25?
>>
>
> I've never tried this personally so ... :). But I just glanced over net/ax25
> and drivers/wan/ax25 and it looks TUNSETLINK might work for you.
> In other words you want to allocate TUN device (not TAP) and then call
> TUNSETLINK with ARPHRD_X25. Seems like you'll get exactly what you need.
>
> Max
>
>
>> Regards,
>> Andrew.
>>
>> On Wed, Nov 18, 2009 at 12:40 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>>> On 11/17/2009 05:30 PM, andrew hendry wrote:
>>>> Can the TUNSETIFF ioctl change a tap's protocol to IPX as the
>>>> documentation suggests?
>>>> I think tun.c would need IFF_IPX_TAP added for it to work as described?
>>>> Otherwise tap can only be ptp or ethernet, and there is no way to
>>>> route or use AF_IPX.
>>> TAP is an Ethernet device. No special handling is required for IPX or for
>>> that matter any other protocol. Example seems fine too.
>>>
>>> Max
>>>
>>>> Signed-off-by: Andrew Hendry<andrew.hendry@gmail.com>
>>>>
>>>> --- a/Documentation/networking/tuntap.txt       2009-11-11
>>>> 14:03:22.676167648 +1100
>>>> +++ b/Documentation/networking/tuntap.txt       2009-11-18
>>>> 11:34:18.106647029 +1100
>>>> @@ -127,12 +127,14 @@ Ethernet device, which instead of receiv
>>>>  media, receives them from user space program and instead of sending
>>>>  packets via physical media sends them to the user space program.
>>>>
>>>> -Let's say that you configured IPX on the tap0, then whenever
>>>> -the kernel sends an IPX packet to tap0, it is passed to the application
>>>> -(VTun for example). The application encrypts, compresses and sends it to
>>>> -the other side over TCP or UDP. The application on the other side
>>>> decompresses
>>>> -and decrypts the data received and writes the packet to the TAP device,
>>>> -the kernel handles the packet like it came from real physical device.
>>>> +Let's say for the purpose of example, IPX support was added to tuntap.
>>>> +Then whenever the kernel routes an IPX packet to tap0, it is passed to
>>>> the
>>>> +application reading the file descriptor from /dev/net/tun (VTun for
>>>> example).
>>>> +The application encrypts, compresses and sends it to the other side over
>>>> TCP
>>>> +or UDP. The application on the other side decompresses and decrypts the
>>>> data
>>>> +received and writes the packet to the TAP device, the remote kernel
>>>> handles
>>>> +the packet like it came from real physical device. The IPX applications
>>>> are
>>>> +able to communicate as if there was a real IPX network.
>>>>
>>>>  4. What is the difference between TUN driver and TAP driver?
>>>>  TUN works with IP frames. TAP works with Ethernet frames.
>>>
>
>
