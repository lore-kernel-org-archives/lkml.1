Return-Path: <linux-kernel-owner+w=401wt.eu-S1762732AbXGRV6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762732AbXGRV6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbXGRV6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:58:15 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:44624 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbXGRV6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:58:14 -0400
Subject: RE: ia64 build failure from recent diskquota patch
From: Doug Chapman <doug.chapman@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       vtaras@openvz.org
In-Reply-To: <617E1C2C70743745A92448908E030B2A01F661D1@scsmsx411.amr.corp.intel.com>
References: <617E1C2C70743745A92448908E030B2A01F661D1@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 17:51:34 -0400
Message-Id: <1184795494.3026.21.camel@deimos.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 14:45 -0700, Luck, Tony wrote:
> > The type compat_u64 on ia64 is defined if CONFIG_COMPAT is defined
> > (which is rare these days on ia64)  So, it appears we are missing
> > an #ifdef CONFIG_COMPAT somewhere in fs/quota.c.  I will leave that
> > up to the original author to determine where.
> 
> Hmmmm ... all of my test config files have CONFIG_COMPAT=y, so I didn't
> notice this.  I'll have to fix one of them to turn it off.
> 
> Perhaps this (untested) is what is needed?
> 
> diff --git a/fs/quota.c b/fs/quota.c
> index e6577ac..ac3af87 100644
> --- a/fs/quota.c
> +++ b/fs/quota.c
> @@ -387,7 +387,7 @@ asmlinkage long sys_quotactl(unsigned int cmd, const char __user *special, qid_t
>  	return ret;
>  }
>  
> -#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
> +#if defined(CONFIG_X86_64) || (defined(CONFIG_IA64) && defined(CONFIG_COMPAT))
>  /*
>   * This code works only for 32 bit quota tools over 64 bit OS (x86_64, ia64)
>   * and is necessary due to alignment problems.

Works for me, compiles just fine now.

ACK

- Doug


