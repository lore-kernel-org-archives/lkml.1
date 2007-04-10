Return-Path: <linux-kernel-owner+w=401wt.eu-S1030960AbXDJQGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030960AbXDJQGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030962AbXDJQGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:06:05 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33892 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030960AbXDJQGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:06:04 -0400
Date: Tue, 10 Apr 2007 09:05:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add spaces on either side of case "..." operator.
Message-Id: <20070410090555.d847d466.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704100721050.13729@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0704100721050.13729@CPE00045a9c397f-CM001225dbafb6>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 07:23:35 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:

> Following the programming advice laid down in the gcc manual, make
> sure the case "..." operator has spaces on either side.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
> According to:
> 
> http://gcc.gnu.org/onlinedocs/gcc-4.1.2/gcc/Case-Ranges.html#Case-Ranges:
> 
>   "Be careful: Write spaces around the ..., for otherwise it may be
> parsed wrong when you use it with integer values."
> 
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 76c9a11..d963a04 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -515,8 +515,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>  			err = -EPERM;
>  		break;
>  	case AUDIT_USER:
> -	case AUDIT_FIRST_USER_MSG...AUDIT_LAST_USER_MSG:
> -	case AUDIT_FIRST_USER_MSG2...AUDIT_LAST_USER_MSG2:
> +	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
> +	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:

hm... We have: 

#define AUDIT_FIRST_USER_MSG    1100    /* Userspace messages mostly uninteresting to kernel */
#define AUDIT_USER_AVC          1107    /* We filter this differently */
#define AUDIT_LAST_USER_MSG     1199

and CPP turns that into

 case 1100 ...1199:
 case 2100 ...2999:

and it does the same when the comments are stripped from the #defines.

So we were saved by the trailing space which cpp added to the expanded
macro.  I wonder why cpp did that, and to what extent one can rely cpp
doing that.

Oh well.  I guess we should apply the patch.
