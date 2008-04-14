Return-Path: <linux-kernel-owner+w=401wt.eu-S1763102AbYDNSrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763102AbYDNSrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934333AbYDNSnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:43:08 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51136 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934341AbYDNSnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:43:06 -0400
Date: Mon, 14 Apr 2008 21:42:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: yasutake.koichi@jp.panasonic.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] mn10300: export kernel_thread
Message-ID: <20080414184200.GA6695@cs181133002.pp.htv.fi>
References: <20080414141938.GK6695@cs181133002.pp.htv.fi> <6713.1208186069@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6713.1208186069@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 04:14:29PM +0100, David Howells wrote:
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > +EXPORT_SYMBOL_GPL(kernel_thread);
> 
> Please use EXPORT_SYMBOL() to be consistent with the other archs, but apart
> from that, it looks fine.

Updated patch below.

> David

cu
Adrian


<--  snip  -->


This patch fixes the following build error:

<--  snip  -->

...
  MODPOST 1256 modules
ERROR: "kernel_thread" [net/sunrpc/sunrpc.ko] undefined!
ERROR: "kernel_thread" [net/ipv4/ipvs/ip_vs.ko] undefined!
ERROR: "kernel_thread" [net/bluetooth/hidp/hidp.ko] undefined!
ERROR: "kernel_thread" [net/bluetooth/cmtp/cmtp.ko] undefined!
ERROR: "kernel_thread" [net/bluetooth/bnep/bnep.ko] undefined!
ERROR: "kernel_thread" [fs/nfs/nfs.ko] undefined!
ERROR: "kernel_thread" [fs/lockd/lockd.ko] undefined!
ERROR: "kernel_thread" [fs/jffs2/jffs2.ko] undefined!
ERROR: "kernel_thread" [drivers/usb/atm/usbatm.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
29ac94237884159dbf941c276daf4d3dbe3cf2a5 diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 3b0d579..345dadb 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -154,6 +154,7 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0,
 		       NULL, NULL);
 }
+EXPORT_SYMBOL(kernel_thread);
 
 /*
  * free current thread data structures etc..
