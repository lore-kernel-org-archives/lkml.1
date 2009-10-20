Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbZJTNoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbZJTNoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 09:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZJTNop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 09:44:45 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:37494 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZJTNoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 09:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R4NpZqnceY67Ebpv5DUjLsBKj6f9PhUJkndHUptIbVuuRXrHQ83xs+xbD19Qbq9SD8
         J5eIraP8cBEsxTKCS4u7skncpAzp0s01QRpzbWMvjMzit9d/xa+jruxic9FR8tA2byIn
         ky1PuhuO7Y15fpnLKgORIlIUUBO1lBm2C8J6w=
MIME-Version: 1.0
In-Reply-To: <1214411771.2793.22.camel@hel-stefan.lan>
References: <2ffbcf00806232001o4bd314f4kc590e43b4ab27076@mail.gmail.com>
	 <20080624102129.19d79eb0@lxorguk.ukuu.org.uk>
	 <2ffbcf00806241405w5b757b56p84cd560166ea8f90@mail.gmail.com>
	 <20080624222859.1e12dc2d@lxorguk.ukuu.org.uk>
	 <1214411771.2793.22.camel@hel-stefan.lan>
Date: Tue, 20 Oct 2009 09:44:48 -0400
Message-ID: <539da8a30910200644r681404b5vdde2a9c033fcdce5@mail.gmail.com>
Subject: Re: strange freeze with VIA C7 dedicated server and libc 2.6.1
From: Eric des Courtis <eric.des.courtis@gmail.com>
To: Stefan Hellermann <stefan@the2masters.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, william <william@waisse.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have the same problem but I do have a stack trace. I did run crashme
with +2000 666 100 1:00:00 but it seems to work fine.  Random
application will crash in the sys_open() call. If I am in X the system
sometimes freezes completely.


Anyway this is the stack trace:

[ 2074.794366] invalid opcode: 0000 [#1] SMP
[ 2074.804264] last sysfs file:
/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/resource
[ 2074.804264] Dumping ftrace buffer:
[ 2074.804264]    (ftrace buffer empty)
[ 2074.804264] Modules linked in: via drm lp parport viafb
i2c_algo_bit snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm_oss
snd_mixer_oss snd_pcm snd_page_alloc snd_mpu401_uart snd_seq_dummy
snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
snd_timer snd_seq_device pcspkr snd lirc_imon i2c_viapro soundcore
lirc_dev via_agp agpgart shpchp usbhid via_rhine 3c59x mii vesafb
fbcon tileblit font bitblit softcursor
[ 2074.804264]
[ 2074.804264] Pid: 2635, comm: lcdproc Not tainted (2.6.28-15-server
#52-Ubuntu) ID-PCM7E PC2500
[ 2074.804264] EIP: 0060:[<c01d1041>] EFLAGS: 00010202 CPU: 0
[ 2074.804264] EIP is at path_lookup_open+0x31/0xa0
[ 2074.804264] EAX: 00000001 EBX: 00000101 ECX: 00000000 EDX: f5dca5b0
[ 2074.804264] ESI: ffffffe9 EDI: f5c8bf04 EBP: f5c8bec0 ESP: f5c8bea8
[ 2074.804264]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 2074.804264] Process lcdproc (pid: 2635, ti=f5c8a000 task=f5dca5b0
task.ti=f5c8a000)
[ 2074.804264] Stack:
[ 2074.804264]  00000001 e84f2000 ffffff9c ffffff9c 00000001 f5c8bf04
f5c8bf70 c01d1d23
[ 2074.804264]  f5c8bf04 00000001 00000000 f5c8bf04 f64d3000 00000000
e84f2000 00000000
[ 2074.804264]  00000024 ffffffff 00000000 00000000 00000000 00000000
00000000 f5dca5b0
[ 2074.804264] Call Trace:
[ 2074.804264]  [<c01d1d23>] ? do_filp_open+0xb3/0x7c0
[ 2074.804264]  [<c01569e0>] ? autoremove_wake_function+0x0/0x50
[ 2074.804264]  [<c01daed0>] ? alloc_fd+0xe0/0x100
[ 2074.804264]  [<c01c47bf>] ? do_sys_open+0x5f/0x120
[ 2074.804264]  [<c01c48e9>] ? sys_open+0x29/0x40
[ 2074.804264]  [<c0109eef>] ? sysenter_do_call+0x12/0x2f
[ 2074.804264] Code: 89 5d f4 89 cb 89 75 f8 be e9 ff ff ff 89 7d fc
8b 7d 08 89 45 f0 89 55 ec e8 3c 68 ff ff 85 c0 74 33 89 47 4c 8b 45
0c 80 cf 01 <c7> 47 48 00 00 00 00 89 d9 89 47 44 8b 55 ec 8b 45 f0 89
3c 24
[ 2074.804264] EIP: [<c01d1041>] path_lookup_open+0x31/0xa0 SS:ESP 0068:f5c8bea8
[ 2075.261958] ---[ end trace 59aabadb5240aad2 ]---

And much later (could be unrelated):

[ 2830.975240] lcdproc[9430]: segfault at 1bfef35 ip b7f9e05a sp
bfef2175 error 4 in libc-2.9.so[b7f67000+15c000]
[ 2830.984939] klogd[2111]: segfault at 4 ip b7e1e05a sp bfb6d2b1
error 4 in libc-2.9.so[b7de7000+15c000]


Cheers,

Eric des Courtis

On Wed, Jun 25, 2008 at 12:36 PM, Stefan Hellermann
<stefan@the2masters.de> wrote:
> Am Dienstag, den 24.06.2008, 22:28 +0100 schrieb Alan Cox:
>> > * the watchdog says nothing in the logs, but is able to reboot the box.
>> >
>> >  Thank you very much for your answer Alan, I were hesitating on
>> > posting a report with no logs, no clues . . . your answer gives me a
>> > little hope ;)
>>
>> Two random thoughts from your last comment
>>
>> - If you do
>>
>> echo "2" >/proc/sys/vm/overcommit_memory
>> echo "80" >/proc/sys/vm/overcommit_ratio
>>
>> do you instead get out of memory kills (which would imply bad memory
>> leaks perhaps triggered by glibc ?)
>>
>> - Does your system pass 'crashme' testing (run as a non root user). If
>> not then that might give an eventual identification of a crashme run
>> which takes out the box. We've found kernel bugs, CPU bugs and
>> combinations of the two before now that way.
>
> Hi!
>
> I've got the same problem with a VIA Epia SN-1800, Gentoo and
> glibc-2.6.1. First I had crashes every day, but these came from
> madwifi-ng. Now with vanilla-2.6.25.6 and no modules it's crashing about
> every 3 weeks with no log I can provide. I have a serial console
> connected to it, but I have no other device running 24h to collect the
> crash.
> I tried glibc-2.7, but with this powerdns-resolver isn't working any
> more, and I don't think the problems are gone (only one crash so far).
> It's not easy to downgrade glibc on gentoo, but I could try
> vanilla-glibc-2.5 if this would help.
> I have no big crontab, only a script with rotates logs and makewhatis.
>
> Where can I find 'crashme'? Is it a tool I can download?
>
> It's a small home-server carrying my mails and webspace, so I can do a
> bit testing, but I don't like large downtime :-)
>
> --
> Kind Regards
> Stefan Hellermann
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
