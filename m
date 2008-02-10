Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbYBJTbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbYBJTbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYBJTbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:31:34 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:21946 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYBJTbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:31:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=dE3tAWec2fLG6+ya/q8ne61Q/GZM6pUMPRLub/EKLxdZISYLzIEOmwVJejVL3+SaYQ9WVKBDKBC0WId58scKn+J3PoRN0cTppi6jUj16zyJSonUYqI2v6nyVXu2t8/AspuMsIjNqQ/0Ixq40WvR/bRmekyBFadjP6py69fQmiew=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] kgdb light, v6
Date: Sun, 10 Feb 2008 20:43:58 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
References: <20080210071331.GC3851@elte.hu> <20080210093128.GA11350@infradead.org> <20080210171742.GF7088@elte.hu>
In-Reply-To: <20080210171742.GF7088@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802102043.58895.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008, Ingo Molnar wrote:

[...]

> > > +/*
> > > + *	kgdb_get_shadow_thread - Get the shadowed &task_struct of @threadid.
> > > + *	@regs: The &struct pt_regs of the current thread.
> > > + *	@threadid: The thread id of the shadowed process to get information on.
> > > + *
> > > + *	RETURN:
> > > + *	This returns a pointer to the &struct task_struct of the shadowed
> > > + *	thread, @threadid.
> > > + */
> > > +extern struct task_struct *kgdb_get_shadow_thread(struct pt_regs *regs,
> > > +						  int threadid);
> > 
> > So we have kerneldoc comments in both places now?  Didn't you say
> > you converted these to something else?
> 
> no. These are not DocBook comments, if you look carefully at the format 
> [it's not a leading '/**' comment block]. But obviously documenting this 
> in the include file is very useful, because that's where people look 
> first, so i kept it. (the APIs will not deviate across architectures)

comments and variable names in include files have a tendency for going
out-of-sync in the long term so IMO having a DocBook to point people at
would be a better solution (+ it would shrink <linux/kgdb.h> by 122 lines)

while at it:

--- x86/kernel/kgdb.c	2008-02-10 20:30:39.000000000 +0100
+++ linux/kgdb.h	2008-02-10 20:25:21.000000000 +0100
@@ -128,11 +131,13 @@
  *	process more packets, and a %0 or %1 if it wants to exit from the
  *	kgdb callback.
  */
-int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
-			       char *remcomInBuffer, char *remcomOutBuffer,
-			       struct pt_regs *linux_regs)
+extern int
+kgdb_arch_handle_exception(int vector, int signo, int err_code,
+			   char *remcom_in_buffer,
+			   char *remcom_out_buffer,
+			   struct pt_regs *regs);
