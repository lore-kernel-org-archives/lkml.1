Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZCCDQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZCCDQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 22:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbZCCDQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 22:16:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61361 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbZCCDQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 22:16:27 -0500
Message-ID: <49ACA13B.5050106@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 11:17:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] Allow cpusets to be configured/built on non-SMP systems
References: <20090303013432.11211.18662.stgit@menage.corp.google.com>
In-Reply-To: <20090303013432.11211.18662.stgit@menage.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Allow cpusets to be configured/built on non-SMP systems
> 
> Currently it's impossible to build cpusets under UML on x86-64, since
> cpusets depends on SMP and x86-64 UML doesn't support SMP.
> 
> There's code in cpusets that doesn't depend on SMP.  This patch
> surrounds the minimum amount of cpusets code with #ifdef CONFIG_SMP in
> order to allow cpusets to build/run on UP systems (for testing
> purposes under UML).
> 

The patch is ok for this purpose.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> Signed-off-by: Paul Menage <menage@google.com>
> 
> ---
> 
>  init/Kconfig    |    2 +-
>  kernel/cpuset.c |   14 ++++++++++++++
>  2 files changed, 15 insertions(+), 1 deletions(-)
...
> +static int generate_sched_domains(struct cpumask **domains,
> +			struct sched_domain_attr **attributes)
> +{

Except here should "return 0;", otherwise emit a compile warining.

> +}
