Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbYGAUS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbYGAUS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYGAUSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:18:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753268AbYGAUSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:18:16 -0400
Date: Tue, 1 Jul 2008 13:17:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org
Subject: Re: [PATCH -next] bug.h: add empty warn_on_slowpath() for
 CONFIG_BUG=n
Message-Id: <20080701131714.5093fa49.akpm@linux-foundation.org>
In-Reply-To: <20080701103339.b5acc1f3.randy.dunlap@oracle.com>
References: <20080701103339.b5acc1f3.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 10:33:39 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add an empty function for warn_on_slowpath() when CONFIG_BUG=n so that
> this build error does not happen:
> 
> linux-next-20080701/drivers/acpi/utilities/utmisc.c: In function 'acpi_ut_error':
> linux-next-20080701/drivers/acpi/utilities/utmisc.c:1028: error: implicit declaration of function 'warn_on_slowpath'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  include/asm-generic/bug.h |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- linux-next-20080701.orig/include/asm-generic/bug.h
> +++ linux-next-20080701/include/asm-generic/bug.h
> @@ -81,4 +81,9 @@ extern void warn_on_slowpath(const char 
>  # define WARN_ON_SMP(x)			do { } while (0)
>  #endif
>  
> +#ifndef __ASSEMBLY__
> +static inline void warn_on_slowpath(const char *file, const int line)
> +{ }
> +#endif
> +
>  #endif
> 

This looks like a needed-in-mainline fix?  or is there something in
linux-next which causes the bug?

