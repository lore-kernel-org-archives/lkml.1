Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYIPTDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYIPTDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbYIPTDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:03:23 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:34247 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbYIPTDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XUvrdlBrjEBliGl7A8rb5FvObmJFFGye5Dkl0PuBI81Sqo3kbtSefy7tVSNI1ZjRhy
         iYs7xiT8kPh5i2yaW8qE8OIy3m37Hbn1UYPU2ZrVMpi+62/pYt4xOCQm9Ebk2uWRI9TV
         rMYPGC79MFfoze81dy4ZeDdY9xdJEyMmzMswo=
Date: Tue, 16 Sep 2008 21:02:31 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] add DEFINE_LOGLEVEL_SETUP v3
Message-ID: <20080916190224.GA6115@joi>
References: <1221588085-30578-1-git-send-email-yhlu.kernel@gmail.com> <1221588085-30578-2-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221588085-30578-2-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 11:01:21AM -0700, Yinghai Lu wrote:
> --- linux-2.6.orig/include/linux/kernel.h
> +++ linux-2.6/include/linux/kernel.h
> @@ -104,6 +104,15 @@ extern int console_printk[];
>  #define minimum_console_loglevel (console_printk[2])
>  #define default_console_loglevel (console_printk[3])
>  
> +#define	KERN_LOG_EMERG	0	/* system is unusable			*/
> +#define	KERN_LOG_ALERT	1	/* action must be taken immediately	*/
> +#define	KERN_LOG_CRIT	2	/* critical conditions			*/
> +#define	KERN_LOG_ERR	3	/* error conditions			*/
> +#define	KERN_LOG_WARNING	4	/* warning conditions			*/
> +#define	KERN_LOG_NOTICE	5	/* normal but significant condition	*/
> +#define	KERN_LOG_INFO	6	/* informational			*/
> +#define	KERN_LOG_DEBUG	7	/* debug-level messages			*/
> +
>  struct completion;
>  struct pt_regs;
>  struct user;

maybe
#define KERN_LOG_EMERG 0,KERN_EMERG
#define KERN_LOG_ALERT 1,KERN_ALERT
...
?

or better - create printk2(level, fmt) which prints "<", level, ">", fmt
and wrap it with pci_printk / acpi_printk?

Marcin
