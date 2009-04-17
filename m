Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbZDQSGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbZDQSGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757406AbZDQSGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:06:31 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57586 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbZDQSGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:06:30 -0400
Date: Fri, 17 Apr 2009 13:06:13 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dan Smith <danms@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Make new_utsname fields use the proper length constant
Message-ID: <20090417180613.GA22658@us.ibm.com>
References: <1239988696-18140-1-git-send-email-danms@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239988696-18140-1-git-send-email-danms@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dan Smith (danms@us.ibm.com):
> The members of the new_utsname structure are defined with magic numbers
> that *should* correspond to the constant __NEW_UTS_LEN+1.  Everywhere else,
> code assumes this and uses the constant, so this patch makes the structure
> match.
> 
> Originally suggested by Serge here:
> 
> https://lists.linux-foundation.org/pipermail/containers/2009-March/016258.html
> 
> Signed-off-by: Dan Smith <danms@us.ibm.com>
> Cc: containers@lists.linux-foundation.org
> Cc: akpm@linux-foundation.org
> Cc: serue@us.ibm.com

I realize it's weird putting __NEW_UTS_LEN+1 in the
length for struct old_utsname :), but you didn't make
up the names, so I would argue just do it for both
old_utsname and oldold_utsname too...

But of course even if you don't want to,

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks, Dan.

-serge

> ---
>  include/linux/utsname.h |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/utsname.h b/include/linux/utsname.h
> index 1123267..3656b30 100644
> --- a/include/linux/utsname.h
> +++ b/include/linux/utsname.h
> @@ -22,12 +22,12 @@ struct old_utsname {
>  };
> 
>  struct new_utsname {
> -	char sysname[65];
> -	char nodename[65];
> -	char release[65];
> -	char version[65];
> -	char machine[65];
> -	char domainname[65];
> +	char sysname[__NEW_UTS_LEN + 1];
> +	char nodename[__NEW_UTS_LEN + 1];
> +	char release[__NEW_UTS_LEN + 1];
> +	char version[__NEW_UTS_LEN + 1];
> +	char machine[__NEW_UTS_LEN + 1];
> +	char domainname[__NEW_UTS_LEN + 1];
>  };
> 
>  #ifdef __KERNEL__
> -- 
> 1.5.6.3
