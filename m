Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0CLCaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 21:30:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:47350 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab0CLCaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 21:30:00 -0500
Message-ID: <4B99A6F0.4080203@kernel.org>
Date: Thu, 11 Mar 2010 18:29:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Alexander Beregalov <a.beregalov@gmail.com>, Greg KH <gregkh@suse.de>,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.34-rc1: ACPI: BUG: key f71f0168 not in .data!
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com>	<86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com>	<m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org> <m14okqnczd.fsf@fess.ebiederm.org>
In-Reply-To: <m14okqnczd.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>> [  145.290143]  [<ffffffff810759b0>] warn_slowpath_common+0x7c/0x94
>>>> [  145.304624]  [<ffffffff810759dc>] warn_slowpath_null+0x14/0x16
>>>> [  145.314632]  [<ffffffff8109f299>] lockdep_init_map+0xf1/0x53c
>>>> [  145.325228]  [<ffffffff8117e100>] ? sysfs_new_dirent+0x8f/0x104
>>>> [  145.334331]  [<ffffffff8117d72e>] sysfs_add_file_mode+0x66/0xac
>>>> [  145.339850]  [<ffffffff8117d785>] sysfs_add_file+0x11/0x13
>>>> [  145.355513]  [<ffffffff8117d844>] sysfs_create_file+0x2a/0x2c
>>>> [  145.360637]  [<ffffffff8148ca98>] device_create_file+0x19/0x1b
>>>> [  145.375187]  [<ffffffff8145fc9a>] ipmi_register_smi+0x862/0xd72
>>>> [  145.384606]  [<ffffffff8148b9f8>] ? put_device+0x17/0x19
>>>> [  145.395142]  [<ffffffff8148cee5>] ? device_add+0x44b/0x52a
>>>> [  145.403666]  [<ffffffff8108fb5a>] ? autoremove_wake_function+0x0/0x39
>>>> [  145.416309]  [<ffffffff81462e71>] try_smi_init+0x6d0/0x8a0
>>>> [  145.424534]  [<ffffffff81ba2fd5>] init_ipmi_si+0x4cf/0x907
>>>> [  145.434799]  [<ffffffff81ba2b06>] ? init_ipmi_si+0x0/0x907
>>>> [  145.439677]  [<ffffffff8100020d>] do_one_initcall+0x72/0x17f
>>>> [  145.455681]  [<ffffffff826836a0>] kernel_init+0x166/0x1f0
>>>> [  145.463319]  [<ffffffff81032914>] kernel_thread_helper+0x4/0x10
>>>> [  145.476497]  [<ffffffff81bfc2bc>] ? restore_args+0x0/0x30
>>>> [  145.485014]  [<ffffffff8268353a>] ? kernel_init+0x0/0x1f0
>>>> [  145.495859]  [<ffffffff81032910>] ? kernel_thread_helper+0x0/0x10
>>>> [  145.501541] ---[ end trace 0ec12b1482c47368 ]---
>>>
>>> diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
>>> index ec5e3f8..16e9073 100644
>>> --- a/drivers/char/ipmi/ipmi_msghandler.c
>>> +++ b/drivers/char/ipmi/ipmi_msghandler.c
>>> @@ -2272,42 +2272,52 @@ static int create_files(struct bmc_device *bmc)
>>>  	bmc->device_id_attr.attr.name = "device_id";
>>>  	bmc->device_id_attr.attr.mode = S_IRUGO;
>>>  	bmc->device_id_attr.show = device_id_show;
>>> +	sysfs_attr_init(&bmc->device_id_attr.attr);
>>>  
>>>  	bmc->provides_dev_sdrs_attr.attr.name = "provides_device_sdrs";
>>>  	bmc->provides_dev_sdrs_attr.attr.mode = S_IRUGO;
>>>  	bmc->provides_dev_sdrs_attr.show = provides_dev_sdrs_show;
>>> +	sysfs_attr_init(&bmc->device_id_attr.attr);
...
> If you would be so kind and help by posting the back traces so we can
> find the handful of places left that dynamically allocate their sysfs
> attributes that would be very much appreciated.

have some typo in your patch.. all have the same name....

change them to right name, will fix that in ipmi path...

---
 drivers/char/ipmi/ipmi_msghandler.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ linux-2.6/drivers/char/ipmi/ipmi_msghandler.c
@@ -2272,42 +2272,52 @@ static int create_files(struct bmc_devic
 	bmc->device_id_attr.attr.name = "device_id";
 	bmc->device_id_attr.attr.mode = S_IRUGO;
 	bmc->device_id_attr.show = device_id_show;
+	sysfs_attr_init(&bmc->device_id_attr.attr);
 
 	bmc->provides_dev_sdrs_attr.attr.name = "provides_device_sdrs";
 	bmc->provides_dev_sdrs_attr.attr.mode = S_IRUGO;
 	bmc->provides_dev_sdrs_attr.show = provides_dev_sdrs_show;
+	sysfs_attr_init(&bmc->provides_dev_sdrs_attr.attr);
 
 	bmc->revision_attr.attr.name = "revision";
 	bmc->revision_attr.attr.mode = S_IRUGO;
 	bmc->revision_attr.show = revision_show;
+	sysfs_attr_init(&bmc->revision_attr.attr);
 
 	bmc->firmware_rev_attr.attr.name = "firmware_revision";
 	bmc->firmware_rev_attr.attr.mode = S_IRUGO;
 	bmc->firmware_rev_attr.show = firmware_rev_show;
+	sysfs_attr_init(&bmc->firmware_rev_attr.attr);
 
 	bmc->version_attr.attr.name = "ipmi_version";
 	bmc->version_attr.attr.mode = S_IRUGO;
 	bmc->version_attr.show = ipmi_version_show;
+	sysfs_attr_init(&bmc->version_attr.attr);
 
 	bmc->add_dev_support_attr.attr.name = "additional_device_support";
 	bmc->add_dev_support_attr.attr.mode = S_IRUGO;
 	bmc->add_dev_support_attr.show = add_dev_support_show;
+	sysfs_attr_init(&bmc->add_dev_support_attr.attr);
 
 	bmc->manufacturer_id_attr.attr.name = "manufacturer_id";
 	bmc->manufacturer_id_attr.attr.mode = S_IRUGO;
 	bmc->manufacturer_id_attr.show = manufacturer_id_show;
+	sysfs_attr_init(&bmc->manufacturer_id_attr.attr);
 
 	bmc->product_id_attr.attr.name = "product_id";
 	bmc->product_id_attr.attr.mode = S_IRUGO;
 	bmc->product_id_attr.show = product_id_show;
+	sysfs_attr_init(&bmc->product_id_attr.attr);
 
 	bmc->guid_attr.attr.name = "guid";
 	bmc->guid_attr.attr.mode = S_IRUGO;
 	bmc->guid_attr.show = guid_show;
+	sysfs_attr_init(&bmc->guid_attr.attr);
 
 	bmc->aux_firmware_rev_attr.attr.name = "aux_firmware_revision";
 	bmc->aux_firmware_rev_attr.attr.mode = S_IRUGO;
 	bmc->aux_firmware_rev_attr.show = aux_firmware_rev_show;
+	sysfs_attr_init(&bmc->aux_firmware_rev_attr.attr);
 
 	err = device_create_file(&bmc->dev->dev,
 			   &bmc->device_id_attr);
