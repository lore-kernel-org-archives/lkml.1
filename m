Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbYDNHsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbYDNHsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYDNHsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:48:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754611AbYDNHsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:48:47 -0400
Date: Mon, 14 Apr 2008 00:48:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: fix oops in oom handling
Message-Id: <20080414004822.cd1c5498.akpm@linux-foundation.org>
In-Reply-To: <20080414162404.b5340fe9.kamezawa.hiroyu@jp.fujitsu.com>
References: <4802FF10.6030905@cn.fujitsu.com>
	<20080414162404.b5340fe9.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 16:24:04 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 14 Apr 2008 14:52:00 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> > It's reproducable in a x86_64 box, but doesn't happen in x86_32.
> > 
> > This is because tsk->sighand is not guarded by RCU, so we have to
> > hold tasklist_lock, just as what out_of_memory() does.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu>
> 
> Andrew, fast-path for 2.6.25 is still not-closed ?

If it was closed, there'd be no point in having rc9 ;)

> I think this patch is worth
> to be merged as bugfix to 2.6.25 if enough acks.

Yes, it's in my for-2.6.25 queue:

mmc-fix-platform-driver-hotplug-coldplug.patch
rtc-fix-the-error-in-the-function-of-cmos_set_alarm.patch
leds-fix-platform-driver-hotplug-coldplug.patch
fbdev-fix-proc-fb-oops-after-module-removal.patch
fix-sys_unsharesem_undo-add-support-for-clone_sysvsem.patch
fix-sys_unsharesem_undo-add-support-for-clone_sysvsem-cleanup.patch
fix-sys_unsharesem_undo-perform-an-implicit-clone_sysvsem-in-clone_newipc.patch
misc-fix-platform-driver-hotplug-coldplug.patch
pcmcia-fix-platform-driver-hotplug-coldplug.patch
serial-fix-platform-driver-hotplug-coldplug.patch
memcg-fix-oops-in-oom-handling.patch

