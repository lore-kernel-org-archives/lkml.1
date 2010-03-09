Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab0CIAck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 19:32:40 -0500
Received: from mail-pz0-f200.google.com ([209.85.222.200]:63511 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0CIAcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 19:32:36 -0500
X-Greylist: delayed 1198 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 19:32:36 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fXe95gkJgF49wlv8VvVbCNw/k4FdqRlJC9wQxbdqkPWz5ybyGNpH9enmNOSv61U5yM
         R7QgYb/IogDmghrF+98pDWLXMH1S7XpVY2QFGrOIm31i6E0krSfqykGwqalmx7yp7A2i
         UZtp+tXNOlZHejN64lmkquCZ6Sk11XLIZKWlY=
MIME-Version: 1.0
In-Reply-To: <86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com>
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com>
	 <86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com>
Date: Mon, 8 Mar 2010 16:32:36 -0800
X-Google-Sender-Auth: 6bf6a6df760b69d4
Message-ID: <86802c441003081632g32d35c8arcb50608dd0dcf714@mail.gmail.com>
Subject: Re: 2.6.34-rc1: ACPI: BUG: key f71f0168 not in .data!
From: Yinghai Lu <yinghai@kernel.org>
To: Alexander Beregalov <a.beregalov@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [  145.239329] BUG: key ffff88206fe99c58 not in .data!
> [  145.244994] ------------[ cut here ]------------
> [  145.250949] WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0xf1/0x53c()
> [  145.267543] Modules linked in:
> [  145.275078] Pid: 1, comm: swapper Not tainted 2.6.34-rc1-yh-dirty #221
> [  145.285140] Call Trace:
> [  145.290143]  [<ffffffff810759b0>] warn_slowpath_common+0x7c/0x94
> [  145.304624]  [<ffffffff810759dc>] warn_slowpath_null+0x14/0x16
> [  145.314632]  [<ffffffff8109f299>] lockdep_init_map+0xf1/0x53c
> [  145.325228]  [<ffffffff8117e100>] ? sysfs_new_dirent+0x8f/0x104
> [  145.334331]  [<ffffffff8117d72e>] sysfs_add_file_mode+0x66/0xac
> [  145.339850]  [<ffffffff8117d785>] sysfs_add_file+0x11/0x13
> [  145.355513]  [<ffffffff8117d844>] sysfs_create_file+0x2a/0x2c
> [  145.360637]  [<ffffffff8148ca98>] device_create_file+0x19/0x1b
> [  145.375187]  [<ffffffff8145fc9a>] ipmi_register_smi+0x862/0xd72
> [  145.384606]  [<ffffffff8148b9f8>] ? put_device+0x17/0x19
> [  145.395142]  [<ffffffff8148cee5>] ? device_add+0x44b/0x52a
> [  145.403666]  [<ffffffff8108fb5a>] ? autoremove_wake_function+0x0/0x39
> [  145.416309]  [<ffffffff81462e71>] try_smi_init+0x6d0/0x8a0
> [  145.424534]  [<ffffffff81ba2fd5>] init_ipmi_si+0x4cf/0x907
> [  145.434799]  [<ffffffff81ba2b06>] ? init_ipmi_si+0x0/0x907
> [  145.439677]  [<ffffffff8100020d>] do_one_initcall+0x72/0x17f
> [  145.455681]  [<ffffffff826836a0>] kernel_init+0x166/0x1f0
> [  145.463319]  [<ffffffff81032914>] kernel_thread_helper+0x4/0x10
> [  145.476497]  [<ffffffff81bfc2bc>] ? restore_args+0x0/0x30
> [  145.485014]  [<ffffffff8268353a>] ? kernel_init+0x0/0x1f0
> [  145.495859]  [<ffffffff81032910>] ? kernel_thread_helper+0x0/0x10
> [  145.501541] ---[ end trace 0ec12b1482c47368 ]---

related to ?
commit a2db6842873c8e5a70652f278d469128cb52db70
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Thu Feb 11 15:20:00 2010 -0800

    sysfs: Only take active references on attributes.

    If we exclude directories and symlinks from the set of sysfs
    dirents where we need active references we are left with
    sysfs attributes (binary or not).

    - Tweak sysfs_deactivate to only do something on attributes
    - Move lockdep initialization into sysfs_file_add_mode to
      limit it to just attributes.
