Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZCJNzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZCJNzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbZCJNzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:55:43 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:37160 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZCJNzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:55:42 -0400
Date: Tue, 10 Mar 2009 14:53:11 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Greg Banks <gnb@sgi.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: driver-core tree build failure
Message-ID: <20090310145311.6bf9d9e9@skybase>
In-Reply-To: <alpine.LRH.2.00.0903101423200.25436@vixen.sonytel.be>
References: <20090310192440.949884a1.sfr@canb.auug.org.au>
	<alpine.LRH.2.00.0903101423200.25436@vixen.sonytel.be>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 14:31:17 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> crypto/zlib.c has:
> 
>     #define pr_fmt(fmt)     "%s: " fmt, __func__
> 
> If CONFIG_DYNAMIC_DEBUG is set, include/linux/kernel.h has:
> 
> #define pr_debug(fmt, ...) do { \
> 	dynamic_pr_debug(pr_fmt(fmt), ##__VA_ARGS__); \
> 	} while (0)
> 
> include/linux/dynamic_debug.h has:
> 
> #define dynamic_pr_debug(fmt, ...) do {					\
> 	static struct _ddebug descriptor				\
> 	__used								\
> 	__attribute__((section("__verbose"), aligned(8))) =		\
> 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, DEBUG_HASH,	\
> 		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
> 	if (__dynamic_dbg_enabled(descriptor))				\
> 		printk(KERN_DEBUG KBUILD_MODNAME ":" fmt,		\
> 				##__VA_ARGS__);				\
> 	} while (0)

The dynamic_pr_debug macro currently works only with pr_fmt definitions
that do not add additional parameters. The way how we use the pr_fmt
macro is:

#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt

The same could be done with the problematic pr_fmt definition:

#define pr_fmt(fmt)     __func__ ": " fmt

> BTW, Martin: Is `#define pr_fmt(fmt)     "%s: " fmt, __func__' a valid and
> intended usage of your pr_fmt() infrastructure?

The indended use is a simple prefix to the format string. To paste an
additional parameter is an interesting use of the pr_fmt macro ..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

