Return-Path: <linux-kernel-owner+w=401wt.eu-S1751803AbZIYGP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbZIYGP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 02:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZIYGP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 02:15:56 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46846 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbZIYGPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 02:15:55 -0400
Date: Thu, 24 Sep 2009 23:15:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: LKLM <linux-kernel@vger.kernel.org>,
       =?utf-8?B?QUtQTeOAgA==?= <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [Patch x86-tip] Clean up the warning message about RCU not
	defined
Message-ID: <20090925061546.GA6829@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4ABC4CAB.7090302@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABC4CAB.7090302@np.css.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 01:52:59PM +0900, Jin Dongming wrote:
> (This fix is for commit 4765c1db84c73f775eb1822a009117cbae524e9e
>    Titled "rcu-tiny: The Bloatwatch Edition, v6")
> 
> When the kernel is built, there is some message printed as
> following:
>     include/linux/rcupdate.h:80:7: \
>         warning: "CONFIG_TINY_RCU" is not defined
> 
> So I did "grep _RCU .config" to search the information of "CONFIG_TINY_RCU"
> in .config file and the result is listed as following:
>     Command:
>         grep _RCU .config
>     Result:
>         CONFIG_TREE_RCU=y
>         # CONFIG_TREE_PREEMPT_RCU is not set
>         # CONFIG_TINY_RCU is not set
>         CONFIG_RCU_TRACE=y
>         CONFIG_RCU_FANOUT=64
>         # CONFIG_RCU_FANOUT_EXACT is not set
>         CONFIG_TREE_RCU_TRACE=y
>         # CONFIG_RCU_TORTURE_TEST is not set
>         # CONFIG_RCU_CPU_STALL_DETECTOR is not set
> 
> Though the "WARNING" does not give impact to build kernel, I think
> it should be cleaned up. And I made the patch for modifying it.
> With this patch there is not any other warning message of
> CONFIG_TINY_RCU and the kernel could be built successfully. And I
> confirmed that the built kernel works well.

Good catch!!!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> ---
>  include/linux/rcupdate.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index b2f1e10..fe5c560 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -77,7 +77,7 @@ extern int rcu_scheduler_active;
> 
>  #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
>  #include <linux/rcutree.h>
> -#elif CONFIG_TINY_RCU
> +#elif defined(CONFIG_TINY_RCU)
>  #include <linux/rcutiny.h>
>  #else
>  #error "Unknown RCU implementation specified to kernel configuration"
> -- 
> 1.6.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
