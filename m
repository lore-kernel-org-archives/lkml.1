Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbZIOKUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbZIOKUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZIOKUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:20:19 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64800 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbZIOKUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Tn15B9cFC/Qx5JMEYK3LbHSBJCkwntVJA7frVhEp8evZOhrZ9F9FL7tOattG6nKG1r
         wa2YLDhSn6rvNugM6z2Ng9HsH9n6EzLZsqCU+5rckeruFNNeypqn1TrJIGThYCacXnTc
         JYeDi00XMJAGDAqkGpeRh1Qufm2pIzolRVMUg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.00.0909142147220.30373@chino.kir.corp.google.com>
References: <200909100601.n8A61Eju002109@imap1.linux-foundation.org>
	 <38c3c4860909132302j3fd7afe1p984b91d74eb1d782@mail.gmail.com>
	 <alpine.DEB.1.00.0909142147220.30373@chino.kir.corp.google.com>
Date: Tue, 15 Sep 2009 15:50:19 +0530
Message-ID: <38c3c4860909150320qc4a203eu7552294ef0aafd2c@mail.gmail.com>
Subject: Re: mmotm 2009-09-09-22-56 uploaded
From: Suresh Jayaram <sureshjayaram@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry, resending as the previous email got rejected as I accidentally
enabled html formatting while trying to attach inline.. gmail sucks
for sending patches/emails but helps in reading/filtering huge volume
of emails..)

On Tue, Sep 15, 2009 at 10:29 AM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 14 Sep 2009, Suresh Jayaram wrote:
>
>> Hi Andrew,
>>
>> On Thu, Sep 10, 2009 at 11:31 AM, <akpm@linux-foundation.org> wrote:
>> >
>> > The mm-of-the-moment snapshot 2009-09-09-22-56 has been uploaded to
>> >
>> >   http://userweb.kernel.org/~akpm/mmotm/
>> >
>> > and will soon be available at
>> >
>> >   git://git.zen-sources.org/zen/mmotm.git
>> >
>>
>> The current mmotm doesn't boot my T60p. It hangs (hardlock) very early
>> during the boot after Uncompressing the kernel image. The last message
>> I see on the screen is
>>
>> "Probing EDD (edd=off to disable)...
>>
>> Trying with edd=off didn't help. Other commandline options that didn't
>> help include (acpi=off, noapic,nolapic,pci=no). It appears that it
>> hardlocks during hardware detection.
>>
>> Attached is my kernel config:
>>
>
> There're a couple of known problems in booting the latest mmotm,
> 2009-09-14-01-57, on T60p.
>
> The first is passing a NULL pointer to a workqueue from
> clocksource_mark_unstable().  This is fixed by reverting 7285dd7
> "clocksource: Resolve cpu hotplug dead lock with TSC unstable" from the
> x86 timers/core tree; Martin's fix had no affect on this crash.
>
>  [ I notice Thomas has since provided patches for this problem, so I'll
>   check if it solves this issue on T60p. ]
>
> The second is an issue with the i8042 driver's laptop table not being NULL
> terminated.  This is fixed by Jin Dongming's patch at
> http://marc.info/?l=linux-kernel&m=125263897713267.
>
> The config you attached, however, is very different from
> mmotm-2009-09-14-01-57, so perhaps try this kernel with the above two
> fixes to see if you can successfully boot?

I applied both the fixes and it fixes the hardlock problem. However
there is still oopses left that I see during booting, nevertheless
booting succeeds.

Here is the oops message:

Sep 15 15:29:36 jay-t60p kernel: BUG: unable to handle kernel NULL
pointer dereference at (null)
Sep 15 15:29:36 jay-t60p kernel: IP: [<ffffffff81178954>]
bitmap_scnprintf+0x5a/0xae
Sep 15 15:29:36 jay-t60p kernel: PGD 0
Sep 15 15:29:36 jay-t60p kernel: Oops: 0000 [#1] SMP
Sep 15 15:29:36 jay-t60p kernel: last sysfs file:
/sys/devices/pci0000:00/0000:00:01.0/local_cpus
Sep 15 15:29:36 jay-t60p kernel: CPU 1
Sep 15 15:29:36 jay-t60p kernel: Modules linked in: bnep sco nfsd
exportfs rfcomm l2cap crc16 snd_pcm_oss snd_mixer_oss snd_seq
binfmt_misc snd_seq_device nfs lockd nfs_acl auth_rpcgss sunrpc ipv6
cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 ip_tables x_tables bridge stp tun fuse loop dm_mod
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep rtc_cmos
pcmcia btusb snd_pcm snd_timer snd ppdev thinkpad_acpi rtc_core
i2c_i801 yenta_socket iTCO_wdt nsc_ircc usbhid ide_cd_mod video
rsrc_nonstatic pl2303 bluetooth hid soundcore parport_pc led_class
output rtc_lib ac battery button intel_agp i2c_core pcmcia_core pcspkr
usbserial iTCO_vendor_support irda e1000e cdrom snd_page_alloc parport
sg rfkill joydev uinput crc_ccitt uhci_hcd ehci_hcd sd_mod crc_t10dif
usbcore edd ext3 mbcache jbd fan ide_pci_generic ata_generic ata_piix
pata_acpi ahci libata scsi_mod piix ide_core thermal processor
thermal_sys hwmon
Sep 15 15:29:36 jay-t60p kernel: Pid: 2478, comm: irqbalance Not
tainted 2.6.31-rc9-mm1-0.1-default #7 20088JQ
Sep 15 15:29:36 jay-t60p kernel: RIP: 0010:[<ffffffff81178954>]
[<ffffffff81178954>] bitmap_scnprintf+0x5a/0xae
Sep 15 15:29:36 jay-t60p kernel: RSP: 0018:ffff880037a81e38  EFLAGS: 00010246
Sep 15 15:29:36 jay-t60p kernel: RAX: 0000000000000000 RBX:
0000000000000000 RCX: 0000000000000000
Sep 15 15:29:36 jay-t60p kernel: RDX: 0000000000000002 RSI:
0000000000000ffe RDI: 0000000000000000
Sep 15 15:29:36 jay-t60p kernel: RBP: ffff880037a81e68 R08:
0000000000000005 R09: 0000000000000001
Sep 15 15:29:36 jay-t60p kernel: R10: ffffffff813c1cd3 R11:
0000000000000001 R12: 0000000000000000
Sep 15 15:29:36 jay-t60p kernel: R13: 0000000000000000 R14:
0000000000000ffe R15: ffff88007bbe3000
Sep 15 15:29:36 jay-t60p kernel: FS:  00007f605bee46f0(0000)
GS:ffff880005f00000(0000) knlGS:0000000000000000
Sep 15 15:29:36 jay-t60p kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Sep 15 15:29:36 jay-t60p kernel: CR2: 0000000000000000 CR3:
000000007acf8000 CR4: 00000000000006e0
Sep 15 15:29:36 jay-t60p kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Sep 15 15:29:36 jay-t60p kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Sep 15 15:29:36 jay-t60p kernel: Process irqbalance (pid: 2478,
threadinfo ffff880037a80000, task ffff8800376d8280)
Sep 15 15:29:37 jay-t60p rpc.statd[2588]: statd running as root. chown
/var/lib/nfs/sm to choose different user
Sep 15 15:29:37 jay-t60p sm-notify[2596]: Already notifying clients; Exiting!
Sep 15 15:29:36 jay-t60p modem-manager: Loaded plugin MBM
Sep 15 15:29:36 jay-t60p kernel: Stack:
Sep 15 15:29:37 jay-t60p kernel:  ffffffff8152b7d0 ffff88007bbe3000
ffffffff8154a6a8 ffff88007c7aa2d8
Sep 15 15:29:37 jay-t60p kernel: <0> ffffffff81556620 ffff880037a81f48
ffff880037a81e88 ffffffff81186937
Sep 15 15:29:37 jay-t60p kernel: <0> ffff88007c7aa2d8 fffffffffffffffb
ffff880037a81ea8 ffffffff811fbff6
Sep 15 15:29:37 jay-t60p kernel: Call Trace:
Sep 15 15:29:37 jay-t60p kernel:  [<ffffffff81186937>] local_cpus_show+0x36/0x49
Sep 15 15:29:37 jay-t60p kernel:  [<ffffffff811fbff6>] dev_attr_show+0x20/0x44
Sep 15 15:29:37 jay-t60p kernel:  [<ffffffff81121741>]
sysfs_read_file+0xb2/0x131
Sep 15 15:29:37 jay-t60p kernel:  [<ffffffff810ce07c>] vfs_read+0xb1/0x187
Sep 15 15:29:37 jay-t60p kernel:  [<ffffffff810ce216>] sys_read+0x47/0x70
Sep 15 15:29:37 jay-t60p modem-manager: Loaded plugin Sierra
Sep 15 15:29:37 jay-t60p kernel:  [<ffffffff8100b9eb>]
system_call_fastpath+0x16/0x1b
Sep 15 15:29:37 jay-t60p kernel: Code: c1 1f 31 db 83 e1 e0 44 8d 61
e0 eb 5e 44 89 e0 44 89 e1 41 b9 01 00 00 00 c1 f8 06 83 e1 3f 44 8d
42 03 48 98 48 63 fb 44 89 f6 <49> 8b 44 c5 00 49 8d 3c 3f 29 de 41 c1
f8 02 41 83 ec 20 48 d3
Sep 15 15:29:37 jay-t60p kernel: RIP  [<ffffffff81178954>]
bitmap_scnprintf+0x5a/0xae
Sep 15 15:29:37 jay-t60p kernel:  RSP <ffff880037a81e38>
Sep 15 15:29:37 jay-t60p kernel: CR2: 0000000000000000
Sep 15 15:29:37 jay-t60p kernel: ---[ end trace 57e387226b9f2380 ]---


Note: I'd be travelling for the next couple of days mostly may not
have access to internet.

Thanks,
Suresh Jayaraman
