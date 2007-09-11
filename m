Return-Path: <linux-kernel-owner+w=401wt.eu-S965829AbXIKIsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965829AbXIKIsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762166AbXIKIsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:48:22 -0400
Received: from mo32.po.2iij.net ([210.128.50.17]:1310 "EHLO mo32.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762011AbXIKIsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:48:22 -0400
Date: Tue, 11 Sep 2007 17:48:04 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: yoichi_yuasa@tripeaks.co.jp, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: add #include <linux/spinlock_types.h> to
 include/linux/leds.h for rwlock_t
Message-Id: <20070911174804.2c4949a7.yoichi_yuasa@tripeaks.co.jp>
In-Reply-To: <20070910220423.43e0a4d9.akpm@linux-foundation.org>
References: <20070904162345.30e82bc8.yoichi_yuasa@tripeaks.co.jp>
	<20070910220423.43e0a4d9.akpm@linux-foundation.org>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 22:04:23 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 4 Sep 2007 16:23:45 +0900 Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp> wrote:
> 
> > 
> > This patch has added #include <linux/spinlock_types.h> to include/linux/leds.h for rwlock_t.
> > 
> > Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> > 
> > diff -pruN -X generic/Documentation/dontdiff generic-orig/include/linux/leds.h generic/include/linux/leds.h
> > --- generic-orig/include/linux/leds.h	2007-09-04 14:59:51.334686250 +0900
> > +++ generic/include/linux/leds.h	2007-09-04 14:56:10.676896000 +0900
> > @@ -13,6 +13,7 @@
> >  #define __LINUX_LEDS_H_INCLUDED
> >  
> >  #include <linux/list.h>
> > +#include <linux/spinlock_types.h>
> >  
> >  struct device;
> >  /*
> 
> I think spinlock_types.h is more an internal implementation detail, and
> that leds.h should be including plain old <linux/spinlock.h>.  Does that
> change also fix whatever build error you were seeing?

Yes it does.

Yoichi

---

This patch has added #include <linux/spinlock.h> to include/linux/leds.h for rwlock_t.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X generic/Documentation/dontdiff generic-orig/include/linux/leds.h generic/include/linux/leds.h
--- generic-orig/include/linux/leds.h	2007-09-11 15:32:22.723667750 +0900
+++ generic/include/linux/leds.h	2007-09-11 15:28:20.696542000 +0900
@@ -13,6 +13,7 @@
 #define __LINUX_LEDS_H_INCLUDED
 
 #include <linux/list.h>
+#include <linux/spinlock.h>
 
 struct device;
 /*
