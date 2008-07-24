Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbYGXM5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbYGXM5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYGXM5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:57:05 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:41913 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbYGXM5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eY85pAfvTTbtk10uIsTjUcUx3Tk0fZ1SVUo7zG3gy9vgChWNHTHB5Zhw3DtPkl0fXs
         V1KQwEhCVMqjd0Tiuqt2x2wGaAbO+8eC0ib7ZkGO1NkJqTZG9PsNnT8EIez6FNoP8o9J
         oPMn/R6RSb5N2cH8bKmkrVYvZXpKENCDGQf88=
Message-ID: <36ca99e90807240556j6b409a03s239d781baaadbb99@mail.gmail.com>
Date: Thu, 24 Jul 2008 14:56:59 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use cpumask_of_cpu_map
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Jack Steiner" <steiner@sgi.com>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Len Brown" <len.brown@intel.com>,
       "Lennert Buytenhek" <kernel@wantstofly.org>,
       "Dave Jones" <davej@codemonkey.org.uk>, "Paul Jackson" <pj@sgi.com>,
       "Tony Luck" <tony.luck@intel.com>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       "Paul Mackerras" <paulus@samba.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Robert Richter" <robert.richter@amd.com>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Sam Creasey" <sammy@sammy.net>, "Greg Banks" <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Adrian Bunk" <bunk@kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andreas Schwab" <schwab@suse.de>,
       "Johannes Weiner" <hannes@saeurebad.de>
In-Reply-To: <20080723171841.997896000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080723171841.815234000@polaris-admin.engr.sgi.com>
	 <20080723171841.997896000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 23, 2008 at 19:18, Mike Travis <travis@sgi.com> wrote:
> --- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
> +++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
> @@ -80,8 +80,15 @@ static void __init setup_per_cpu_maps(vo
>  #endif
>  }
>
> -#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
> -cpumask_t *cpumask_of_cpu_map __read_mostly;
> +#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP_PTR
> +/*
> + * Configure an initial cpumask_of_cpu(0) for early users
> + */
> +static cpumask_t initial_cpumask_of_cpu_map __initdata = (cpumask_t) { {
> +       [BITS_TO_LONGS(NR_CPUS)-1] = 1
> +} };
This looks weird, first one missing {} pair, which may explain Ingo's
build error. Second, why do you want to set the last unsigned long to
one? Shouldn't this be the first?

Regards
Bert


> +cpumask_t *cpumask_of_cpu_map __read_mostly =
> +       (cpumask_t *)&initial_cpumask_of_cpu_map;
>  EXPORT_SYMBOL(cpumask_of_cpu_map);
>
