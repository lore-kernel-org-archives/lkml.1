Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab0BPJJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 04:09:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab0BPJJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:09:08 -0500
Message-ID: <4B7A6180.8020306@redhat.com>
Date: Tue, 16 Feb 2010 17:12:32 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Octavian Purdila <opurdila@ixiacom.com>
CC: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v4 2/3] sysctl: add proc_dobitmap
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <1266271241-6293-3-git-send-email-opurdila@ixiacom.com>
In-Reply-To: <1266271241-6293-3-git-send-email-opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
> The new function can be used to update bitmaps via /proc. Bits can be
> set by writing positive values in the file and cleared by writing
> negative values (e.g. 0 2 will set bits 1 and 3, -0 -2 will clear
> them). Reading will show only the set bits.
> 
> Signed-off-by: Octavian Purdila <opurdila@ixiacom.com>
> Cc: WANG Cong <amwang@redhat.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  include/linux/sysctl.h |    2 +
>  kernel/sysctl.c        |   76 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 78 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 9f236cd..ba89bf2 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -985,6 +985,8 @@ extern int proc_doulongvec_minmax(struct ctl_table *, int,
>  				  void __user *, size_t *, loff_t *);
>  extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
>  				      void __user *, size_t *, loff_t *);
> +extern int proc_dobitmap(struct ctl_table *, int,
> +			 void __user *, size_t *, loff_t *);
>  
>  /*
>   * Register a set of sysctl names by calling register_sysctl_table
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index b0f9618..b8959f4 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2596,6 +2596,82 @@ static int proc_do_cad_pid(struct ctl_table *table, int write,
>  	return 0;
>  }
>  
> +/**
> + * proc_dobitmap - read/write from/to a bitmap
> + * @table: the sysctl table
> + * @write: %TRUE if this is a write to the sysctl file
> + * @buffer: the user buffer
> + * @lenp: the size of the user buffer
> + * @ppos: file position
> + * @ppos: the current position in the file


Duplicated.

I hope Eric can also comment on these two patches.
