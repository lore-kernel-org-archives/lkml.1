Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbYFIUya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbYFIUya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYFIUyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:54:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:3506 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbYFIUyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kCEejMgnGOGyXvslAUPxuBcnY0dc6NuIB3KfNq69MRVibBaQeVVVm90+tdT0ayltSc
         ie1V0P+dbadAD1ZKp8ZO7aDvZ5OIRbD0+YRZnHNtTTYWp4XiKiM9UmMUd6hLUqNSpKM2
         D75Ri+IzR5shKj9UvqmOeTGdjcpBEYZHbIC5o=
Message-ID: <dd18b0c30806091354j2b5ffb9bp5ae06d9537882c7d@mail.gmail.com>
Date: Mon, 9 Jun 2008 20:54:19 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: 26-rc5+git hang on boot bluetooth hidd/hid_devices
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <1213040101.15360.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213015948.7018.48.camel@localhost>
	 <1213022913.17870.4.camel@violet.holtmann.net>
	 <1213029509.4521.29.camel@localhost>
	 <1213035594.17870.6.camel@violet.holtmann.net>
	 <1213040101.15360.7.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 7:35 PM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> On Mon, 2008-06-09 at 20:19 +0200, Marcel Holtmann wrote:
>> Hi Soeren,
>>
>> > > > updating to 2.6.26-rc5+git I recognize that debian sid suddenly hangs on
>> > > > boot when bluetooth is activated. The last message I see is starting
>> > > > hidd/hid_devices. And well 2.6.24/25 boot.
>> > > >
>> > > > Does anybody else observe this? Any ideas?
>> > >
>> > > is HID2HCI switching utility on? Do you have a HID proxy adapter in your
>> > > system? If yes, then it is actually an USB issue.
>> >
>> > yes hid2hci is on as this system is a macbookpro that tends to forget
>> > that it has internal bluetooth after resume (if resume even works)
>>
>> then please disable hid2hci and see if it still has a problem and report
>> this to the USB guys.
>
> Indeed when I disable the call to hid2hci it boots through. While
> booting I see another (unrelated?) oops (see below).
>
> When I after booting call hid2hci in a terminal it simply hangs.
>
>
> PCI: Setting latency timer of device 0000:00:1b.0 to 64
> hda_codec: STAC922x, Apple subsys_id=106b0200
> BUG: unable to handle kernel paging request at f888c000
> IP: [<f883b115>] :isight_firmware:isight_firmware_load+0x105/0x240
> *pde = 37804067 *pte = 00000000
> Oops: 0000 [#1] PREEMPT SMP
> Modules linked in: snd_hda_intel snd_pcm_oss snd_mixer_oss i2c_i801 isight_firmware(+) snd_pcm snd_timer appletouch snd sky2 soundcore snd_page_alloc evdev
>
> Pid: 964, comm: modprobe Not tainted (2.6.26-rc5-sonne #28)
> EIP: 0060:[<f883b115>] EFLAGS: 00010207 CPU: 0
> EIP is at isight_firmware_load+0x105/0x240 [isight_firmware]
> EAX: f71e0f00 EBX: f888bff3 ECX: 00000009 EDX: f71e0f00
> ESI: f888bfff EDI: f71e0f0c EBP: f7191d40 ESP: f7191cfc
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process modprobe (pid: 964, ti=f7190000 task=f707d390 task.ti=f7190000)
> Stack: 00000040 000092fa 00000000 f71e0f00 00000032 0000012c 0000fa87 0000932c
>       f7b6c45c f7b6c400 00000032 f71e0f00 b48dffff f71f60e0 00000000 f7bd6400
>       f883b7e0 f7191d68 c03315dc 00000000 f7bd641c f7bd6494 f883b760 f7b6c400
> Call Trace:
>  [<c03315dc>] ? usb_probe_interface+0xac/0x120
>  [<c02e9b98>] ? driver_probe_device+0x88/0x1a0
>  [<c01ceeab>] ? sysfs_create_dir+0x2b/0x50
>  [<c02e9d29>] ? __driver_attach+0x79/0x80
>  [<c02e94b3>] ? bus_for_each_dev+0x53/0x80
>  [<c02e9a29>] ? driver_attach+0x19/0x20
>  [<c02e9cb0>] ? __driver_attach+0x0/0x80
>  [<c02e8e6f>] ? bus_add_driver+0x1bf/0x240
>  [<c02e9ec9>] ? driver_register+0x69/0x150
>  [<c0124c64>] ? try_to_wake_up+0x74/0x200
>  [<c033188c>] ? usb_register_driver+0x7c/0x100
>  [<f8843017>] ? isight_firmware_init+0x17/0x19 [isight_firmware]
>  [<c0153965>] ? sys_init_module+0x115/0x1ca0
>  [<c02002e5>] ? ext3_dirty_inode+0x55/0x80
>  [<c0182300>] ? __kmalloc+0x0/0xe0
>  [<c01032d1>] ? sysenter_past_esp+0x6a/0x91
>  =======================
> Code: b5 83 7d d4 32 bf 32 00 00 00 ba d0 00 00 00 89 de 0f 4e 7d d4 89 f8 89 7d e4 e8 f7 71 94 c7 89 f9 c1 e9 02 89 c2 89 45 e8 89 d7 <f3> a5 8b 4d e4 83 e1 03 74 02 f3 a4 8b 45 e0 b9 a0 00 00 00 8b
> EIP: [<f883b115>] isight_firmware_load+0x105/0x240 [isight_firmware] SS:ESP 0068:f7191cfc
> ---[ end trace 8ea9a3ecbcdbff55 ]---
>
> Soeren
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Sounds like you might be having the same issue I was having with isight_firmware
here is the link to the patch: http://lkml.org/lkml/2008/6/6/407
check and make sure, from what I could tell they look similar.
regards;


-- 
Justin P. Mattock
