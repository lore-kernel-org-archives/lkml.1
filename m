Return-Path: <linux-kernel-owner+w=401wt.eu-S934111AbYBGX1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111AbYBGX1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758684AbYBGX1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:27:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33053 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759497AbYBGX1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:27:10 -0500
Date: Thu, 7 Feb 2008 15:26:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
Message-Id: <20080207152632.1d45b4c1.akpm@linux-foundation.org>
In-Reply-To: <47AB8F63.4020002@redhat.com>
References: <47AA3126.8090102@redhat.com>
	<20080206143457.03e8741d.akpm@linux-foundation.org>
	<47AA3EAA.9080204@redhat.com>
	<20080206152239.a2352d6d.akpm@linux-foundation.org>
	<47AB8F63.4020002@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008 17:08:19 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

> Index: linux-2.6.24-mm1/include/linux/compiler-gcc.h
> ===================================================================
> --- linux-2.6.24-mm1.orig/include/linux/compiler-gcc.h
> +++ linux-2.6.24-mm1/include/linux/compiler-gcc.h
> @@ -53,3 +53,9 @@
>  #define  noinline			__attribute__((noinline))
>  #define __attribute_const__		__attribute__((__const__))
>  #define __maybe_unused			__attribute__((unused))
> +
> +/*
> + * When gcc inlines multiple functions into a parent function,
> + * the stack space used sometimes increases excessively...
> + */
> +#define noinline_stackspace	noinline
> 
> 
> ?
> 
> I couldn't think of a great name for it.  There are several noinline
> users throughout the kernel with stackspace related comments, so if
> desired, I could sprinkle this around.  I'm not very pleased with it
> aesthetically though. :)

I think it's fine.  People can go look at the definition site, read the
comment and come away happy.
