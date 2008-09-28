Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbYI1HW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYI1HW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 03:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYI1HWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 03:22:50 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:53088 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYI1HWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 03:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=KiUdihOfs/0QTshvrKGa0yCDyZCFSGnjY/70SRB2Kx8NDMwaoVRFV+QH9qUA85KENy
         ODlSEfVjm7RuoYqCUyY3L3VUTvIY9TtJGsvH6k9SBNemla3Mjy+lh7kAqMCHEeI3/vAC
         1QUdaE5tXkFzDoW+/yAteFDmyqOuLUMj2KdXM=
Message-ID: <4b6fba110809280022x4e10a068s479dd3d2fd67e9ba@mail.gmail.com>
Date: Sun, 28 Sep 2008 03:22:48 -0400
From: "Daniel Rosenthal" <danielrosenthal@acm.org>
To: "Grant Coady" <gcoady.lk@gmail.com>
Subject: Re: linux object file containing all kernel symbols and suitable for userspace linking?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4httd4pt37d715nqfvge2fau7nahbq6u3a@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4b6fba110809271957t78d7c0c6m97b2b6c1386f7700@mail.gmail.com>
	 <4httd4pt37d715nqfvge2fau7nahbq6u3a@4ax.com>
X-Google-Sender-Auth: 7442cf27a7d2ec95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2008 at 11:13 PM, Grant Coady wrote:
> There's a vmlinux.o in top-level directory after a kernel compile, is
> that what you're after?

It's looks close, but it seems to be missing some symbols.  Below is
an excerpt of some of the some of the error messages that come up when
trying to link vmlinux.o to another object file.  It looks like all
the binary layout related symbols are missing, and jiffies also.
How/when are these symbols normally linked into the final kernel
image?

Daniel


...
/usr/src/linux/vmlinux.o: In function `sched_clock':
/usr/src/linux/kernel/sched.c:80: undefined reference to `jiffies'
/usr/src/linux/vmlinux.o: In function `__might_sleep':
/usr/src/linux/kernel/sched.c:7478: undefined reference to `jiffies'
/usr/src/linux/kernel/sched.c:7480: undefined reference to `jiffies'
/usr/src/linux/vmlinux.o: In function `in_sched_functions':
/usr/src/linux/kernel/sched.c:7289: undefined reference to `__sched_text_start'
/usr/src/linux/kernel/sched.c:7289: undefined reference to `__sched_text_end'
/usr/src/linux/vmlinux.o: In function `print_cpu':
/usr/src/linux/kernel/sched_debug.c:174: undefined reference to `jiffies'
/usr/src/linux/kernel/sched_debug.c:174: undefined reference to `jiffies'
/usr/src/linux/vmlinux.o: In function `printk_timed_ratelimit':
/usr/src/linux/kernel/printk.c:1343: undefined reference to `jiffies'
/usr/src/linux/kernel/printk.c:1344: undefined reference to `jiffies'
/usr/src/linux/vmlinux.o: In function `zap_locks':
/usr/src/linux/kernel/printk.c:550: undefined reference to `jiffies'
/usr/src/linux/vmlinux.o:/usr/src/linux/kernel/printk.c:550: more
undefined references to `jiffies' follow
...
/usr/src/linux/vmlinux.o: In function `mem_init':
/usr/src/linux/arch/x86/mm/init_32.c:603: undefined reference to `_text'
/usr/src/linux/arch/x86/mm/init_32.c:605: undefined reference to `__init_end'
/usr/src/linux/arch/x86/mm/init_32.c:605: undefined reference to `__init_begin'
/usr/src/linux/arch/x86/mm/init_32.c:623: undefined reference to `_text'
/usr/src/linux/arch/x86/mm/init_32.c:623: undefined reference to `__init_end'
/usr/src/linux/arch/x86/mm/init_32.c:623: undefined reference to `__init_begin'
/usr/src/linux/vmlinux.o: In function `is_kernel_text':
/usr/src/linux/arch/x86/mm/init_32.c:147: undefined reference to `__init_end'
/usr/src/linux/arch/x86/mm/init_32.c:147: undefined reference to `__init_end'
/usr/src/linux/vmlinux.o: In function `kernel_physical_mapping_init':
/usr/src/linux/arch/x86/mm/init_32.c:207: undefined reference to `__init_end'
/usr/src/linux/vmlinux.o: In function `page_writeback_init':
/usr/src/linux/mm/page-writeback.c:773: undefined reference to `jiffies'
...
