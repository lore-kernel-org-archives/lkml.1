Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbYFJO31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbYFJO31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYFJO3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:29:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:58325 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbYFJO3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:29:13 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2008 10:29:13 EDT
Date: Tue, 10 Jun 2008 07:29:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 02/21] perfmon2 minimal:  generic headers
Message-ID: <20080610072914.3b6b2cfe@infradead.org>
In-Reply-To: <484dafc4.0af6660a.54fb.1b26@mx.google.com>
References: <484dafc4.0af6660a.54fb.1b26@mx.google.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2008 15:33:40 -0700 (PDT)
eranian@googlemail.com wrote:

> +#ifndef __LINUX_PERFMON_H__
> +#define __LINUX_PERFMON_H__
> +
> +/*
> + * This file contains all the user visible generic definitions for
> the
> + * interface. Model-specific user-visible definitions are located in
> + * the asm/perfmon.h file.
> + */
> + */
> +#define PFM_BVSIZE(x)	(((x)+(sizeof(u64)<<3)-1) /
> (sizeof(u64)<<3)) +#define PFM_PMD_BV	PFM_BVSIZE(PFM_MAX_PMDS)

can't use u64 in userspace headers; must use __u64


> + * default value for the user and group security parameters in
> + * /proc/sys/kernel/perfmon/sys_group
> + * /proc/sys/kernel/perfmon/task_group

hmmm that smells funky. 

> +/*
> + * perfmon version number
> + */
> +#define PFM_VERSION_MAJ		 2U
> +#define PFM_VERSION_MIN		 99U
> +#define PFM_VERSION		 (((PFM_VERSION_MAJ&0xffff)<<16)|\
> +				  (PFM_VERSION_MIN & 0xffff))
> +#define PFM_VERSION_MAJOR(x)	 (((x)>>16) & 0xffff)
> +#define PFM_VERSION_MINOR(x)	 ((x) & 0xffff)

I'm very nervous when seeing something like this in userspace headers;
you need to assume that the app has been compiled with a very different
version of the headers than the currently running kernel.... either the
version of perfmon doesn't matter, in which case these don't belong
here, or it does and it should be a runtime query.



> +#ifndef __LINUX_PERFMON_KERN_H__
> +#define __LINUX_PERFMON_KERN_H__
> +/*
> + * This file contains all the definitions of data structures,
> variables, macros
> + * that are to be shared between generic code and arch-specific code
> + *
> + * For generic only definitions, use perfmon/perfmon_priv.h
> + */
> +#ifdef __KERNEL__

no need for #ifdef __KERNEL__, just don't expose the header to
userspace.

> +/*
> + * logging
> + */
> +#define PFM_ERR(f, x...)  printk(KERN_ERR     "perfmon: " f "\n", ##
> x) +#define PFM_WARN(f, x...) printk(KERN_WARNING "perfmon: " f "\n",
> ## x) +#define PFM_LOG(f, x...)  printk(KERN_NOTICE  "perfmon: " f
> "\n", ## x) +#define PFM_INFO(f, x...) printk(KERN_INFO    "perfmon:
> " f "\n", ## x) +

hmmm what's wrong with the current set of macros the kernel has for
these?

