Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbYJIPqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbYJIPqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 11:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYJIPpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 11:45:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14853 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbYJIPpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 11:45:55 -0400
Date: Thu, 9 Oct 2008 08:45:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch]fix wrong sysfs file attribute
Message-Id: <20081009084505.e5496a7c.randy.dunlap@oracle.com>
In-Reply-To: <1223530282.30941.7.camel@sli10-desk.sh.intel.com>
References: <1223530282.30941.7.camel@sli10-desk.sh.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Oct 2008 13:31:22 +0800 Shaohua Li wrote:

> This attribute just has write operation.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  drivers/base/memory.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/base/memory.c
> ===================================================================
> --- linux.orig/drivers/base/memory.c	2008-10-09 11:41:40.000000000 +0800
> +++ linux/drivers/base/memory.c	2008-10-09 11:41:52.000000000 +0800
> @@ -325,7 +325,7 @@ memory_probe_store(struct class *class, 
>  
>  	return count;
>  }
> -static CLASS_ATTR(probe, 0700, NULL, memory_probe_store);
> +static CLASS_ATTR(probe, 0200, NULL, memory_probe_store);
>  
>  static int memory_probe_init(void)
>  {

#include <stat.h>

+static CLASS_ATTR(probe, S_IWUSR, NULL, memory_probe_store);

is almost readable.

---
~Randy
