Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbZFLRWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbZFLRWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZFLRWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:22:08 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:63768 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZFLRWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:22:07 -0400
Message-ID: <4A328DBE.2030905@oracle.com>
Date: Fri, 12 Jun 2009 10:17:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counters: start documenting HAVE_PERF_COUNTERS requirements
References: <1244827063-24046-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1244827063-24046-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=windows-1250
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A328E93.020C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> Help out arch porters who want to support perf counters by listing some
> basic requirements.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> i imagine more details would be good, but this is a starting point and
> better than nothing
> 
>  init/Kconfig          |    2 ++
>  tools/perf/design.txt |   15 +++++++++++++++
>  2 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index c649657..20f85b1 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -936,6 +936,8 @@ config AIO
>  
>  config HAVE_PERF_COUNTERS
>  	bool
> +	help
> +	  See end of tools/perf/design.txt

How about
	  See "Arch requirements" in tools/perf/design.txt
since it doesn't need to be at the end of the file forever.

>  
>  menu "Performance Counters"
>  
> diff --git a/tools/perf/design.txt b/tools/perf/design.txt
> index 860e116..f71e0d2 100644
> --- a/tools/perf/design.txt
> +++ b/tools/perf/design.txt
> @@ -440,3 +440,18 @@ by this process or by another, and doesn't affect any counters that
>  this process has created on other processes.  It only enables or
>  disables the group leaders, not any other members in the groups.
>  
> +
> +Arch requirements
> +-----------------
> +
> +If your architecture does not have hardware performance metrics, you can
> +still use the generic software counters based on hrtimers for sampling.
> +
> +So to start with, in order to add HAVE_PERF_COUNTERS to your Kconfig, you
> +will need at least this:
> +	- asm/perf_counter.h - a basic stub will suffice at first
> +	- support for atomic64 types (and associated helper functions)
> +	- set_perf_counter_pending() implemented
> +
> +If your architecture does have hardware capabilities, you can override the
> +weak stub hw_perf_counter_init() to register hardware counters.


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
