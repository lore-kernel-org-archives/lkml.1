Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbYEPQDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbYEPQDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYEPQD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:03:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42574 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYEPQD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:03:26 -0400
Date: Fri, 16 May 2008 12:03:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] kill empty chardev open/release methods
Message-ID: <20080516160306.GA9103@infradead.org>
References: <alpine.LFD.1.10.0805141452330.3019@woody.linux-foundation.org> <16082.1210952646@vena.lwn.net> <20080516154922.GA25412@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516154922.GA25412@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 11:49:22AM -0400, Christoph Hellwig wrote:
> On Fri, May 16, 2008 at 09:44:06AM -0600, Jonathan Corbet wrote:
> > trivial as to not require locking (quite few of them are "return 0;"), or
> 
> If they literaly are 'return 0' you can just remove them, as a
> non-existing open op will just be fine.

And here's a patch to do just that:  remove all empty chardev
open/release methods.  Based on the list compiled by Jonathan.

(and yeah, ip2_ipl_open is not technically empty at the source level,
 but only at the binary level :))


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/cris/arch-v10/drivers/i2c.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/drivers/i2c.c	2008-05-16 17:58:15.000000000 +0200
+++ linux-2.6/arch/cris/arch-v10/drivers/i2c.c	2008-05-16 17:58:19.000000000 +0200
@@ -563,18 +563,6 @@ i2c_readreg(unsigned char theSlave, unsi
 	return b;
 }
 
-static int
-i2c_open(struct inode *inode, struct file *filp)
-{
-	return 0;
-}
-
-static int
-i2c_release(struct inode *inode, struct file *filp)
-{
-	return 0;
-}
-
 /* Main device API. ioctl's to write or read to/from i2c registers.
  */
 
@@ -619,8 +607,6 @@ i2c_ioctl(struct inode *inode, struct fi
 static const struct file_operations i2c_fops = {
 	.owner    = THIS_MODULE,
 	.ioctl    = i2c_ioctl,
-	.open     = i2c_open,
-	.release  = i2c_release,
 };
 
 int __init
Index: linux-2.6/arch/cris/arch-v32/drivers/i2c.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/drivers/i2c.c	2008-05-16 17:57:56.000000000 +0200
+++ linux-2.6/arch/cris/arch-v32/drivers/i2c.c	2008-05-16 17:58:07.000000000 +0200
@@ -633,18 +633,6 @@ i2c_readreg(unsigned char theSlave, unsi
 	return b;
 }
 
-static int
-i2c_open(struct inode *inode, struct file *filp)
-{
-	return 0;
-}
-
-static int
-i2c_release(struct inode *inode, struct file *filp)
-{
-	return 0;
-}
-
 /* Main device API. ioctl's to write or read to/from i2c registers.
  */
 
@@ -689,8 +677,6 @@ i2c_ioctl(struct inode *inode, struct fi
 static const struct file_operations i2c_fops = {
 	.owner =    THIS_MODULE,
 	.ioctl =    i2c_ioctl,
-	.open =     i2c_open,
-	.release =  i2c_release,
 };
 
 static int __init i2c_init(void)
Index: linux-2.6/drivers/char/ip2/ip2main.c
===================================================================
--- linux-2.6.orig/drivers/char/ip2/ip2main.c	2008-05-16 17:59:17.000000000 +0200
+++ linux-2.6/drivers/char/ip2/ip2main.c	2008-05-16 17:59:37.000000000 +0200
@@ -203,7 +203,6 @@ static int set_serial_info(i2ChanStrPtr,
 static ssize_t ip2_ipl_read(struct file *, char __user *, size_t, loff_t *);
 static ssize_t ip2_ipl_write(struct file *, const char __user *, size_t, loff_t *);
 static int ip2_ipl_ioctl(struct inode *, struct file *, UINT, ULONG);
-static int ip2_ipl_open(struct inode *, struct file *);
 
 static int DumpTraceBuffer(char __user *, int);
 static int DumpFifoBuffer( char __user *, int);
@@ -236,7 +235,6 @@ static const struct file_operations ip2_
 	.read		= ip2_ipl_read,
 	.write		= ip2_ipl_write,
 	.ioctl		= ip2_ipl_ioctl,
-	.open		= ip2_ipl_open,
 }; 
 
 static unsigned long irq_counter = 0;
@@ -2918,58 +2916,6 @@ ip2_ipl_ioctl ( struct inode *pInode, st
 	return rc;
 }
 
-/******************************************************************************/
-/* Function:   ip2_ipl_open()                                                 */
-/* Parameters: Pointer to device inode                                        */
-/*             Pointer to file structure                                      */
-/* Returns:    Success or failure                                             */
-/*                                                                            */
-/* Description:                                                               */
-/*                                                                            */
-/*                                                                            */
-/******************************************************************************/
-static int
-ip2_ipl_open( struct inode *pInode, struct file *pFile )
-{
-	unsigned int iplminor = iminor(pInode);
-	i2eBordStrPtr pB;
-	i2ChanStrPtr  pCh;
-
-#ifdef IP2DEBUG_IPL
-	printk (KERN_DEBUG "IP2IPL: open\n" );
-#endif
-
-	switch(iplminor) {
-	// These are the IPL devices
-	case 0:
-	case 4:
-	case 8:
-	case 12:
-		break;
-
-	// These are the status devices
-	case 1:
-	case 5:
-	case 9:
-	case 13:
-		break;
-
-	// These are the debug devices
-	case 2:
-	case 6:
-	case 10:
-	case 14:
-		pB = i2BoardPtrTable[iplminor / 4];
-		pCh = (i2ChanStrPtr) pB->i2eChannelPtr;
-		break;
-
-	// This is the trace device
-	case 3:
-		break;
-	}
-	return 0;
-}
-
 static int
 proc_ip2mem_show(struct seq_file *m, void *v)
 {
Index: linux-2.6/drivers/isdn/hardware/eicon/divasi.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hardware/eicon/divasi.c	2008-05-16 17:59:59.000000000 +0200
+++ linux-2.6/drivers/isdn/hardware/eicon/divasi.c	2008-05-16 18:00:13.000000000 +0200
@@ -74,7 +74,6 @@ static ssize_t um_idi_read(struct file *
 static ssize_t um_idi_write(struct file *file, const char __user *buf,
 			    size_t count, loff_t * offset);
 static unsigned int um_idi_poll(struct file *file, poll_table * wait);
-static int um_idi_open(struct inode *inode, struct file *file);
 static int um_idi_release(struct inode *inode, struct file *file);
 static int remove_entity(void *entity);
 static void diva_um_timer_function(unsigned long data);
@@ -136,7 +135,6 @@ static const struct file_operations diva
 	.read    = um_idi_read,
 	.write   = um_idi_write,
 	.poll    = um_idi_poll,
-	.open    = um_idi_open,
 	.release = um_idi_release
 };
 
@@ -398,12 +396,6 @@ static unsigned int um_idi_poll(struct f
 	return (POLLIN | POLLRDNORM);
 }
 
-static int um_idi_open(struct inode *inode, struct file *file)
-{
-	return (0);
-}
-
-
 static int um_idi_release(struct inode *inode, struct file *file)
 {
 	diva_um_idi_os_context_t *p_os;
Index: linux-2.6/drivers/isdn/hardware/eicon/divasmain.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hardware/eicon/divasmain.c	2008-05-16 18:00:26.000000000 +0200
+++ linux-2.6/drivers/isdn/hardware/eicon/divasmain.c	2008-05-16 18:00:36.000000000 +0200
@@ -578,10 +578,6 @@ xdi_copy_from_user(void *os_handle, void
 /*
  * device node operations
  */
-static int divas_open(struct inode *inode, struct file *file)
-{
-	return (0);
-}
 
 static int divas_release(struct inode *inode, struct file *file)
 {
@@ -667,7 +663,6 @@ static const struct file_operations diva
 	.read    = divas_read,
 	.write   = divas_write,
 	.poll    = divas_poll,
-	.open    = divas_open,
 	.release = divas_release
 };
 
