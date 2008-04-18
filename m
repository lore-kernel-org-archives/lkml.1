Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbYDRRjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbYDRRjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 13:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbYDRRiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 13:38:55 -0400
Received: from mail.queued.net ([207.210.101.209]:1133 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbYDRRiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 13:38:54 -0400
Date: Fri, 18 Apr 2008 13:41:12 -0400
From: Andres Salomon <dilinger@queued.net>
To: Thiago Galesi <thiagogalesi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: Remove use of lock_kernel /
 unlock_kernel in fbmem
Message-ID: <20080418134112.2a9c5929@ephemeral>
In-Reply-To: <200804162000.59587.thiagogalesi@gmail.com>
References: <200804131150.07601.thiagogalesi@gmail.com>
	<20080415221707.82da3d42.akpm@linux-foundation.org>
	<200804162000.59587.thiagogalesi@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 20:00:59 -0300
Thiago Galesi <thiagogalesi@gmail.com> wrote:

> 
> This patch removes lock_kernel(), unlock_kernel() usage in fbmem.c and replaces it with a mutex
> 
> Signed-off-by: Thiago Galesi <thiagogalesi@gmail.com>
> 
[...]
> @@ -1413,6 +1435,8 @@ register_framebuffer(struct fb_info *fb_
>  
>  	event.info = fb_info;
>  	fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
> +
> +	mutex_init(&fb_info->hwlock);
>  	return 0;
>  }
> 

Just a minor nit; in general, I'd think you would want to completely
initialize the structure (including calling mutex_init) before
registering the structure with the rest of the system (in this case,
with registered_fb and *_call_notifier_chain).  Initializing after
registration is just asking for a race conditions.


 
-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.
