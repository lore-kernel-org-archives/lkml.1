Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbYLJCJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbYLJCJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 21:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYLJCJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 21:09:39 -0500
Received: from mga06.intel.com ([134.134.136.21]:34927 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754047AbYLJCJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 21:09:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,743,1220252400"; 
   d="scan'208";a="472620470"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 0/2] module_refcounting and anonymous inodes
Date: Wed, 10 Dec 2008 10:05:09 +0800
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; x86_64; ; )
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <200812021114.59050.borntraeger@de.ibm.com> <493E452E.4020304@redhat.com> <493E7122.5010904@redhat.com>
In-Reply-To: <493E7122.5010904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812101005.10492.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 December 2008 21:22:42 Avi Kivity wrote:
> Avi Kivity wrote:
> > Christian Borntraeger wrote:
> >> The problem is, how do you detect if the base kernel has patch1 applied?
> >
> > In the external module compatibility kit, implement two versions of
> > anon_inode_getfd(), and select the appropriate one according to kernel
> > version (like we currently support 91 smp_call_function_single variants).
>
> I committed something simpler:  if running on 2.6.28 or earlier, I hack
> out the two lines your second patch adds.\

Good hack! 

> diff --git a/kernel/external-module-compat-comm.h
> b/kernel/external-module-compat-comm.h index a089f62..d90522d 100644
> --- a/kernel/external-module-compat-comm.h
> +++ b/kernel/external-module-compat-comm.h
> @@ -682,3 +682,13 @@ static inline void cpumask_clear_cpu(int cpu,
> cpumask_var_t mask)
>
>  #endif
>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)

But should it be 2,6,29?...

-- 
regards
Yang, Sheng

> +
> +#define IF_ANON_INODES_DOES_REFCOUNTS(x)
> +
> +#else
> +
> +#define IF_ANON_INODES_DOES_REFCOUNTS(x) x
> +
> +#endif
> +
