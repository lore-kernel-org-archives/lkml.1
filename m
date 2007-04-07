Return-Path: <linux-kernel-owner+w=401wt.eu-S965712AbXDGUKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965712AbXDGUKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 16:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966315AbXDGUKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 16:10:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33272 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965712AbXDGUKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 16:10:36 -0400
Date: Sat, 7 Apr 2007 13:10:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: mm snapshot broken-out-2007-04-07-03-27.tar.gz uploaded
Message-Id: <20070407131000.e3007eac.akpm@linux-foundation.org>
In-Reply-To: <4617F455.2050401@googlemail.com>
References: <200704071029.l37ATdKR032505@shell0.pdx.osdl.net>
	<4617F455.2050401@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Apr 2007 21:43:17 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> akpm@linux-foundation.org napisał(a):
> > The mm snapshot broken-out-2007-04-07-03-27.tar.gz has been uploaded to
> > 
> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-07-03-27.tar.gz
> > 
> > It contains the following patches against 2.6.21-rc6:
> 
> suspend-to-disk doesn't work when pktgen module is loaded.
> 
> Stopping kernel threads timed out after 20 seconds (2 tasks refusing to freeze):
>  kpktgend_0
>  kpktgend_1
> Restarting tasks ... done.
> swsusp: Basic memory bitmaps freed

This?

--- a/net/core/pktgen.c~pktgen-add-try_to_freeze
+++ a/net/core/pktgen.c
@@ -128,6 +128,7 @@
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/capability.h>
+#include <linux/freezer.h>
 #include <linux/delay.h>
 #include <linux/timer.h>
 #include <linux/list.h>
@@ -3325,6 +3326,8 @@ static int pktgen_thread_worker(void *ar
 			t->control &= ~(T_REMDEV);
 		}
 
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 
_

> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-07-03-27/mm-serialconsole2.log
> 
> Anyway, this kernel is pretty stable :)

Is appreciated, thanks.

