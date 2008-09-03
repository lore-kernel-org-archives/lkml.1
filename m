Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYICGiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYICGiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbYICGiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:38:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184AbYICGiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:38:15 -0400
Date: Tue, 2 Sep 2008 23:37:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: remove unused variable canon_change
Message-Id: <20080902233738.a5509cad.akpm@linux-foundation.org>
In-Reply-To: <1220390841.2137.10.camel@brick>
References: <1220390841.2137.10.camel@brick>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2008 14:27:21 -0700 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> drivers/char/tty_ioctl.c: In function ___change_termios___:
> drivers/char/tty_ioctl.c:492: warning: unused variable ___canon_change___
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> new warning in next-20080902
> 
>  drivers/char/tty_ioctl.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
> index 17e6a98..a408c8e 100644
> --- a/drivers/char/tty_ioctl.c
> +++ b/drivers/char/tty_ioctl.c
> @@ -489,7 +489,6 @@ EXPORT_SYMBOL(tty_termios_hw_change);
>  
>  static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
>  {
> -	int canon_change;
>  	struct ktermios old_termios;
>  	struct tty_ldisc *ld;
>  	unsigned long flags;

I cannot find the patch which added the canon_change stuff on a mailing
list.  If I could, I'd reply to that.


It goes oops.  config is at http://userweb.kernel.org/~akpm/config-vmm.txt


From: Andrew Morton <akpm@linux-foundation.org>

BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c02afc15>] n_tty_set_termios+0x15/0x340
*pde = 00000000 
Oops: 0000 [#1] SMP 
last sysfs file: 
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in:

Pid: 1, comm: swapper Tainted: G        W (2.6.27-rc5-mm1 #2)
EIP: 0060:[<c02afc15>] EFLAGS: 00010282 CPU: 0
EIP is at n_tty_set_termios+0x15/0x340
EAX: f709cdd0 EBX: f709cdd0 ECX: f64cd468 EDX: 00000000
ESI: 00000000 EDI: f60ee000 EBP: f702fdf4 ESP: f702fde8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f702e000 task=f702d210 task.ti=f702e000)
Stack: f709cdd0 f709cdd0 f60ee000 f702fe04 c02b0299 f7095070 f709cdd0 f702fe18 
       c02b3493 f7095070 f709cdd0 00000000 f702fe3c c02ae9b5 f7095070 f702fe60 
       00000000 fffffff4 f7095070 00000000 00500001 f702fe70 c02aedeb f707d078 
Call Trace:
 [<c02b0299>] ? n_tty_open+0x49/0xa0
 [<c02b3493>] ? tty_ldisc_setup+0x23/0x80
 [<c02ae9b5>] ? tty_init_dev+0x85/0x150
 [<c02aedeb>] ? tty_open+0x36b/0x440
 [<c01940fa>] ? chrdev_open+0x9a/0x190
 [<c018fded>] ? __dentry_open+0xad/0x230
 [<c0190d90>] ? nameidata_to_filp+0x50/0x60
 [<c0194060>] ? chrdev_open+0x0/0x190
 [<c019c41a>] ? do_filp_open+0x19a/0x700
 [<c01158a9>] ? cpa_fill_pool+0x99/0x120
 [<c01a4706>] ? alloc_fd+0x26/0xf0
 [<c01a47af>] ? alloc_fd+0xcf/0xf0
 [<c03e159d>] ? _spin_unlock+0x1d/0x20
 [<c018fc0b>] ? do_sys_open+0x4b/0xd0
 [<c0126e5b>] ? printk+0x1b/0x20
 [<c018fcf9>] ? sys_open+0x29/0x40
 [<c01011b7>] ? init_post+0x47/0x140
 [<c0103fff>] ? kernel_thread_helper+0x7/0x18
 =======================

tty->termios is NULL.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN drivers/char/n_tty.c~a drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~a
+++ a/drivers/char/n_tty.c
@@ -1039,20 +1039,8 @@ int is_ignored(int sig)
 
 static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
-	int canon_change;
 	BUG_ON(!tty);
 
-	canon_change = (old->c_lflag ^ tty->termios->c_lflag) & ICANON;
-	if (canon_change) {
-		memset(&tty->read_flags, 0, sizeof tty->read_flags);
-		tty->canon_head = tty->read_tail;
-		tty->canon_data = 0;
-		tty->erasing = 0;
-	}
-
-	if (canon_change && !L_ICANON(tty) && tty->read_cnt)
-		wake_up_interruptible(&tty->read_wait);
-
 	tty->icanon = (L_ICANON(tty) != 0);
 	if (test_bit(TTY_HW_COOK_IN, &tty->flags)) {
 		tty->raw = 1;
_

