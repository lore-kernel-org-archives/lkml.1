Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYCKKUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYCKKUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbYCKKUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:20:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42968 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbYCKKUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:20:03 -0400
Date: Tue, 11 Mar 2008 19:21:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 1/3] res_counter: introduce res_counter_write_u64()
Message-Id: <20080311192117.f7e23636.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47D65A27.80605@cn.fujitsu.com>
References: <47D65A27.80605@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 19:08:39 +0900
Li Zefan <lizf@cn.fujitsu.com> wrote:

> This function can be used to assign the value of a resource counter member.
> 
Why don't you make this function to do the same work as res_counter_write() ?

Thanks,
-Kame


> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/res_counter.h |    9 ++++++---
>  kernel/res_counter.c        |    9 +++++++++
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index 8cb1ecd..8c23f7f 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -41,9 +41,10 @@ struct res_counter {
>  
>  /**
>   * Helpers to interact with userspace
> - * res_counter_read_u64() - returns the value of the specified member.
> - * res_counter_read/_write - put/get the specified fields from the
> - * res_counter struct to/from the user
> + * res_counter_read_64/_write_u64 - returns/assigns the value of the
> + *	specified member
> + * res_counter_read/_write - puts/gets the specified fields from the
> + *	res_counter struct to/from the user
>   *
>   * @counter:     the counter in question
>   * @member:  the field to work with (see RES_xxx below)
> @@ -53,6 +54,8 @@ struct res_counter {
>   */
>  
>  u64 res_counter_read_u64(struct res_counter *counter, int member);
> +void res_counter_write_u64(struct res_counter *counter, int member,
> +			   unsigned long long val);
>  
>  ssize_t res_counter_read(struct res_counter *counter, int member,
>  		const char __user *buf, size_t nbytes, loff_t *pos,
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 791ff2b..a16b727 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -97,6 +97,15 @@ u64 res_counter_read_u64(struct res_counter *counter, int member)
>  	return *res_counter_member(counter, member);
>  }
>  
> +void res_counter_write_u64(struct res_counter *counter, int member,
> +			   unsigned long long val)
> +{
> +	unsigned long long *tmp;
> +
> +	tmp = res_counter_member(counter, member);
> +	*tmp = val;
> +}
> +
>  ssize_t res_counter_write(struct res_counter *counter, int member,
>  		const char __user *userbuf, size_t nbytes, loff_t *pos,
>  		int (*write_strategy)(char *st_buf, unsigned long long *val))
> -- 
> 1.5.4.rc3
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

