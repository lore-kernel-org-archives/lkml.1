Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZIRASM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZIRASM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZIRASL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:18:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751AbZIRASK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:18:10 -0400
Date: Thu, 17 Sep 2009 17:18:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: davem@davemloft.net, JBeulich@novell.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH] fix BUILD_BUG_ON() and a couple of bogus uses of it
Message-Id: <20090917171810.f675c8f2.akpm@linux-foundation.org>
In-Reply-To: <20090917171504.649ba29b.akpm@linux-foundation.org>
References: <4A8AEBFD0200007800010580@vpn.id2.novell.com>
	<20090917162437.b1a890de.akpm@linux-foundation.org>
	<20090917.170156.152594715.davem@davemloft.net>
	<20090917171504.649ba29b.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 17:15:04 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> There's a shortcoming in the current BUILD_BUG_ON() - it silently does
> nothing if passed a non-constant arg.
> 
> I suspect that in the 2.6.31 code, that BUILD_BUG_ON() just does
> nothing at all, and that Jan's patch is now exposing this.  It might be
> compiler-version dependent too.
> 
> 
> <tests it>
> 
> Yup, on base 2.6.31, this:
> 
> --- a/arch/sparc/kernel/vio.c~a
> +++ a/arch/sparc/kernel/vio.c
> @@ -23,6 +23,8 @@ static const struct vio_device_id *vio_m
>  	const char *type, *compat;
>  	int len;
>  
> +	vio_dring_avail(NULL, 33);
> +
>  	type = dev->type;
>  	compat = dev->compat;
>  	len = dev->compat_len;
> _
> 
> compiles without error with gcc-3.4.5.

And I can't immediately find a way to make any compile-time error occur here, with
or without Jan's patch.  hm.

