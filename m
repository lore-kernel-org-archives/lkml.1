Return-Path: <linux-kernel-owner+w=401wt.eu-S1763840AbXJOVyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763840AbXJOVyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757472AbXJOVxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:53:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757492AbXJOVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:53:18 -0400
Date: Mon, 15 Oct 2007 14:53:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] IPMI: new NMI handling
Message-Id: <20071015145309.c762d36a.akpm@linux-foundation.org>
In-Reply-To: <20071012164057.GE22142@minyard.local>
References: <20071012164057.GE22142@minyard.local>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 11:40:57 -0500
Corey Minyard <minyard@acm.org> wrote:

> -#ifdef CONFIG_X86_LOCAL_APIC
> -#include <asm/apic.h>
> +#ifdef CONFIG_X86
> +/* This is ugly, but I've determined that x86 is the only architecture
> +   that can reasonably support the IPMI NMI watchdog timeout at this
> +   time.  If another architecture adds this capability somehow, it
> +   will have to be a somewhat different mechanism and I have no idea
> +   how it will work.  So in the unlikely event that another
> +   architecture supports this, we can figure out a good generic
> +   mechanism for it at that time. */
> +#include <asm/kdebug.h>
> +#define HAVE_DIE_NMI

A preferred way of doing this would be to add a new CONFIG_IPMI_USE_IPMI in
arch/i386/Kconfig and arch/x86_64/Kconfig only, then use that in the ipmi
code.
