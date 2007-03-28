Return-Path: <linux-kernel-owner+w=401wt.eu-S932887AbXC1UuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbXC1UuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933264AbXC1UuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:50:23 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59302 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932887AbXC1UuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:50:22 -0400
Date: Wed, 28 Mar 2007 13:50:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, Maneesh Soni <maneesh@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: 2.6.21-rc5-mm2 OOPS and spinlock lockup
Message-Id: <20070328135012.a11b1e02.akpm@linux-foundation.org>
In-Reply-To: <1175113216.7466.6.camel@localhost>
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
	<1175113216.7466.6.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 14:20:16 -0600
Zan Lynx <zlynx@acm.org> wrote:

> On Mon, 2007-03-26 at 21:16 -0800, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/
> > 
> > 
> > - This is the same as 2.6.12-rc5-mm1, except the staircase deadline CPU
> >   scheduler has been added.
> 
> Here is the last bit of netconsole dump I had from my laptop when the
> kernel died just now.
> 
> Note that the kernel is compiled with SMP but the laptop is one core
> only. I have CONFIG_DEBUG_SPINLOCK=y and CONFIG_DEBUG_SPINLOCK_SLEEP=y
> 
> It's AMD-64.
> 
> [ 2597.436421] Hangcheck: hangcheck value past margin!
> [ 2794.356033] Unable to handle kernel NULL pointer dereference at 00000000000000c0 RIP: 
> [ 2794.356058]  [<ffffffff8020761f>] _raw_spin_lock+0x1f/0x140
> [ 2794.356088] PGD 9f39067 PUD 9f38067 PMD 0 
> [ 2794.356180] Oops: 0000 [1] PREEMPT SMP 
> [ 2794.356261] last sysfs file: devices/system/cpu/cpu0/cpufreq/scaling_setspeed
> [ 2794.356328] CPU 0 
> [ 2794.356341] Modules linked in: netconsole nls_iso8859_1 nls_cp437 vfat fat nls_base zaurus cdc_ether usbnet snd_pcm_oss snd_mixer_oss rfcomm hidp hid l2cap ipv6 hci_usb bluetooth usb_storage snd_intel8x0 psmouse serio_raw snd_ac97_codec ac97_bus snd_pcm snd_timer snd snd_page_alloc ehci_hcd ohci_hcd ssb usbcore evdev sg
> [ 2794.357227] Pid: 8049, comm: khidpd_046db3e1 Not tainted 2.6.21-rc5-mm2 #1
> [ 2794.357295] RIP: 0010:[<ffffffff8020761f>]  [<ffffffff8020761f>] _raw_spin_lock+0x1f/0x140
> [ 2794.357318] RSP: 0000:ffff81000d865d10  EFLAGS: 00010282
> [ 2794.357329] RAX: ffff81000d739040 RBX: 00000000000000b8 RCX: 0000000000000000
> [ 2794.357396] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000b8
> [ 2794.357408] RBP: ffff81000e23dd08 R08: 0000000000000002 R09: 0000000000000000
> [ 2794.357422] R10: ffffffff80318019 R11: 2222222222222222 R12: ffff81000e23dd10
> [ 2794.357435] R13: 0000000000000000 R14: ffff81000e16b928 R15: ffff81000b518720
>  [<ffffffff8020761f>] _raw_spin_lock+0x1f/0x140
> [ 2794.359149]  RSP <ffff81000d865d10>
> [ 2794.359214] CR2: 00000000000000c0
> [ 2794.359268] note: khidpd_046db3e1[8049] exited with preempt_count 3
> [ 2804.355026] BUG: soft lockup detected on CPU#0!
> [ 2804.355037] 
> [ 2804.355039] Call Trace:
> [ 2804.355051]  <IRQ>  [<ffffffff802c7659>] softlockup_tick+0xf9/0x140
> [ 2804.355140]  [<ffffffff8029ba37>] update_process_times+0x57/0x90
> [ 2804.355157]  [<ffffffff8027b1e4>] smp_local_timer_interrupt+0x34/0x60
> [ 2804.355171]  [<ffffffff8027b5ba>] smp_send_timer_broadcast_ipi+0x3a/0x60
> [ 2804.355188]  [<ffffffff80271423>] timer_interrupt+0x23/0x30
> [ 2804.355259]  [<ffffffff8020fe0e>] handle_IRQ_event+0x1e/0x60
> [ 2804.355275]  [<ffffffff802c919a>] handle_edge_irq+0xfa/0x150
> [ 2804.355291]  [<ffffffff80270180>] do_IRQ+0x110/0x190
> [ 2804.355306]  [<ffffffff8025f666>] ret_from_intr+0x0/0xf
> [ 2804.355371]  <EOI>  [<ffffffff8024e22c>] shrink_dcache_parent+0x2c/0x120
> [ 2804.355399]  [<ffffffff802076ac>] _raw_spin_lock+0xac/0x140
> [ 2804.355413]  [<ffffffff802076b9>] _raw_spin_lock+0xb9/0x140
> [ 2804.355484]  [<ffffffff8024e22c>] shrink_dcache_parent+0x2c/0x120
> [ 2804.355499]  [<ffffffff80312456>] proc_flush_task+0x76/0x220
> [ 2804.355518]  [<ffffffff80216f56>] release_task+0x316/0x360
> [ 2804.355532]  [<ffffffff8022796f>] do_wait+0x80f/0xc10
> [ 2804.355607]  [<ffffffff80290d90>] default_wake_function+0x0/0x10
> [ 2804.355624]  [<ffffffff8025f11e>] system_call+0x7e/0x83


Thanks.  This might have been caused by fix-sysfs-reclaim-crash.patch,
which I have now dropped.  If you're able to reproduce the crash, please
see if reverting that patch (reproduced below) fixes it.  

If it isn't reproducibl, please keep an eye out for problems in next -mm.


From: Maneesh Soni <maneesh@in.ibm.com>

Maybe.

  happens without i_mutex. It also nullifies s_dentry just to indicate that
  the associated dentry is evicted. sysfs_readdir() access the s_dentry,
  and gets the inode number from the associated dentry, if there is one, else
  it invokes iunique(). This can create a race situation, and crash while
  accessing the dentry/inode in sysfs_readdir().

o The following patch always use i_unique() to get the inode number. This
  is ok as sysfs doesnot have permanent inode numbering. It could be slower
  but avoids the above mentioned race.

o This also avoids the now unnecessary s_dentry in sysfs_d_iput().

Signed-off-by: Maneesh Soni <maneesh@in.ibm.com>
Cc: Ethan Solomita <solo@google.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/sysfs/dir.c~fix-sysfs-reclaim-crash fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~fix-sysfs-reclaim-crash
+++ a/fs/sysfs/dir.c
@@ -20,7 +20,6 @@ static void sysfs_d_iput(struct dentry *
 
 	if (sd) {
 		BUG_ON(sd->s_dentry != dentry);
-		sd->s_dentry = NULL;
 		sysfs_put(sd);
 	}
 	iput(inode);
@@ -538,10 +537,7 @@ static int sysfs_readdir(struct file * f
 
 				name = sysfs_get_name(next);
 				len = strlen(name);
-				if (next->s_dentry)
-					ino = next->s_dentry->d_inode->i_ino;
-				else
-					ino = iunique(sysfs_sb, 2);
+				ino = iunique(sysfs_sb, 2);
 
 				if (filldir(dirent, name, len, filp->f_pos, ino,
 						 dt_type(next)) < 0)
_

