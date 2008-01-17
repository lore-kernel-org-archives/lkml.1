Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbYAQNON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbYAQNON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYAQNN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:13:58 -0500
Received: from gecko.sbs.de ([194.138.37.40]:23642 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbYAQNN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:13:57 -0500
Message-ID: <478F545B.3010901@siemens.com>
Date: Thu, 17 Jan 2008 14:12:59 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 14/21] KGDB: KGDB arch support for ARM
References: <4713B281.8090702@windriver.com>
In-Reply-To: <4713B281.8090702@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> 
...
> --- a/drivers/serial/pxa.c
> +++ b/drivers/serial/pxa.c
> @@ -42,6 +42,9 @@
>  #include <linux/tty.h>
>  #include <linux/tty_flip.h>
>  #include <linux/serial_core.h>
> +#ifdef CONFIG_KGDB_CONSOLE
> +#include <linux/kgdb.h>
> +#endif
>  
>  #include <asm/io.h>
>  #include <asm/hardware.h>
> @@ -690,6 +693,8 @@ serial_pxa_console_init(void)
>  console_initcall(serial_pxa_console_init);
>  
>  #define PXA_CONSOLE	&serial_pxa_console
> +#elif defined(CONFIG_KGDB_CONSOLE)
> +#define PXA_CONSOLE	&kgdbcons
>  #else
>  #define PXA_CONSOLE	NULL
>  #endif

This is the only spot in the whole kgdb series where kgdbcons is used
outside its home kernel/kgdb.c. Is this really required in order to use
the kgdb console with PXA? And why is it like this only for this platform?

[Note that this forces kgdbcons to become non-static, ie. we will have
to fully initialize it, unlike it is done so far...]

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
