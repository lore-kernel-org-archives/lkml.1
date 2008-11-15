Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYKOXXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYKOXXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 18:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYKOXXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 18:23:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41280 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbYKOXXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 18:23:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code: latencytop/5621
Date: Sun, 16 Nov 2008 00:28:12 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
References: <20081114085820.GA5206@dhcp35.suse.cz>
In-Reply-To: <20081114085820.GA5206@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811160028.13724.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 14 of November 2008, Michal Hocko wrote:
> Hi Ingo,
> I am experiencing %subj whenever I run latencytop with the rc4 kernel. I
> have bisected down to the patch 7cbaef9c83e58bbd4bdd534b09052b6c5ec457d5
> I am not sure whether this is the same problem as the one reported by
> Maciej Rutecki (http://lkml.org/lkml/2008/11/12/266), but I have tried
> your patch (http://lkml.org/lkml/2008/11/12/295) and the problem is
> still there:
> BUG: using smp_processor_id() in preemptible [00000000] code:
> latencytop/5621
> caller is native_sched_clock+0x47/0x65
> Pid: 5621, comm: latencytop Not tainted 2.6.28-rc4 #13
> Call Trace:
>  [<c03f17c0>] ? printk+0xf/0x11
>  [<c022ad36>] debug_smp_processor_id+0xa2/0xb8
>  [<c01080d4>] native_sched_clock+0x47/0x65
>  [<c01259a9>] proc_sched_show_task+0xd72/0xdd0
>  [<c01a73c4>] sched_show+0x39/0x55
>  [<c018cc43>] seq_read+0xee/0x29a
>  [<c018cb55>] ? seq_read+0x0/0x29a
>  [<c017a04c>] vfs_read+0x87/0x12b
>  [<c017a189>] sys_read+0x3b/0x60
>  [<c0103a59>] sysenter_do_call+0x12/0x25
>  [<c03f0000>] ? cpu_callback+0x238/0x25b
> 
> I receive flood if this messages immediately after latencytop starts.
> Reverting 7cbaef9c83e58bbd4bdd534b09052b6c5ec457d5 solves the problem.
> Config is attached.
> 
> Let me know if you need some more testing (however I will afk until
> Tuesday).

Please retest with 2.6.28-rc5.

Thanks,
Rafael
