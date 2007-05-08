Return-Path: <linux-kernel-owner+w=401wt.eu-S1031376AbXEHTTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031376AbXEHTTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967910AbXEHTTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:19:50 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967905AbXEHTTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:19:48 -0400
Date: Tue, 8 May 2007 12:19:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "John Keller" <jpk@sgi.com>, <linux-kernel@vger.kernel.org>,
       <steiner@sgi.com>, <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH Resend] - SN: validate smp_affinity mask on intr
 redirect
Message-Id: <20070508121945.3e8d29c1.akpm@linux-foundation.org>
In-Reply-To: <617E1C2C70743745A92448908E030B2A01719A90@scsmsx411.amr.corp.intel.com>
References: <20070508152315.26329.8428.64771@attica.americas.sgi.com>
	<617E1C2C70743745A92448908E030B2A01719A90@scsmsx411.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 11:03:20 -0700
"Luck, Tony" <tony.luck@intel.com> wrote:

> +#ifndef is_affinity_mask_valid
> +#define is_affinity_mask_valid() 1
> +#endif
> +
>  int no_irq_affinity;
>  static int irq_affinity_write_proc(struct file *file, const char __user *buffer,
>  				   unsigned long count, void *data)
> @@ -42,6 +46,9 @@ static int irq_affinity_write_proc(struc
>  	if (err)
>  		return err;
>  
> +	if (!is_affinity_mask_valid(new_value))
> +		return -EINVAL;
> 
> This results in a warning:
> kernel/irq/proc.c:49: warning: implicit declaration of function `is_affinity_mask_valid'
> 

It had a dopey little bug:


diff -puN kernel/irq/proc.c~sn-validate-smp_affinity-mask-on-intr-redirect-fix kernel/irq/proc.c
--- a/kernel/irq/proc.c~sn-validate-smp_affinity-mask-on-intr-redirect-fix
+++ a/kernel/irq/proc.c
@@ -28,7 +28,7 @@ static int irq_affinity_read_proc(char *
 }
 
 #ifndef is_affinity_mask_valid
-#define is_affinity_mask_valid() 1
+#define is_affinity_mask_valid(val) 1
 #endif
 
 int no_irq_affinity;
_

