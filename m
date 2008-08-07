Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbYHGV0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbYHGV0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbYHGVZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:25:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:5720 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203AbYHGVZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:25:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mhVmvh7hD4hRo9nzsOhh4anyM6Y1UCFnEuBlt25SHkeRFTFAsq32LK8hUANAdYzc/q
         8Q7drXG3WfgfHKvbZs2C+as6K0bPLgrQf5SuuxZSLhfcoGjyTOfdYt7ofwhK5peO+n8B
         WHc762tzZZhM+Y89yW2THIAt6+B3vsVPgYlcs=
Message-ID: <dd18b0c30808071425q73429fcbxcdcde3f591984b8c@mail.gmail.com>
Date: Thu, 7 Aug 2008 14:25:24 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: BUG kmalloc-64: Object already free
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Matthew Garrett" <mjg59@srcf.ucam.org>, "Greg KH" <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080807141953.5760f255.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30808061421q20becfd3lad86158f05cea36f@mail.gmail.com>
	 <20080807141953.5760f255.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2008 at 2:19 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 6 Aug 2008 14:21:08 -0700
> "Justin Mattock" <justinmattock@gmail.com> wrote:
>
>> I must be honest, 2.6.27-rc1-00156-g94ad374
>> has made me entirely lazy with wanting to add any patches
>> or taking anything out... but I guess I'll have to pull
>> and add a patch that was sent to me yesterday.
>> upon booting I saw this for the first time with isight: <dmesg below>
>>
>
> hrmpf.  Rafael went and assigned this to me.
>
>> [   12.017890] hub 5-0:1.0: 8 ports detected
>> [   12.067187] =============================================================================
>> [   12.067875] BUG kmalloc-64: Object already free
>> [   12.067875] -----------------------------------------------------------------------------
>> [   12.067875]
>> [   12.067875] INFO: Allocated in isight_firmware_load+0x23/0x1ef
>> [isight_firmware] age=54 cpu=0 pid=1548
>> [   12.067875] INFO: Freed in isight_firmware_load+0x1c2/0x1ef
>> [isight_firmware] age=0 cpu=0 pid=1548
>> [   12.067875] INFO: Slab 0xc169b1e0 objects=36 used=35 fp=0xf4d8f540
>> flags=0x400000c3
>> [   12.067875] INFO: Object 0xf4d8f540 @offset=1344 fp=0x00000000
>> [   12.067875]
>> [   12.067875] Bytes b4 0xf4d8f530:  00 00 00 00 00 00 00 00 5a 5a 5a
>> 5a 5a 5a 5a 5a ........ZZZZZZZZ
>> [   12.067875]   Object 0xf4d8f540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [   12.067875]   Object 0xf4d8f550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [   12.067875]   Object 0xf4d8f560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [   12.067875]   Object 0xf4d8f570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk__
>> [   12.067875]  Redzone 0xf4d8f580:  bb bb bb bb
>>               ________
>> [   12.067875]  Padding 0xf4d8f5a8:  5a 5a 5a 5a 5a 5a 5a 5a
>>               ZZZZZZZZ
>> [   12.067875] Pid: 1548, comm: modprobe Tainted: P
>> 2.6.27-rc1-00156-g94ad374 #5
>> [   12.067875]  [<c0170a6f>] print_trailer+0xd4/0xdc
>> [   12.067875]  [<c0170b2f>] object_err+0x25/0x30
>> [   12.067875]  [<c0171388>] __slab_free+0x1b9/0x279
>> [   12.067875]  [<c0171ad9>] kfree+0xa3/0xb9
>> [   12.067875]  [<f8be01e1>] ? isight_firmware_load+0x1dc/0x1ef
>> [isight_firmware]
>> [   12.067875]  [<f8be01e1>] ? isight_firmware_load+0x1dc/0x1ef
>> [isight_firmware]
>> [   12.067875]  [<f8be01e1>] isight_firmware_load+0x1dc/0x1ef [isight_firmware]
>> [   12.067875]  [<c02ced3b>] usb_probe_interface+0xbd/0xf2
>> [   12.067875]  [<c0284638>] driver_probe_device+0xb8/0x133
>> [   12.067875]  [<c02846f0>] __driver_attach+0x3d/0x5f
>> [   12.067875]  [<c0283e5c>] bus_for_each_dev+0x37/0x5c
>> [   12.067875]  [<c02844b7>] driver_attach+0x14/0x16
>> [   12.067875]  [<c02846b3>] ? __driver_attach+0x0/0x5f
>> [   12.067875]  [<c02841f7>] bus_add_driver+0x93/0x1bc
>> [   12.067875]  [<c028486b>] driver_register+0x71/0xcc
>> [   12.067875]  [<c02ce6cf>] usb_register_driver+0x71/0xcb
>> [   12.067875]  [<f8be2017>] isight_firmware_init+0x17/0x19 [isight_firmware]
>> [   12.067875]  [<c0142f25>] sys_init_module+0x163f/0x17ae
>> [   12.067875]  [<c01171e6>] ? kmap_atomic_prot+0x1a8/0x1d5
>> [   12.067875]  [<c0153d77>] ? unlock_page+0x25/0x28
>> [   12.067875]  [<c0102f9a>] syscall_call+0x7/0xb
>> [   12.067875]  =======================
>> [   12.067875] FIX kmalloc-64: Object at 0xf4d8f540 not freed
>
> But fortunately Parag already fixed it, so I'll merge his fix in my
> next batch to Linus.
>
>
>
> From: "Parag Warudkar" <parag.warudkar@gmail.com>
>
> Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  drivers/usb/misc/isight_firmware.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff -puN drivers/usb/misc/isight_firmware.c~isight_firmware-fix-a-leak-and-double-kfree drivers/usb/misc/isight_firmware.c
> --- a/drivers/usb/misc/isight_firmware.c~isight_firmware-fix-a-leak-and-double-kfree
> +++ a/drivers/usb/misc/isight_firmware.c
> @@ -48,7 +48,8 @@ static int isight_firmware_load(struct u
>
>        if (request_firmware(&firmware, "isight.fw", &dev->dev) != 0) {
>                printk(KERN_ERR "Unable to load isight firmware\n");
> -               return -ENODEV;
> +               ret = -ENODEV;
> +               goto out;
>        }
>
>        ptr = firmware->data;
> @@ -91,7 +92,6 @@ static int isight_firmware_load(struct u
>                             buf, llen, 300) != llen) {
>                                printk(KERN_ERR
>                                       "Failed to load isight firmware\n");
> -                               kfree(buf);
>                                ret = -ENODEV;
>                                goto out;
>                        }
> _
>
>

Cool.

-- 
Justin P. Mattock
