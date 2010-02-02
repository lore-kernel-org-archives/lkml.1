Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab0BBIgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:36:12 -0500
Received: from verein.lst.de ([213.95.11.210]:38375 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab0BBIgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:36:09 -0500
Date: Tue, 2 Feb 2010 09:34:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux@arm.linux.org.uk, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       gerg@uclinux.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/6] generic sys_old_select
Message-ID: <20100202083440.GB7552@lst.de>
References: <20100201185506.GA11045@lst.de> <m24om0shpe.fsf@igel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m24om0shpe.fsf@igel.home>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:40:29PM +0100, Andreas Schwab wrote:
> > Index: linux-2.6/fs/compat.c
> > ===================================================================
> > --- linux-2.6.orig/fs/compat.c	2010-01-12 14:08:16.202003005 +0100
> > +++ linux-2.6/fs/compat.c	2010-01-29 23:35:20.187003404 +0100
> > @@ -1795,6 +1795,24 @@ asmlinkage long compat_sys_select(int n,
> >  	return ret;
> >  }
> >  
> > +struct compat_sel_arg_struct {
> > +	compat_ulong_t n;
> > +	compat_ulong_t inp;
> > +	compat_ulong_t outp;
> > +	compat_ulong_t exp;
> > +	compat_ulong_t tvp;
> > +};
> 
> Shouldn't the last four be compat_uptr_t?

Strictly speaking yes, although it doesn't matter for the generated
code.  The patch below makes it use the strictly correct type:


Index: linux-2.6/fs/compat.c
===================================================================
--- linux-2.6.orig/fs/compat.c	2010-02-02 09:20:16.207003623 +0100
+++ linux-2.6/fs/compat.c	2010-02-02 09:20:53.554012789 +0100
@@ -1797,10 +1797,10 @@ asmlinkage long compat_sys_select(int n,
 
 struct compat_sel_arg_struct {
 	compat_ulong_t n;
-	compat_ulong_t inp;
-	compat_ulong_t outp;
-	compat_ulong_t exp;
-	compat_ulong_t tvp;
+	compat_uptr_t inp;
+	compat_uptr_t outp;
+	compat_uptr_t exp;
+	compat_uptr_t tvp;
 };
 
 asmlinkage long compat_sys_old_select(struct compat_sel_arg_struct __user *arg)

