Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbZCaNIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbZCaNIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbZCaNHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:07:37 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:20402 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162AbZCaNHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w9K6w8sjyB5fSkAgGc6KB9TaRavB+tDHGQGTw1PybsAXlmusAtCJyNm72+yFa+ZLut
         XA0yefOTDDDlkwjnIxwdqshHoiyKagf5RA2vsHWjXqyshi+uUehEc2fHwEfEyn9NDAt3
         BYZFhqYtWIv+hhCZapul6pVUMKPBVDl8+i2BQ=
MIME-Version: 1.0
In-Reply-To: <20090331084546.6b24d66e@tleilax.poochiereds.net>
References: <20090331084546.6b24d66e@tleilax.poochiereds.net>
Date: Tue, 31 Mar 2009 08:07:34 -0500
Message-ID: <4a4634330903310607t2b09715di79cb31fc40648d8@mail.gmail.com>
Subject: Re: [linux-cifs-client] consistent oops from request_key in 2.6.29
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: dhowells@redhat.com, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 7:45 AM, Jeff Layton <jlayton@redhat.com> wrote:
> I've started seeing a consistent oops in recent rawhide kernels when I
> try to do CIFS mounts with krb5 auth:
>
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
> IP: [<ffffffff8102bf4c>] __ticket_spin_trylock+0x4/0x21
> PGD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/pci0000:00/0000:00:04.0/local_cpus
> CPU 1
> Modules linked in: nls_utf8 cifs sunrpc ipv6 dm_multipath uinput 8139too 8139cp i2c_piix4 mii i2c_core pcspkr ata_generic pata_acpi [last unloaded: freq_table]
> Pid: 2255, comm: mount.cifs Tainted: G        W  2.6.29-16.fc11.x86_64 #1 HVM domU
> RIP: 0010:[<ffffffff8102bf4c>]  [<ffffffff8102bf4c>] __ticket_spin_trylock+0x4/0x21
> RSP: 0018:ffff8800370ab9d0  EFLAGS: 00010096
> RAX: ffff88003d0d23c0 RBX: 0000000000000030 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000030
> RBP: ffff8800370ab9d0 R08: 0000000000000002 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000030
> R13: 0000000000000292 R14: ffff880037088000 R15: ffffffff81597ad0
> FS:  00007fa0e7fe56f0(0000) GS:ffff88003ea4b320(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000030 CR3: 00000000370c7000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process mount.cifs (pid: 2255, threadinfo ffff8800370aa000, task ffff88003d0d23c0)
> Stack:
>  ffff8800370ab9e8 ffffffff811a2af9 0000000000000048 ffff8800370aba28
>  ffffffff81399014 ffffffff8119ce86 ffffffff8116470a 0000000000000000
>  0000000000000030 0000000000000028 ffffffffa01292a0 ffff8800370aba48
> Call Trace:
>  [<ffffffff811a2af9>] _raw_spin_trylock+0xd/0x2d
>  [<ffffffff81399014>] _spin_lock_irqsave+0x59/0x8b
>  [<ffffffff8119ce86>] ? __down_write_trylock+0x16/0x4f
>  [<ffffffff8116470a>] ? request_key_and_link+0x220/0x3d5
>  [<ffffffff8119ce86>] __down_write_trylock+0x16/0x4f
>  [<ffffffff81397a9c>] down_write+0x54/0x7f
>  [<ffffffff8116470a>] ? request_key_and_link+0x220/0x3d5
>  [<ffffffff8116470a>] request_key_and_link+0x220/0x3d5
>  [<ffffffff8119ec8d>] ? vsnprintf+0x2e7/0x4ed
>  [<ffffffff81164992>] request_key+0x41/0x72
>  [<ffffffffa010f8e5>] cifs_get_spnego_key+0x189/0x1b4 [cifs]
>  [<ffffffffa010e4a0>] CIFS_SessSetup+0x442/0xb1e [cifs]
>  [<ffffffffa00f91c9>] cifs_setup_session+0x119/0xb61 [cifs]
>  [<ffffffff81398cc6>] ? _spin_unlock_irqrestore+0x48/0x58
>  [<ffffffff81070acd>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffffa00fd5b6>] cifs_mount+0x17a7/0x1f2b [cifs]
>  [<ffffffff810dd173>] ? __kmalloc+0x10b/0x149
>  [<ffffffffa00ee8ab>] cifs_get_sb+0x110/0x26a [cifs]
>  [<ffffffff810e71a9>] vfs_kern_mount+0xa3/0x13c
>  [<ffffffff810e72aa>] do_kern_mount+0x4d/0xe8
>  [<ffffffff810fbe0b>] do_mount+0x744/0x790
>  [<ffffffff811a2ed2>] ? _raw_spin_lock+0x65/0x111
>  [<ffffffff810fbee9>] sys_mount+0x92/0xd5
>  [<ffffffff8101133a>] system_call_fastpath+0x16/0x1b
> Code: 1b fb ff ff c9 c3 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 0f b7 d0 c1 e8 10 39 c2 74 07 f3 90 0f b7 17 eb f5 c9 c3 55 48 89 e5 <8b> 07 89 c2 c1 c0 10 39 c2 8d 90 00 00 01 00 75 04 f0 0f b1 17
> RIP  [<ffffffff8102bf4c>] __ticket_spin_trylock+0x4/0x21
>  RSP <ffff8800370ab9d0>
> CR2: 0000000000000030
> ---[ end trace cee083cffbca031b ]---
>
>
> ...we call request_key from CIFS which calls request_key_and_link
> with a NULL dest_keyring. Eventually this calls construct_alloc_key
> with the NULL dest_keyring. The following patch seems to have changed
> it so that it's no longer safe to call construct_alloc_key this way:
>
> commit 8bbf4976b59fc9fc2861e79cab7beb3f6d647640
> Author: David Howells <dhowells@redhat.com>
> Date:   Fri Nov 14 10:39:14 2008 +1100
>
>    KEYS: Alter use of key instantiation link-to-keyring argument
>
>
> ...but request_key was never fixed so that it doesn't do this. It's
> unclear to me what the correct fix is. Do we need to put the checks for
> a NULL dest_keyring back into construct_alloc_key or fix request_key
> to call request_key_and_link with a dest_keyring?
>
> Thanks,
> --
> Jeff Layton <jlayton@redhat.com>
> _______________________________________________
> linux-cifs-client mailing list
> linux-cifs-client@lists.samba.org
> https://lists.samba.org/mailman/listinfo/linux-cifs-client
>


I have see that earlier too.  This is the comment from David during
that converstaion.

"Assuming:

       printk("%s,%s,%p,%zu,%p,%p,%lx\n",
              type->name, description, callout_info, callout_len, aux,
              dest_keyring, flags);

produced:

> dns_resolver,cifstest8.,ffffffffa03323a9,0,(null),(null),0

then I'd say that the oops is because dest_keyring is NULL.

Let me think about why this is.
"
