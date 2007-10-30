Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbXJ3WOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbXJ3WOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbXJ3WOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:14:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49154 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbXJ3WOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:14:06 -0400
Date: Tue, 30 Oct 2007 15:14:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: mikael.starvik@axis.com, jesper.nilsson@axis.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/16] CRIS architecture: Correct compile errors
Message-Id: <20071030151403.dc43e571.akpm@linux-foundation.org>
In-Reply-To: <20071030093000.GG11960@axis.com>
References: <20071030093000.GG11960@axis.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 10:30:00 +0100
Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> 
> Include asm/irq.h to avoid undefined value warning.
> 

When fixing build errors or warnings please always always quote the
compiler output so that we can see what you're actually fixing.  Saying
"undefined value warning" is pretty useless.

When quoting gcc output, please ensure that LANG=C was set - otherwise gcc
will emit utf gobbledigook which basically never makes it through the
system unscathed.

> diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/include/asm-cris/hardirq.h linux-2.6.23/include/asm-cris/hardirq.h
> --- clean_linux-2.6.23/include/asm-cris/hardirq.h	2007-10-09 22:31:38.000000000 +0200
> +++ linux-2.6.23/include/asm-cris/hardirq.h	2007-10-22 10:35:12.000000000 +0200
> @@ -1,6 +1,7 @@
>  #ifndef __ASM_HARDIRQ_H
>  #define __ASM_HARDIRQ_H
>  
> +#include <asm/irq.h>
>  #include <linux/threads.h>
>  #include <linux/cache.h>
>  

hrm, OK.  Not linux/irq.h?  I guess not, as cris doesn't appear to support
CONFIG_GENERIC_HARDIRQS.
