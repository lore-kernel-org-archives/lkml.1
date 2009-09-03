Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZICBNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZICBNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 21:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbZICBNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 21:13:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49663 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbZICBNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 21:13:12 -0400
Message-ID: <4A9F17DD.4050807@cn.fujitsu.com>
Date: Thu, 03 Sep 2009 09:11:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: Introduce new (non-)paranoia
 level to allow raw tracepoint access
References: <new-submission> <tip-5380c1056d267eff49854c1fa03399bfe761da1e@git.kernel.org>
In-Reply-To: <tip-5380c1056d267eff49854c1fa03399bfe761da1e@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static inline bool perf_paranoid_cpu(void)
>  {
>  	return sysctl_perf_counter_paranoid > 0;
> @@ -3971,6 +3977,7 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
>  	 * have these.
>  	 */
>  	if ((counter->attr.sample_type & PERF_SAMPLE_RAW) &&
> +			&& perf_paranoid_tracepoint_raw() &&

"&& &&"

This leads to build failure.

>  			!capable(CAP_SYS_ADMIN))
>  		return ERR_PTR(-EPERM);
>  
