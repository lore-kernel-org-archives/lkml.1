Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbXCRVU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbXCRVU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 17:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbXCRVU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 17:20:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbXCRVU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 17:20:26 -0400
Message-ID: <45FDAC3B.6000202@redhat.com>
Date: Sun, 18 Mar 2007 17:16:43 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Bauer <JohannesBauer@gmx.de>, linux-kernel@vger.kernel.org,
       schwab@suse.de, Stable Kernel Team <stable@kernel.org>,
       Greg KH <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
References: <45F6F3A6.9060405@gmx.de> <45F7033B.2030204@redhat.com>	 <1173817985.13341.120.camel@localhost.localdomain>	 <1173866413.13341.154.camel@localhost.localdomain>	 <20070316124313.9f0afc05.akpm@linux-foundation.org> <1174079120.13341.286.camel@localhost.localdomain>
In-Reply-To: <1174079120.13341.286.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> 
> I'd prefer this one: The maximum seconds value we can handle on 32bit is
> LONG_MAX.
> 
> diff --git a/include/linux/ktime.h b/include/linux/ktime.h
> index c68c7ac..248305b 100644
> --- a/include/linux/ktime.h
> +++ b/include/linux/ktime.h
> @@ -57,7 +57,11 @@ typedef union {
>  } ktime_t;
>  
>  #define KTIME_MAX			((s64)~((u64)1 << 63))
> -#define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
> +#if (BITS_PER_LONG == 64)
> +# define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
> +#else
> +# define KTIME_SEC_MAX			LONG_MAX
> +#endif
>  
>  /*
>   * ktime_t definitions when using the 64-bit scalar representation:
> 

Just to be clear: this replaces the earlier patch, right?




