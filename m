Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbYIIRGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbYIIRGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbYIIRGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:06:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57048 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675AbYIIRGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:06:16 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Sebastian Siewior <lkml@ml.breakpoint.cc>, Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Date: Tue, 9 Sep 2008 13:03:27 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <20080909074018.GA26076@Chamillionaire.breakpoint.cc>
In-Reply-To: <20080909074018.GA26076@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091303.27742.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 03:40:18 Sebastian Siewior wrote:
> >diff --git a/drivers/input/lirc/Makefile b/drivers/input/lirc/Makefile
> >new file mode 100644
> >index 0000000..cdb4c45
> >--- /dev/null
> >+++ b/drivers/input/lirc/Makefile
> >@@ -0,0 +1,8 @@
> >+# Makefile for the lirc drivers.
> >+#
> >+
> >+# Each configuration option enables a list of files.
> >+
> >+EXTRA_CFLAGS =-DIRCTL_DEV_MAJOR=61 -DLIRC_SERIAL_TRANSMITTER -I$(src)
>
> Do you rely on this specific major? Since your daemon opens /dev/lirc0
> you don't need a fixed major do you?

Good question. Quite honestly, I'm not sure. Christoph?

> LIRC_SERIAL_TRANSMITTER is used in patch 2 and just to enable a module
> options. Since it is always the case, please remove it.
> I haven't found the source of $src. It is probably a relic.

Janne took care of these. Heck, he's already replied, I'll just leave out the 
parts he already replied to...

> >+++ b/drivers/input/lirc/lirc_dev.c
> >@@ -0,0 +1,809 @@
> >+/*
> >+ * LIRC base driver
> >+ *
> >+ * (L) by Artur Lipowski <alipowski@interia.pl>
>
> Is that L here on purpose?

Historical. I think it is supposed to signify that this was originally 
licensed and written by Artur, but simply removing "(L) " is fine (here and in 
lirc_dev.h).

> >+#include <linux/smp_lock.h>
>
> if you need this than you use the BKL back. As far as I remember
> the ioctl() handler in kernel core no longer takes the BKL and I don't
> see any locking in irctl_ioctl().


> >+/*  helper function
> >+ *  initializes the irctl structure
> >+ */
>
> For all comments above functions:
> - Please use the default comment style.

Apologies, I started on that, didn't finish, then forgot about it. Will do.

> - don't comment obvious things
> - please use kernel doc if
> - please comment the prototypes but the actual function.

Working on this too.

> >+	bytes_in_key = p->code_length/8 + (p->code_length%8 ? 1 : 0);
>
> did you actually pass checkpatch.pl ?

Yeah, but now that you point that out, I'm not sure how... :)

Taken care of by simply using BITS_TO_LONG() instead.

> >+EXPORT_SYMBOL(lirc_register_plugin);
>
> Is EXPORT_SYMBOL_GPL() possible?

Should be, I'm definitely not aware of any non-GPL users.

> >+EXPORT_SYMBOL(lirc_unregister_plugin);

Ditto.

> >+/* ----------------------------------------------------------------------
> > */
>
> I hate those

Me too. Gone.

-- 
Jarod Wilson
jarod@redhat.com

