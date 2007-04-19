Return-Path: <linux-kernel-owner+w=401wt.eu-S1766792AbXDSPlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766792AbXDSPlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766823AbXDSPlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:41:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41547 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766792AbXDSPlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:41:20 -0400
Date: Thu, 19 Apr 2007 08:43:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jiri Bohac <jbohac@suse.cz>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] fix abs() macro to work with types wider than int
Message-Id: <20070419084339.418dbe69.randy.dunlap@oracle.com>
In-Reply-To: <20070419092339.GA13569@dwarf.suse.cz>
References: <20070419092339.GA13569@dwarf.suse.cz>
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

On Thu, 19 Apr 2007 11:23:39 +0200 Jiri Bohac wrote:

> Hi,
> 
> is there any reason to use an explicit int instead of a typeof in
> the abs() macro? The current implementation will return bogus
> results when used with longs.

I think it's like it is just to be consistent with abs() in C,
which also contains labs() and llabs().

> How about changing the int to a typeof like this?:
> 
> 
> 
> Fix the abs() macro to work with wider types than int.
> 
> Signed-off-by: Jiri Bohac <jbohac@suse.cz>
> 
> --- linux-2.6.21-rc5.orig/include/linux/kernel.h
> +++ linux-2.6.21-rc5/include/linux/kernel.h
> @@ -89,7 +89,7 @@ extern int cond_resched(void);
>  #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
>  
>  #define abs(x) ({				\
> -		int __x = (x);			\
> +		typeof(x) __x = (x);			\
>  		(__x < 0) ? -__x : __x;		\
>  	})
>  
> 
> 
> 
> -- 
> Jiri Bohac <jbohac@suse.cz>
> SUSE Labs, SUSE CZ

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
