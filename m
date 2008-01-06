Return-Path: <linux-kernel-owner+w=401wt.eu-S1759157AbYAFQGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157AbYAFQGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbYAFQGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:06:10 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4810 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbYAFQGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:06:09 -0500
Subject: Re: [PATCH] add gcc printf format checks
From: Joe Perches <joe@perches.com>
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <200801061451.22338.deller@gmx.de>
References: <200801061451.22338.deller@gmx.de>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 08:05:39 -0800
Message-Id: <1199635539.19634.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-01-06 at 14:51 +0100, Helge Deller wrote:
> [PATCH] add gcc printf format checks
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index 0e69d2c..ce2038f 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -232,7 +232,7 @@ extern int put_compat_itimerspec(struct compat_itimerspec __user *dst,
>  
>  asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
>  
> -extern int compat_printk(const char *fmt, ...);
> +extern int compat_printk(const char *fmt, ...) __printf(1,2);

__attribute__((format(printf, 1, 2))) seems to be the preferred
form. 91 to 1.

I think __printf should be removed from gcc-compiler.h
and the only use in include/linux/marker.h converted.


