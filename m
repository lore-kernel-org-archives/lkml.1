Return-Path: <linux-kernel-owner+w=401wt.eu-S1761700AbXEXDK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761700AbXEXDK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbXEXDKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:10:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:60921 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676AbXEXDKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:10:48 -0400
Date: Wed, 23 May 2007 20:15:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ben Collins <bcollins@ubuntu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] i386/x86_64: Allow disabling the putstr's from
 compressed boot wrapper
Message-Id: <20070523201544.d07eee86.randy.dunlap@oracle.com>
In-Reply-To: <b31c080.git.bcollins@ubuntu.com>
References: <98cd38b5.git.bcollins@ubuntu.com>
	<b31c080.git.bcollins@ubuntu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 17:59:10 -0400 Ben Collins wrote:

> diff --git a/arch/i386/boot/compressed/misc.c b/arch/i386/boot/compressed/misc.c
> index b28505c..cc630d5 100644
> --- a/arch/i386/boot/compressed/misc.c
> +++ b/arch/i386/boot/compressed/misc.c
> @@ -278,6 +277,9 @@ static void putstr(const char *s)
>  	outb_p(15, vidport);
>  	outb_p(0xff & (pos >> 1), vidport+1);
>  }
> +#else
> +#define putstr(__x) do{}while(0)

Please find the spacebar:

#define putstr(__x)	do {} while (0)

> +#endif /* CONFIG_WRAPPER_PRINT */
>  
>  static void* memset(void* s, int c, unsigned n)
>  {
> diff --git a/arch/x86_64/boot/compressed/misc.c b/arch/x86_64/boot/compressed/misc.c
> index f932b0e..43bb44c 100644
> --- a/arch/x86_64/boot/compressed/misc.c
> +++ b/arch/x86_64/boot/compressed/misc.c
> @@ -274,6 +273,9 @@ static void putstr(const char *s)
>  	outb_p(15, vidport);
>  	outb_p(0xff & (pos >> 1), vidport+1);
>  }
> +#else
> +#define putstr(__x) do{}while(0)

ditto.

> +#endif /* CONFIG_WRAPPER_PRINT */
>  
>  static void* memset(void* s, int c, unsigned n)
>  {


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
