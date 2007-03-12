Return-Path: <linux-kernel-owner+w=401wt.eu-S965088AbXCLEmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088AbXCLEmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 00:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965122AbXCLEmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 00:42:18 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44643 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965088AbXCLEmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 00:42:17 -0400
X-Sasl-enc: Mp5wwvLzOW7RNOGbGbR/K/CNRmSO6FQJ8VtLsvxg0T3z 1173674535
Date: Mon, 12 Mar 2007 13:43:08 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Thomas Renninger <trenn@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Null pointer in autofs4 (_spin_lock) in 2.6.21-rc2
In-Reply-To: <1173648544.7690.68.camel@linux-8rt8.site>
Message-ID: <Pine.LNX.4.64.0703121333080.9590@raven.themaw.net>
References: <1173344276.5863.21.camel@queen.suse.de> 
 <20070308012844.025794e3.akpm@linux-foundation.org>  <1173348736.5863.23.camel@queen.suse.de>
  <1173350391.3467.2.camel@raven.themaw.net> <1173648544.7690.68.camel@linux-8rt8.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2007, Thomas Renninger wrote:

> On Thu, 2007-03-08 at 19:39 +0900, Ian Kent wrote:
> > On Thu, 2007-03-08 at 11:12 +0100, Thomas Renninger wrote:
> > > On Thu, 2007-03-08 at 01:28 -0800, Andrew Morton wrote:
> > > > > On Thu, 08 Mar 2007 09:57:56 +0100 Thomas Renninger <trenn@suse.de> wrote:
> > > > > I saw this happening several times on 2.6.21-rc2.
> > > > > Tell me how I can help...
> > > > > Some nfs partitions are mounted via nfs using autofs.
> > > > > It takes some hours to run into this:
> > > > > 
> > > > > Unable to handle kernel NULL pointer dereference at 0000000000000008
> > > > > RIP:
> > > > >  [<ffffffff8025bada>] _spin_lock+0x0/0xf
> > > > > PGD 1dde23067 PUD 1d3060067 PMD 0
> > > > > Oops: 0002 [1] SMP
> > > > > CPU 3
> > > > > Modules linked in: autofs4 nfs lockd nfs_acl sunrpc asus_acpi af_packet
> > > > > tg3 ipv6 button battery ac ext2 mbcache loop dm_mod floppy parport_pc lp
> > > > > parport reiserfs pata_amd edd fan thermal sg processor sata_sil libata
> > > > > amd74xx sd_mod scsi_mod ide_disk ide_core
> > > > > Pid: 11373, comm: touch Not tainted 2.6.21-rc2-default #6
> > > > > RIP: 0010:[<ffffffff8025bada>]  [<ffffffff8025bada>] _spin_lock+0x0/0xf
> > > > > RSP: 0018:ffff8101c50a5a50  EFLAGS: 00010202
> > > > > RAX: ffff8100eb8916f8 RBX: ffff81010007dcd8 RCX: ffff8100ea45b280
> > > > > RDX: 0000000010e58c2e RSI: ffff810163bf9e50 RDI: 0000000000000008
> > > > > RBP: ffff810163bf9e50 R08: ffff8101c50a4000 R09: ffff8101c50a5ea8
> > > > > R10: ffff81010003fca8 R11: ffffffff802299ad R12: 0000000000000000
> > > > > R13: ffff8100eb891680 R14: 0000000000000005 R15: ffff8101c50a5b48
> > > > > FS:  00002b8ae744bf20(0000) GS:ffff81010016a7c0(0000)
> > > > > knlGS:00000000b7bd88d0
> > > > > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > > > CR2: 0000000000000008 CR3: 00000001b925f000 CR4: 00000000000006e0
> > > > > Process touch (pid: 11373, threadinfo ffff8101c50a4000, task
> > > > > ffff8101b78bd100)
> > > > > Stack:  ffffffff882d5f38 ffff8101c50a5ea8 ffff8100ec8df4b0
> > > > > 00000000000000d0
> > > > >  ffff8100eb8916f8 ffff810163bf9efc 10e58c2eea45b220 ffff8100ea45b220
> > > > >  ffff810163bf9e50 ffff8100ea45b220 ffff8100ec8df4b0 ffff8100ec8df568
> > > > > Call Trace:
> > > > >  [<ffffffff882d5f38>] :autofs4:autofs4_lookup+0xcb/0x311
> > > > >  [<ffffffff8020c0d8>] do_lookup+0xc4/0x1ae
> > > > >  [<ffffffff802097be>] __link_path_walk+0x8ec/0xd9d
> > > > >  [<ffffffff8824ca24>] :sunrpc:rpcauth_lookup_credcache+0x12e/0x24a
> > > > >  [<ffffffff8020da3e>] link_path_walk+0x58/0xe0
> > > > >  [<ffffffff80232d3f>] __strncpy_from_user+0x17/0x41
> > > > >  [<ffffffff8020949b>] __link_path_walk+0x5c9/0xd9d
> > > > >  [<ffffffff8020da3e>] link_path_walk+0x58/0xe0
> > > > >  [<ffffffff80232d3f>] __strncpy_from_user+0x17/0x41
> > > > >  [<ffffffff8020bea7>] do_path_lookup+0x1b6/0x217
> > > > >  [<ffffffff80221512>] __path_lookup_intent_open+0x56/0x97
> > > > >  [<ffffffff80218912>] open_namei+0xa9/0x64c
> > > > >  [<ffffffff8025dc33>] do_page_fault+0x45e/0x7ad
> > > > >  [<ffffffff802250eb>] do_filp_open+0x1c/0x38
> > > > >  [<ffffffff80232d3f>] __strncpy_from_user+0x17/0x41
> > > > >  [<ffffffff80217698>] do_sys_open+0x44/0xc1
> > > > >  [<ffffffff8025511e>] system_call+0x7e/0x83
> > > > > 
> > > > > 
> > > > > Code: f0 ff 0f 79 09 f3 90 83 3f 00 7e f9 eb f2 c3 f0 81 2f 00 00
> > > > > RIP  [<ffffffff8025bada>] _spin_lock+0x0/0xf
> > > > >  RSP <ffff8101c50a5a50>
> > > > > CR2: 0000000000000008
> > > > 
> > > > I assume 2.6.20 is OK?
> > > Can't say for sure, I expect yes.
> > > Set up with 2.6.20 now and let it run for a day or two.
> > > Maybe someone has worked in that area and has an idea meanwhile...
> > 
> > Do we have any idea on what was being opened here?
> > Might be useful to see the autofs maps if possible.
> I sent that stuff to Ian...
> 
> However, I couldn't run into that with 2.6.20 and also not with
> *2.6.21-rc3* (yet). Maybe it already got fixed?
> Machine still running, I'll report back if this should happen again.

I suspect the problem is still present but maybe a bit hard to trigger.
I'm not convinced this is needed but it is the only thing that looks at 
all suspicious so if (when) you see this again could you give the patch 
below a try please.

Ian

---

--- linux-2.6.21-rc3/fs/autofs4/root.c.sbi-check	2007-03-12 13:29:42.000000000 +0900
+++ linux-2.6.21-rc3/fs/autofs4/root.c	2007-03-12 13:30:04.000000000 +0900
@@ -503,6 +503,9 @@ static struct dentry *autofs4_lookup_unh
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
+	if (!sbi)
+		return NULL;
+
 	spin_lock(&dcache_lock);
 	spin_lock(&sbi->rehash_lock);
 	head = &sbi->rehash_list;
