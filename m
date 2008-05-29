Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbYE2TUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbYE2TUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYE2TUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:20:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375AbYE2TUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:20:45 -0400
Date: Thu, 29 May 2008 12:19:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, bunk@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Werror: Fix casting wrong size integer to pointer
Message-Id: <20080529121942.b6d768e7.akpm@linux-foundation.org>
In-Reply-To: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
References: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 19:17:26 +0100 David Howells <dhowells@redhat.com> wrote:

> --- a/drivers/message/i2o/i2o_config.c
> +++ b/drivers/message/i2o/i2o_config.c
> @@ -886,7 +886,7 @@ static int i2o_cfg_passthru(unsigned long arg)
>  			    flag_count & 0x04000000 /*I2O_SGL_FLAGS_DIR */ ) {
>  				// TODO 64bit fix
>  				if (copy_from_user
> -				    (p, (void __user *)sg[i].addr_bus,
> +				    (p, (void __user *)(unsigned long)sg[i].addr_bus,
>  				     sg_size)) {
>  					printk(KERN_DEBUG
>  					       "%s: Could not copy SG buf %d FROM user\n",
> @@ -942,7 +942,7 @@ static int i2o_cfg_passthru(unsigned long arg)
>  				sg_size = sg[j].flag_count & 0xffffff;
>  				// TODO 64bit fix
>  				if (copy_to_user
> -				    ((void __user *)sg[j].addr_bus, sg_list[j],
> +				    ((void __user *)(unsigned long)sg[j].addr_bus, sg_list[j],
>  				     sg_size)) {
>  					printk(KERN_WARNING
>  					       "%s: Could not copy %p TO user %x\n",

yup, what Linus said.  This one's been irritating me for years, and I
got close to tempting Markus into fixing it before he departed the
scene.  But it remains, as a little "might be busted on 64 bit" reminder.
