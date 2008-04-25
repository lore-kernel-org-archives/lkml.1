Return-Path: <linux-kernel-owner+w=401wt.eu-S933628AbYDYTGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628AbYDYTGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764861AbYDYSou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:44:50 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53314 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765216AbYDYSor convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:44:47 -0400
Message-Id: <1209149086.433.1249904351@webmail.messagingengine.com>
X-Sasl-Enc: oIXDdFlkkztV8JU73KoVg+1XNafWc1VtQzb2u3QRyCsY 1209149086
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Eric Dumazet" <dada1@cosmosbay.com>, "David Chinner" <dgc@sgi.com>,
       xfs-masters@oss.sgi.com
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "lkml" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080425090901.ca642c4d.randy.dunlap@oracle.com>
   <48121331.1030204@cosmosbay.com>
   <1209145675.2005.1249890339@webmail.messagingengine.com>
   <48121A37.5020504@cosmosbay.com>
   <20080425191830.GA4898@martell.zuzino.mipt.ru>
Subject: Re: [PATCH] xfs: remove xfs_log_ticket_zone on rmmod
In-Reply-To: <20080425191830.GA4898@martell.zuzino.mipt.ru>
Date: Fri, 25 Apr 2008 20:44:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 25 Apr 2008 23:18:30 +0400, "Alexey Dobriyan"
<adobriyan@gmail.com> said:
> >>>> Pid: 20926, comm: cat Not tainted 2.6.25-git5 #1
> >>>> RIP: 0010:[<ffffffff80357aac>]  [<ffffffff80357aac>] strnlen+0x15/0x1f
> >>>> RSP: 0018:ffff810274981cc8  EFLAGS: 00010297
> >>>> RAX: ffffffffa00b7551 RBX: ffff810274981d38 RCX: ffffffff80603719
> >>>> RDX: ffff810274981d68 RSI: fffffffffffffffe RDI: ffffffffa00b7551
> >>>> RBP: ffff810274981cc8 R08: 00000000ffffffff R09: 00000000000000c8
> >>>> R10: 0000000000000050 R11: 0000000000000246 R12: ffff8102364600cc
> >>>> R13: ffffffffa00b7551 R14: 0000000000000011 R15: 0000000000000010
> >>>> FS:  00007f956375d6f0(0000) GS:ffff81027f808980(0000) 
> >>>> knlGS:00000000f7f7f6c0
> >>>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >>>> CR2: ffffffffa00b7551 CR3: 00000002734d5000 CR4: 00000000000006e0
> >>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> >>>> Process cat (pid: 20926, threadinfo ffff810274980000, task 
> >>>> ffff81026d18ce20)
> >>>> Stack:  ffff810274981d28 ffffffff80358d5a ffff810274981d28 
> >>>> 0000000000000f34
> >>>>  ffff8102364600cc ffff810236461000 ffffffff80603719 ffff81024ac14f00
> >>>>  ffff81024ac14f00 0000000000000004 0000000000000000 0000000000000000
> >>>> Call Trace:
> >>>>  [<ffffffff80358d5a>] vsnprintf+0x31b/0x592
> >>>>  [<ffffffff802a78eb>] seq_printf+0x7e/0xa7
> >>>>  [<ffffffff8024c6fe>] ? debug_mutex_free_waiter+0x46/0x4a
> >>>>  [<ffffffff8053aaa2>] ? __down_read+0x17/0x92
> >>>>  [<ffffffff80539c25>] ? __mutex_lock_slowpath+0x1d8/0x1e5
> >>>>  [<ffffffff802886c2>] ? count_partial+0x45/0x4d
> >>>>  [<ffffffff80289a6d>] s_show+0x7e/0xcb
> >>>>  [<ffffffff802a7dd9>] seq_read+0x10b/0x298
> >>>>  [<ffffffff802c7dbb>] proc_reg_read+0x7b/0x95
> >>>>  [<ffffffff8028ec0b>] vfs_read+0xab/0x154
> >>>>  [<ffffffff8028f015>] sys_read+0x47/0x6f
> >>>>  [<ffffffff8020c182>] tracesys+0xd5/0xda
> >>>>
> >>>>
> >>>> Code: 48 8d 44 11 ff 40 38 30 74 0a 48 ff c8 48 39 d0 73 f3 31 c0 c9 c3 
> >>>> 55 48 89 f8 48 89 e5 eb 03 48 ff c0 48 ff ce 48 83 fe ff 74 05 <80> 38 
> >>>> 00 75 ef c9 48 29 f8 c3 55 31 c0 48 89 e5 eb 13 41 38 c8 RIP  
> >>>> [<ffffffff80357aac>] strnlen+0x15/0x1f
> >>>>  RSP <ffff810274981cc8>
> >>>> CR2: ffffffffa00b7551
> >>>>
> >>>>
> >>>> ---
> >>>>
> >>>>         
> >>> My initial thoughts are :
> >>>
> >>> Fault address is  0xffffffffa00b7551 which is in module mapping space on 
> >>> x86_64
> >>>
> >>> strnlen() is OK
> >>>
> >>> Some module created a kmem_cache (with kmem_cache_create()).
> >>> slub or slab kept a pointer to the cache name in their internal
> >>> structures.
> >>> Module was unloaded but forgot to destroy kmem cache before unloading.
> >>>
> >>> Fault happens while doing "cat /proc/slabinfo", when trying to 
> >>> dereference cache name since module was unloaded and its memory unmapped.
> >>>
> >>> Next step is to find which module was unloaded ...
> >>>     
> >>
> >> The last one was reiserfs, apparently ;).
> 
> Which doesn't mean anything ;-)

It was a filesystem, though :-/.

> >>   
> > Yes but reiserfs correctly destroys its cache at unload time.
> >
> > Must be something else...
> 
> 
> [PATCH] xfs: remove xfs_log_ticket_zone on rmmod
> 
> Bug introduces in commit eb01c9cd87c7a9998c2edf209721ea069e3e3652
> aka "[XFS] Remove the xlog_ticket allocator"
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  fs/xfs/xfs_vfsops.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/fs/xfs/xfs_vfsops.c
> +++ b/fs/xfs/xfs_vfsops.c
> @@ -186,6 +186,7 @@ xfs_cleanup(void)
>  	kmem_zone_destroy(xfs_efi_zone);
>  	kmem_zone_destroy(xfs_ifork_zone);
>  	kmem_zone_destroy(xfs_ili_zone);
> +	kmem_zone_destroy(xfs_log_ticket_zone);
>  }
>  
>  /*
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - And now for something completely different…

