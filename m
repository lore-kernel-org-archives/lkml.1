Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab0CIAhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 19:37:24 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:41698 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0CIAhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 19:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XPCH7pc+nPlCwI9Qi3PvGxdK0h44hYXUuoRMApNMd9Go/59pltkhnRC79WdaZIm/KD
         f/Ce5xcfPTVVk9/3HX9fEhhAku/kDYVkwEO388Cc0wUxIvDNo+NFeJwpmfrtxf5v0OKz
         8r/1IH+Dwm0nQvjLQtra6Z/pu7AzTdzGA8xEY=
Date: Tue, 9 Mar 2010 08:40:25 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.34-rc1: ACPI: BUG: key f71f0168 not in .data!
Message-ID: <20100309004025.GC2722@hack>
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com> <86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com> <86802c441003081632g32d35c8arcb50608dd0dcf714@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c441003081632g32d35c8arcb50608dd0dcf714@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 04:32:36PM -0800, Yinghai Lu wrote:
>> [  145.239329] BUG: key ffff88206fe99c58 not in .data!
>> [  145.244994] ------------[ cut here ]------------
>> [  145.250949] WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0xf1/0x53c()
>> [  145.267543] Modules linked in:
>> [  145.275078] Pid: 1, comm: swapper Not tainted 2.6.34-rc1-yh-dirty #221
>> [  145.285140] Call Trace:
>> [  145.290143]  [<ffffffff810759b0>] warn_slowpath_common+0x7c/0x94
>> [  145.304624]  [<ffffffff810759dc>] warn_slowpath_null+0x14/0x16
>> [  145.314632]  [<ffffffff8109f299>] lockdep_init_map+0xf1/0x53c
>> [  145.325228]  [<ffffffff8117e100>] ? sysfs_new_dirent+0x8f/0x104
>> [  145.334331]  [<ffffffff8117d72e>] sysfs_add_file_mode+0x66/0xac
>> [  145.339850]  [<ffffffff8117d785>] sysfs_add_file+0x11/0x13
>> [  145.355513]  [<ffffffff8117d844>] sysfs_create_file+0x2a/0x2c
>> [  145.360637]  [<ffffffff8148ca98>] device_create_file+0x19/0x1b
>> [  145.375187]  [<ffffffff8145fc9a>] ipmi_register_smi+0x862/0xd72
>> [  145.384606]  [<ffffffff8148b9f8>] ? put_device+0x17/0x19
>> [  145.395142]  [<ffffffff8148cee5>] ? device_add+0x44b/0x52a
>> [  145.403666]  [<ffffffff8108fb5a>] ? autoremove_wake_function+0x0/0x39
>> [  145.416309]  [<ffffffff81462e71>] try_smi_init+0x6d0/0x8a0
>> [  145.424534]  [<ffffffff81ba2fd5>] init_ipmi_si+0x4cf/0x907
>> [  145.434799]  [<ffffffff81ba2b06>] ? init_ipmi_si+0x0/0x907
>> [  145.439677]  [<ffffffff8100020d>] do_one_initcall+0x72/0x17f
>> [  145.455681]  [<ffffffff826836a0>] kernel_init+0x166/0x1f0
>> [  145.463319]  [<ffffffff81032914>] kernel_thread_helper+0x4/0x10
>> [  145.476497]  [<ffffffff81bfc2bc>] ? restore_args+0x0/0x30
>> [  145.485014]  [<ffffffff8268353a>] ? kernel_init+0x0/0x1f0
>> [  145.495859]  [<ffffffff81032910>] ? kernel_thread_helper+0x0/0x10
>> [  145.501541] ---[ end trace 0ec12b1482c47368 ]---
>
>related to ?
>commit a2db6842873c8e5a70652f278d469128cb52db70

Yes. Need to add sysfs_attr_init() or sysfs_bin_attr_init() in the
driver code.

-- 
Live like a child, think like the god.
 
