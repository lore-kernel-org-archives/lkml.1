Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0BIRBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:01:00 -0500
Received: from xenotime.net ([72.52.64.118]:49458 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754972Ab0BIRA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:00:57 -0500
Message-ID: <4B7194C6.8010306@xenotime.net>
Date: Tue, 09 Feb 2010 09:00:54 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: arun@linux.vnet.ibm.com
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [v11 PATCH 1/9]: cpuidle: Design documentation patch
References: <20100209082815.GA29988@linux.vnet.ibm.com> <20100209082914.GB29988@linux.vnet.ibm.com>
In-Reply-To: <20100209082914.GB29988@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/10 00:29, Arun R Bharadwaj wrote:
> * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2010-02-09 13:58:16]:
> 
> This patch adds a little information about the redesigned cpuidle
> infrastructure in Documentation/cpuidle/core.txt
> 
> Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
> ---
>  Documentation/cpuidle/core.txt |   35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> Index: linux.trees.git/Documentation/cpuidle/core.txt
> ===================================================================
> --- linux.trees.git.orig/Documentation/cpuidle/core.txt
> +++ linux.trees.git/Documentation/cpuidle/core.txt
> @@ -21,3 +21,38 @@ which can be used to switch governors at
>  is meant for developer testing only. In normal usage, kernel picks the
>  best governor based on governor ratings.
>  SEE ALSO: sysfs.txt in this directory.
> +
> +Design:
> +
> +Cpuidle allows for registration of multiple sets of idle routines.
> +The latest registered set is used by cpuidle governors as the current
> +active set to choose the right idle state. This set is managed as a
> +list and each time the newly registered set is added to the head of the
> +list and made the current active set.
> +
> +An example of how this would work on x86 is shown below.
> +
+-----------------					-----------------
+|		|					|		|
+| choose b/w	|	mwait is chosen			|    mwait	|
+| mwait, poll,	|-------------------------------------> |(current active|
+| default, c1e	|	register to cpuidle		|    set)	|
+|		|	with mwait as the idle routine	|		|
+-----------------					-----------------

What is "b/w" above?  "between"?  I've see "btw" used a few times as an
abbreviation for between, but I don't recall ever seeing b/w.
OTOH, I have seen b/w used for bandwidth.


> +
> +
> +-----------------					-----------------
> +|		|					|  c1, c2, c3	|
> +|     ACPI	|	register to cpuidle		|   (current)	|
> +|   discovery	|-------------------------------------> |---------------|
> +|		|	with c1, c2, c3			|     mwait	|
> +|		|	as set of idle routines		|		|
> +-----------------					-----------------
> +
> +With this mechanism, a module can register and unregister its set of
> +idle routines at run time in a clean manner.
> +
> +The main idle routine called inside cpu_idle() of every arch is defined in
> +driver/cpuidle/cpuidle.c which would in turn call the idle routine selected

   drivers/

> +by the governor. If the CONFIG_CPU_IDLE is disabled, the arch needs to
> +provide an alternate definition for cpuidle_idle_call().


-- 
~Randy
