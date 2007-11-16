Return-Path: <linux-kernel-owner+w=401wt.eu-S1759054AbXKPPoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbXKPPoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbXKPPob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:44:31 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:41743 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbXKPPoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:44:30 -0500
X-Greylist: delayed 2086 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2007 10:44:30 EST
Date: Fri, 16 Nov 2007 16:09:42 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 3/6] sclp: call sclp_init() from start_kernel().
Message-ID: <20071116150942.GA5748@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20071116142942.978412023@de.ibm.com> <20071116143321.502691250@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071116143321.502691250@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 03:29:45PM +0100, Martin Schwidefsky wrote:
>  #else
>  static inline void acpi_early_init(void) { }
>  #endif
> +#ifdef CONFIG_S390
> +extern int sclp_init(void);
> +#else
> +static inline int sclp_init(void) {return 0;}
> +#endif
>  #ifndef CONFIG_DEBUG_RODATA
>  static inline void mark_rodata_ro(void) { }
>  #endif
> @@ -643,6 +648,7 @@ asmlinkage void __init start_kernel(void
>  	check_bugs();
>  
>  	acpi_early_init(); /* before LAPIC and SMP init */
> +	sclp_init();

What happens if sclp_init fails? The other early init calls explicitely
returns void and handels the error internal.

Bastian

-- 
Time is fluid ... like a river with currents, eddies, backwash.
		-- Spock, "The City on the Edge of Forever", stardate 3134.0
