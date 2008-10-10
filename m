Return-Path: <linux-kernel-owner+w=401wt.eu-S1763747AbYJJTzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763747AbYJJTzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761086AbYJJTzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:55:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:11308 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761067AbYJJTzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MZ+CvHkIZCAlsQth2jcaE5kMLwIPYjuQ9IJUr+4ehoySxkijPl3Jd6zVq4t269S9LF
         yj+aCMyX37H4EjsUxcaXPnRPGpDbZQAdbk1vho+o0owINEjOj+0J/kCJRPU5a2zBmVl0
         ThM2hB7FDnNBo6S8UXGlQ+Gi85MhPyyXwc7NA=
Message-ID: <f7848160810101255q42325527m793365e75082a53a@mail.gmail.com>
Date: Fri, 10 Oct 2008 15:55:38 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] WARNING: at kernel/power/main.c:176 suspend_test_finish+0x70/0x80()
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200810102134.27112.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0810101257030.2185-100000@iolanthe.rowland.org>
	 <200810102134.27112.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 3:34 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

>> It isn't in mainline; it's in linux-next.  Sorry, I wasn't sure which
>> kernel you were using.
>
> I understood it was the mainline from the report.
>
> Parag, could you please try to suspend without the USB drivers and see if the
> delay is still there?
>
Hi Rafael,

I did and it still does it of course with different stack trace -

[ 3929.502328] Pid: 8069, comm: pm-suspend Not tainted 2.6.27 #3
[ 3929.502329] Call Trace:
[ 3929.502334]  [<ffffffff8024721f>] warn_on_slowpath+0x5f/0x90
[ 3929.502337]  [<ffffffff804beb2e>] ? printk+0x67/0x69
[ 3929.502340]  [<ffffffff80377437>] ? kobject_put+0x27/0x60
[ 3929.502343]  [<ffffffff803f9905>] ? put_device+0x15/0x20
[ 3929.502345]  [<ffffffff80401afa>] ? device_resume+0x39a/0x460
[ 3929.502347]  [<ffffffff80274300>] suspend_test_finish+0x70/0x80
[ 3929.502349]  [<ffffffff802743f4>] suspend_devices_and_enter+0xe4/0x200
[ 3929.502351]  [<ffffffff80274686>] enter_state+0x146/0x1d0
[ 3929.502353]  [<ffffffff802747ca>] state_store+0xba/0x100
[ 3929.502354]  [<ffffffff803772f7>] kobj_attr_store+0x17/0x20
[ 3929.502357]  [<ffffffff803265a5>] sysfs_write_file+0xc5/0x140
[ 3929.502360]  [<ffffffff802cd18b>] vfs_write+0xcb/0x190
[ 3929.502362]  [<ffffffff802cd340>] sys_write+0x50/0x90
[ 3929.502365]  [<ffffffff8021163a>] system_call_fastpath+0x16/0x1b
[ 3929.502366] ---[ end trace 16538c71b37f9061 ]---
[ 3929.502557] PM: Finishing wakeup.
[ 3929.502558] Restarting tasks ... done.

Thanks
Parag
