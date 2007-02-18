Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227AbXBRWCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbXBRWCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 17:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbXBRWCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 17:02:08 -0500
Received: from mail.screens.ru ([213.234.233.54]:58660 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbXBRWCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 17:02:07 -0500
Date: Mon, 19 Feb 2007 01:01:34 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: freezer problems
Message-ID: <20070218220134.GA4243@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <200702181314.29214.rjw@sisk.pl> <20070218145246.GA80@tv-sign.ru> <200702181956.11273.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702181956.11273.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Rafael J. Wysocki wrote:
> 
> Appended is a patch that does something along these lines.  The necessary
> thread_info flags are defined for i386 and x86_64, for now.

I'll try to look at this patch when I am not sooooo sleepy ...

just one small nit right now,

> --- linux-2.6.20-mm2.orig/include/asm-i386/thread_info.h	2007-02-18 19:49:34.000000000 +0100
> +++ linux-2.6.20-mm2/include/asm-i386/thread_info.h	2007-02-18 19:50:37.000000000 +0100
> @@ -135,6 +135,7 @@ static inline struct thread_info *curren
>  #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
>  #define TIF_FREEZE		19	/* is freezing for suspend */
>  #define TIF_FORCED_TF		20	/* true if TF in eflags artificially */
> +#define TIF_FREEZER_SKIP	21	/* task freezer should not count us */

Do we need to put this flag into thread_info? It is always modified by
"current", so it could live in task_struct->flags instead.

Oleg.

