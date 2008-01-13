Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbYAMHa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbYAMHa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 02:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYAMHaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 02:30:20 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38945 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbYAMHaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 02:30:19 -0500
Date: Sun, 13 Jan 2008 08:30:24 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] __cpuinitconst and __devinitconst
Message-ID: <20080113073024.GA30120@uranus.ravnborg.org>
References: <47873D11.76E4.0078.0@novell.com> <20080111194428.GB29189@uranus.ravnborg.org> <20080112205635.GA6059@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112205635.GA6059@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> +#ifdef CONFIG_HOTPLUG
> +#define DEV_KEEP(sec)
> +#define DEV_DISCARD(sec) *(.dev##sec)
> +#else
> +#define DEV_KEEP(sec)    *(.dev##sec)
> +#define DEV_DISCARD(sec)
> +#endif
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +#define CPU_KEEP(sec)
> +#define CPU_DISCARD(sec) *(.cpu##sec)
> +#else
> +#define CPU_KEEP(sec)    *(.cpu##sec)
> +#define CPU_DISCARD(sec)
> +#endif
> +
> +#if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_ACPI_HOTPLUG_MEMORY) \
> +        || defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
> +#define MEM_KEEP(sec)
> +#define MEM_DISCARD(sec) *(.mem##sec)
> +#else
> +#define MEM_KEEP(sec)    *(.mem##sec)
> +#define MEM_DISCARD(sec)
> +#endif

I inversed it in the ifdef's above.
And I found another small buglet too. I hope to post a complete
solution later today.

	Sam
