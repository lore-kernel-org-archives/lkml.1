Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbXLLLVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbXLLLVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXLLLV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:21:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59926 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbXLLLV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:21:27 -0500
Date: Wed, 12 Dec 2007 03:21:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 29/47] Update CRISv32 traps.c
Message-Id: <20071212032124.e8ce63ee.akpm@linux-foundation.org>
In-Reply-To: <f8fad52fb87d1d89d848b7c56533a0e32fd9b596.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
	<f8fad52fb87d1d89d848b7c56533a0e32fd9b596.1196848533.git.jesper.nilsson@axis.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 16:22:50 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> +#ifdef CONFIG_DEBUG_BUGVERBOSE
> +void
> +handle_BUG(struct pt_regs *regs)
>  {
> -  asm volatile("setf m");
> +	struct bug_frame f;
> +	unsigned char c;
> +	unsigned long irp = regs->irp;
> +
> +	if (__copy_from_user(&f, (const void __user *)(irp - 8), sizeof f))
> +		return;
> +	if (f.prefix != BUG_PREFIX || f.magic != BUG_MAGIC)
> +		return;
> +	if (__get_user(c, f.filename))
> +		f.filename = "<bad filename>";
> +
> +	printk("kernel BUG at %s:%d!\n", f.filename, f.line);
>  }
> +#endif

Why is it accessing user memory in the BUG handler?
