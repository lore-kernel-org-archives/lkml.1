Return-Path: <linux-kernel-owner+w=401wt.eu-S934873AbXEHJvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873AbXEHJvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934868AbXEHJvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:51:07 -0400
Received: from www.osadl.org ([213.239.205.134]:45536 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934845AbXEHJvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:51:05 -0400
Subject: Re: [PATCH 5/5] x86_64: restore restore nohpet cmdline
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chris Wright <chrisw@sous-sol.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070508094737.GX3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <20070507163110.GP3505@sequoia.sous-sol.org>
	 <1178556361.3042.16.camel@localhost.localdomain>
	 <20070508093957.GS3505@sequoia.sous-sol.org>
	 <20070508094737.GX3505@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 11:53:53 +0200
Message-Id: <1178618033.3042.314.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 02:47 -0700, Chris Wright wrote:
> Lost when merged with i386.  Happy to drop, but I suspect Andi would
> rather not break existing users (I noticed because it was part of my
> testing).  If dropped, Documentation needs updating.

Fair enough.

> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  arch/i386/kernel/hpet.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> --- tglx.orig/arch/i386/kernel/hpet.c
> +++ tglx/arch/i386/kernel/hpet.c
> @@ -78,6 +78,14 @@ static int __init hpet_setup(char* str)
>  	return 1;
>  }
>  __setup("hpet=", hpet_setup);
> +#ifdef CONFIG_X86_64
> +static int __init disable_hpet(char *str)
> +{
> +	boot_hpet_disable = 1;
> +	return 1;
> +}
> +__setup("nohpet", disable_hpet);
> +#endif
>  
>  static inline int is_hpet_capable(void)
>  {

