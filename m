Return-Path: <linux-kernel-owner+w=401wt.eu-S964960AbXDJMC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960AbXDJMC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 08:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965028AbXDJMC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 08:02:26 -0400
Received: from mail.musicgenome.com ([212.150.69.147]:40170 "EHLO
	mail.musicgenome.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964960AbXDJMCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 08:02:25 -0400
Date: Tue, 10 Apr 2007 14:54:32 +0300
From: Tal Kelrich <tal@musicgenome.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.4] Watchdog w83977ef (Winbond W83977EF) driver
Message-ID: <20070410145432.2f828382@shodan.orpak.com>
In-Reply-To: <20070402053834.GC943@1wt.eu>
References: <20070401171407.0e99d86a@shodan.orpak.com>
	<20070402053834.GC943@1wt.eu>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.6.10; i686-redhat-linux-gnu)
X-Habeas-SWE-1: winter into spring
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=MP_G63CFCFd4M9SovVrPi71_Qd
X-Musicgenome-MailScanner-Information: Please contact the ISP for more information
X-Musicgenome-MailScanner: Found to be clean
X-Musicgenome-MailScanner-SpamCheck: not spam, SpamAssassin (score=-5.899,
	required 6, autolearn=not spam, ALL_TRUSTED -3.30, BAYES_00 -2.60)
X-Musicgenome-MailScanner-From: tal@musicgenome.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_G63CFCFd4M9SovVrPi71_Qd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 2 Apr 2007 07:38:34 +0200
Willy Tarreau <w@1wt.eu> wrote:

> Hello,
> 
> On Sun, Apr 01, 2007 at 05:14:07PM +0300, Tal Kelrich wrote:
> > (resent due to mailer stupidity)
> > Hello,
> > 
> > This is my first submitted kernel patch, please be gentle.
> > 
> > Tested and working on AAEON GENE-6310B Subcompact Board
> > (also configured for same by default, should work elsewhere)
> > patch is against kernel 2.4.34.2
> > 
> > Changes/Features:
> > 
> > Added ioctl support
> > Disables watchdog on driver load
> > Supports timeout in seconds
> > Timeout defaults to 2 minutes
> > No longer under NetWinder arch
> > Configurable output GP (defaults to GP16)
> > Configurable base IO address
> > Non standard read only proc interface for status (/proc/watchdog)
> > 
> > Caveats:
> > 
> > No idea if this breaks netwinder, although it really shouldn't
> > Only tested with GP16
> > Utterly ignores inability to get its IO port, mostly because it's
> > already taken. I didn't know a way around that.
> > release_region is called regardless of having acquired the region,
> > this might be trouble.
> 
> While I have no particular problem merging your other driver since it
> did not previously exist, I don't like much this one being massively
> changed like this, particularly when you cannot test whether it breaks
> its original platform (netwinder). I've also noticed that your patch
> removes some locking, so I'm even doubting that it will not break
> NetWinder.
> 
> A less risky solution would be to make a new driver of it (eg:
> w93977.c instead of wdt977.c). Also, if you proceed like this, please
> do not forget to write an entry in Configure.help.
> 
> Regards,
> Willy
> 

Updated with your comments in mind,
now a seperate driver, added info to Configure.help

Regards,
	Tal Kelrich

-- 
Tal Kelrich
PGP fingerprint: 3EDF FCC5 60BB 4729 AB2F  CAE6 FEC1 9AAC 12B9 AA69
Key Available at: http://www.hasturkun.com/pub.txt
----
"I'm a mean green mother from outer space"
 -- Audrey II, The Little Shop of Horrors
----

--MP_G63CFCFd4M9SovVrPi71_Qd
Content-Type: text/x-patch; name=linux-2.4.34.2-w83977ef.patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=linux-2.4.34.2-w83977ef.patch

--- linux-2.4.34.2/Documentation/Configure.help	Sat Mar 24 08:44:54 2007
+++ linux-2.4.34.2-w83977ef/Documentation/Configure.help	Tue Apr 10 13:30:3=
0 2007
@@ -20559,6 +20559,13 @@
   computer, say `Y' here to support its built-in watchdog timer
   feature.  See the help for CONFIG_WATCHDOG for discussion.
=20
+Winbond W83977EF Watchdog Timer
+CONFIG_W83977EF_WDT
+   This is a driver for the hardware watchdog on the W83977EF chipset.
+   To compile this driver as a module say M here. The module will be
+   named wdt83977.o
+   Most people will say N.
+
 ALi M7101 Watchdog Timer
 CONFIG_ALIM7101_WDT
   This is the driver for the hardware watchdog on the ALi M7101 PMU
--- linux-2.4.34.2/drivers/char/Config.in	Sat Mar 24 08:44:54 2007
+++ linux-2.4.34.2-w83977ef/drivers/char/Config.in	Tue Apr 10 13:30:31 2007
@@ -276,6 +276,7 @@
    if [ "$CONFIG_8xx" =3D "y" ]; then
       tristate '  MPC8xx Watchdog Timer' CONFIG_8xx_WDT
    fi
+   tristate '  Winbond W83977EF Watchdog Timer' CONFIG_W83977EF_WDT
 fi
 endmenu
=20
--- linux-2.4.34.2/drivers/char/Makefile	Sat Mar 24 08:44:54 2007
+++ linux-2.4.34.2-w83977ef/drivers/char/Makefile	Tue Apr 10 13:30:31 2007
@@ -323,6 +323,7 @@
 obj-$(CONFIG_SOFT_WATCHDOG) +=3D softdog.o
 obj-$(CONFIG_INDYDOG) +=3D indydog.o
 obj-$(CONFIG_8xx_WDT) +=3D mpc8xx_wdt.o
+obj-$(CONFIG_W83977EF_WDT) +=3D wdt83977.o
=20
 subdir-$(CONFIG_MWAVE) +=3D mwave
 ifeq ($(CONFIG_MWAVE),y)
--- linux-2.4.34.2/drivers/char/wdt83977.c	Thu Jan  1 02:00:00 1970
+++ linux-2.4.34.2-w83977ef/drivers/char/wdt83977.c	Tue Apr 10 13:30:31 2007
@@ -0,0 +1,350 @@
+/*
+ *	Wdt83977 0.03:	A Watchdog Device for Winbond W83977EF chip
+ *	(c) Copyright 2007 Orpak Systems Ltd. (Tal Kelrich <tal@orpak.com>)
+ *	based on wdt977 driver by Woody Suwalski <woody@netwinder.org>
+ *
+ *	(c) Copyright 1998 Rebel.com (Woody Suwalski <woody@netwinder.org>)
+ *
+ *			-----------------------
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ */
+=20
+#include <linux/module.h>
+#include <linux/config.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/init.h>
+#include <linux/smp_lock.h>
+#include <linux/ioport.h>
+#include <linux/spinlock.h>
+#include <linux/watchdog.h>
+#include <linux/proc_fs.h>
+
+#include <asm/io.h>
+#include <asm/system.h>
+#include <asm/uaccess.h>
+#include <asm/page.h>
+
+#define WATCHDOG_MINOR	130
+
+static	int timeout =3D 120;
+static	int timer_alive;
+static	int expect_close =3D 0;
+static spinlock_t wdt_lock;
+
+/* port is either 0X370 or 0x3F0. there's probably no way to detect this */
+static int wdt_io =3D 0x370;
+
+#ifdef CONFIG_WATCHDOG_NOWAYOUT
+static int nowayout =3D 1;
+#else
+static int nowayout =3D 0;
+#endif
+
+static int whichgp =3D 16;
+
+MODULE_PARM(wdt_io,"i");
+MODULE_PARM_DESC(wdt_io,"WDT io port base (0x370/0x3F0)");
+
+MODULE_PARM(whichgp,"i");
+MODULE_PARM_DESC(whichgp,"which gp? (12/13/16)");
+
+MODULE_PARM(timeout,"i");
+
+MODULE_PARM(nowayout,"i");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (defau=
lt=3DCONFIG_WATCHDOG_NOWAYOUT)");
+
+#define WDT_EFER (wdt_io+0)   /* Extended Function Enable Registers */
+#define WDT_EFIR (wdt_io+0)   /* Extended Function Index Register (same as=
 EFER) */
+#define WDT_EFDR (WDT_EFIR+1) /* Extended Function Data Register */
+
+#define WDT_OUT(reg,data) {outb_p(reg,WDT_EFIR);outb_p(data,WDT_EFDR);}
+#define WDT_IN(reg,out) {outb_p(reg,WDT_EFIR);out=3Dinb_p(WDT_EFDR);}
+#define WDT_DEV(device) {WDT_OUT(0x07,device);}
+#define WDT_ENABLE	{outb_p(0x87,WDT_EFER);outb_p(0x87,WDT_EFER);}
+#define WDT_DISABLE	{outb_p(0xAA,WDT_EFER);}
+
+static int wdt977_readproc(char *page, char **start, off_t off, int count,
+		int *eof, void *data)
+{
+	int len;
+	unsigned char remaining;
+	unsigned char fired;
+	spin_lock(&wdt_lock);
+	WDT_ENABLE;
+	WDT_DEV(0x08);
+	WDT_IN(0xF2,remaining); /* get remaining time */
+	WDT_IN(0xF4,fired); /* and some nice status bits */
+	/* and clear the bit we care about */
+	WDT_OUT(0xF4,fired&(~0x01));
+	WDT_DISABLE;
+	spin_unlock(&wdt_lock);
+	fired=3Dfired & 0x01;
+	len=3Dsnprintf(page,PAGE_SIZE,
+			"W83977EF device\n"
+			"active=3D%d\n"
+			"iobase=3D%0X\n"
+			"gp=3D%d\n"
+			"nowayout=3D%d\n"
+			"timeout=3D%d\n"
+			"remaining=3D%d\n"
+			"fired=3D%d\n",
+			timer_alive,wdt_io,whichgp,nowayout,timeout,remaining,fired);
+	*eof=3D1;
+	return len;
+}
+
+static void wdt977_ctrl(int timeout)
+{
+	unsigned char status;
+	spin_lock(&wdt_lock);
+	WDT_ENABLE;
+	WDT_DEV(0x08);
+	WDT_OUT(0x30,0x01); /* enable */
+	WDT_OUT(0xF2,timeout);
+	WDT_IN(0xF4, status); /* so we don't set bit 0 */
+	WDT_OUT(0xF4,(status&0x01)|0x40); /* and seconds! */
+	WDT_DISABLE;
+	spin_unlock(&wdt_lock);
+}
+
+/*
+ *	Allow only one person to hold it open
+ */
+
+static int wdt977_open(struct inode *inode, struct file *file)
+{
+	if(timer_alive)
+		return -EBUSY;
+	if (nowayout) {
+		MOD_INC_USE_COUNT;
+	}
+	timer_alive++;
+
+	//max timeout value =3D 255 minutes (0xFF). Write 0 to disable WatchDog.
+	if (timeout>255 || timeout <1)
+	    timeout =3D 255;
+
+	printk(KERN_INFO "Watchdog: active, current timeout %d min.\n",timeout);
+
+	wdt977_ctrl(timeout);
+	return 0;
+}
+
+static int wdt977_release(struct inode *inode, struct file *file)
+{
+	/*
+	 *	Shut off the timer.
+	 * 	Lock it in if it's a module and we set nowayout
+	 */
+	if (expect_close) {
+		wdt977_ctrl(0); /* disable timer */
+		printk(KERN_INFO "Watchdog: shutdown.\n");
+	} else {
+		printk(KERN_CRIT "WDT device closed unexpectedly.  WDT will not stop!\n"=
);
+	}
+
+	timer_alive=3D0;
+
+	return 0;
+}
+
+static ssize_t wdt977_write(struct file *file, const char *data, size_t le=
n, loff_t *ppos)
+{
+	/*  Can't seek (pwrite) on this device  */
+	if (ppos !=3D &file->f_pos)
+		return -ESPIPE;
+	if (!nowayout) {
+		size_t i;
+
+		/* In case it was set long ago */
+		expect_close =3D 0;
+
+		for (i =3D 0; i !=3D len; i++) {
+			char c;
+			if (get_user(c, data + i))
+				return -EFAULT;
+			if (c =3D=3D 'V')
+				expect_close =3D 1;
+		}
+	}
+
+	//max timeout value =3D 255 minutes (0xFF). Write 0 to disable WatchDog.
+	if (timeout>255)
+	    timeout =3D 255;
+
+	/*
+	 *	Refresh the timer.
+	 */
+
+	wdt977_ctrl(timeout);=09
+=09
+	return 1;
+}
+
+static int wdt977_ioctl(struct inode *inode, struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	int new_timeout;
+	static struct watchdog_info ident =3D {
+		.options =3D WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
+		.firmware_version =3D 1,
+		.identity =3D "WDT83977 WDT",
+	};
+	void *argp =3D (void *)arg;
+	int *p =3D argp;
+	switch (cmd)
+	{
+		case WDIOC_GETSUPPORT:
+			if(copy_to_user(argp, &ident, sizeof(ident)))
+				return -EFAULT;
+			break;
+
+		case WDIOC_GETSTATUS:
+			return put_user(timer_alive, p);
+
+		case WDIOC_KEEPALIVE:
+			wdt977_ctrl(timeout);
+		=09
+		case WDIOC_SETTIMEOUT:
+			if(get_user(new_timeout, p))
+				return -EFAULT;
+			if(new_timeout>255 || new_timeout < 1)
+				return -EINVAL;
+			timeout=3Dnew_timeout;
+			wdt977_ctrl(timeout);
+			/* FALLTHROUGH */
+		=09
+		case WDIOC_GETTIMEOUT:
+			return put_user(timeout,p);
+
+		case WDIOC_SETOPTIONS:
+			{
+				int options, retval =3D -EINVAL;
+				if(get_user(options, p))
+					return -EFAULT;
+
+				if(options & WDIOS_DISABLECARD)
+				{
+					wdt977_ctrl(0);
+					retval =3D 0;
+				}
+				if(options & WDIOS_ENABLECARD)
+				{
+					wdt977_ctrl(timeout);
+					retval =3D 0;
+				}
+				return retval;
+			}
+		default:
+			return -ENOTTY;
+	}
+	return 0;
+}
+
+static struct file_operations wdt977_fops=3D
+{
+	owner:		THIS_MODULE,
+	write:		wdt977_write,
+	open:		wdt977_open,
+	release:	wdt977_release,
+	ioctl:		wdt977_ioctl,
+};
+
+static struct miscdevice wdt977_miscdev=3D
+{
+	WATCHDOG_MINOR,
+	"watchdog",
+	&wdt977_fops
+};
+
+static int __init nwwatchdog_init(void)
+{
+	unsigned char status;
+	int ret;
+	spin_lock_init(&wdt_lock);
+	ret =3D misc_register(&wdt977_miscdev);
+	if(ret !=3D 0)
+		goto out;
+	if(!request_region(wdt_io, 1, "W83977EF"))
+	{
+		/* Failure to get region is because on the board I was working on, wdt_i=
o is
+		 * consistently in use. there's probably a better solution to this */
+		printk(KERN_WARNING "W83977EF: IO address %04X already in use, continuin=
g anyway\n",wdt_io);
+	}
+	if(!create_proc_read_entry("watchdog",0,NULL,&wdt977_readproc,NULL))
+		goto unreg_misc;
+	WDT_ENABLE;
+	/* select dev 7 */
+	WDT_DEV(0x07);
+	/* activate it */
+	WDT_OUT(0x30,0x01);
+	switch(whichgp)
+	{
+		case 12:
+			ret=3D0xE2;
+			break;
+		case 13:
+			ret=3D0xE3;
+			break;
+		default:
+			whichgp=3D16;
+		case 16:
+			ret=3D0xE6;
+			break;
+	}
+	WDT_OUT(ret,0x0A);
+	/* select dev 8 */
+	WDT_DEV(0x08);
+	/* enable it */
+	WDT_OUT(0x30,0x01);
+	/* power led cycle on wdog timeout */
+	WDT_OUT(0xF3,0x08);
+	switch(whichgp)
+	{
+		case 12:
+			WDT_IN(0x2A,ret); /* sets ret */
+			WDT_OUT(0x2A,ret|0x80); /* sets GP12 on */
+			break;
+		case 13:
+			WDT_IN(0x2B,ret);
+			WDT_OUT(0x2B,ret|0x01);
+			break;
+		case 16:
+			WDT_IN(0x2C,ret);
+			WDT_OUT(0x2C,ret|0x10);
+			break;
+	}
+	/* set timer to 0 initially */
+	WDT_OUT(0xF2,0);
+	WDT_IN(0xF4, status); /* so we don't set bit 0 by accident */
+	WDT_OUT(0xF4,(status&0x01)|0x40); /* bit 6 for seconds! */
+	WDT_DISABLE;
+	printk(KERN_INFO "W83977EF: initialized, using port %x, GP%d. timeout=3D%=
d nowayout=3D%d\n",wdt_io,whichgp,timeout,nowayout);
+	return 0;
+unreg_misc:
+	misc_deregister(&wdt977_miscdev);
+out:
+	return ret;
+}=09
+
+static void __exit nwwatchdog_exit(void)
+{
+	remove_proc_entry("watchdog",NULL);
+	misc_deregister(&wdt977_miscdev);
+	release_region(wdt_io,2);
+	/* we might not have gotten it... is this safe? */
+}
+
+EXPORT_NO_SYMBOLS;
+
+module_init(nwwatchdog_init);
+module_exit(nwwatchdog_exit);
+
+MODULE_LICENSE("GPL");

--MP_G63CFCFd4M9SovVrPi71_Qd--
