Return-Path: <linux-kernel-owner+w=401wt.eu-S2992636AbXCBROS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992636AbXCBROS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992630AbXCBROR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:14:17 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:30558 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992638AbXCBROQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:14:16 -0500
Date: Fri, 2 Mar 2007 09:11:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: dedekind@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Kconfig: enlarge printk buffer size limit
Message-Id: <20070302091113.1920ca0f.randy.dunlap@oracle.com>
In-Reply-To: <1172842068.17031.55.camel@sauron>
References: <1172842068.17031.55.camel@sauron>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007 15:27:48 +0200 Artem Bityutskiy wrote:

> From: Artem Bityutskiy <artem.bityutskiy@nokia.com>
> Subject: [RFC] [PATCH] Kconfig: enlarge printk buffer size limit
> 
> This patch makes the upper kernel ring buffer size limit larger. It
> is often very handy to have huge ring-buffer for debugging purposes,
> when the subsystem which is being debugged produces large amount of
> useful output.
> 
> Index: ubi-2.6.git/lib/Kconfig.debug
> ===================================================================
> --- ubi-2.6.git.orig/lib/Kconfig.debug
> +++ ubi-2.6.git/lib/Kconfig.debug
> @@ -79,7 +79,7 @@ config DEBUG_KERNEL
>  
>  config LOG_BUF_SHIFT
>  	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)" if DEBUG_KERNEL
> -	range 12 21
> +	range 12 26
>  	default 17 if S390 || LOCKDEP
>  	default 16 if X86_NUMAQ || IA64
>  	default 15 if SMP

That's simple enough, but you could also just add
	log_buf_len=huge_number
or
	log_buf_len=500M
or
	log_buf_len=1G
(for megabytes or gigabytes) to the kernel boot command line.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
