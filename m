Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab0CLJwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:52:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:36289 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab0CLJwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:52:11 -0500
Date: Fri, 12 Mar 2010 10:52:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: use sysfs_bin_attr_init in firmware class
 driver
In-Reply-To: <alpine.LNX.2.00.1003091856430.17799@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1003121051340.18642@pobox.suse.cz>
References: <alpine.LNX.2.00.1003091856430.17799@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is anyone going to pick this one up please?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

On Tue, 9 Mar 2010, Jiri Kosina wrote:

> Annotate dynamic sysfs attribute in fw_setup_device(). This gets
> rid of the following lockdep warning:
> 
> bnx2 0000:08:00.0: firmware: requesting bnx2/bnx2-mips-06-5.0.0.j6.fw
> BUG: key ffff880008293470 not in .data!
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x562/0x620()
> Modules linked in: bnx2(+) sg tpm_bios floppy rtc_lib usb_storage i2c_piix4 joydev button container shpchp i2c_core sr_mod cdrom pci_hotplug usbhid hid ohci_hcd ehci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ata_generic sata_svw pata_serverworks libata scsi_mod thermal processor
> Pid: 1915, comm: work_for_cpu Not tainted 2.6.34-rc1-default #81
> Call Trace:
>  [<ffffffff8107c1d2>] ? lockdep_init_map+0x562/0x620
>  [<ffffffff81049fd8>] warn_slowpath_common+0x78/0xd0
>  [<ffffffff8104a03f>] warn_slowpath_null+0xf/0x20
>  [<ffffffff8107c1d2>] lockdep_init_map+0x562/0x620
>  [<ffffffff8117a236>] ? sysfs_new_dirent+0x76/0x120
>  [<ffffffff8126edb2>] ? put_device+0x12/0x20
>  [<ffffffff811797cc>] sysfs_add_file_mode+0x6c/0xd0
>  [<ffffffff8117983c>] sysfs_add_file+0xc/0x10
>  [<ffffffff8117bf61>] sysfs_create_bin_file+0x21/0x30
>  [<ffffffff81279c61>] _request_firmware+0x2f1/0x650
>  [<ffffffff8127a04e>] request_firmware+0xe/0x10
>  [<ffffffffa01ec19e>] bnx2_init_one+0x8f5/0x177e [bnx2]
>  [<ffffffff81389eab>] ? _raw_spin_unlock_irq+0x2b/0x40
>  [<ffffffff81040ed9>] ? finish_task_switch+0x69/0x100
>  [<ffffffff81040e70>] ? finish_task_switch+0x0/0x100
>  [<ffffffff81064b40>] ? do_work_for_cpu+0x0/0x30
>  [<ffffffff811e6302>] local_pci_probe+0x12/0x20
>  [<ffffffff81064b53>] do_work_for_cpu+0x13/0x30
>  [<ffffffff81064b40>] ? do_work_for_cpu+0x0/0x30
>  [<ffffffff81068c56>] kthread+0x96/0xa0
>  [<ffffffff81003e64>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8138a350>] ? restore_args+0x0/0x30
>  [<ffffffff81068bc0>] ? kthread+0x0/0xa0
>  [<ffffffff81003e60>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace a2ecee9c9602d195 ]---
> 
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> --- 
>  drivers/base/firmware_class.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index d0dc26a..fc7565c 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -442,6 +442,7 @@ static int fw_setup_device(struct firmware *fw, struct device **dev_p,
>  	fw_priv = dev_get_drvdata(f_dev);
>  
>  	fw_priv->fw = fw;
> +	sysfs_bin_attr_init(&fw_priv->attr_data);
>  	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
>  	if (retval) {
>  		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
> 
