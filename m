Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZI3RcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZI3RcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbZI3RcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:32:23 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:48631 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbZI3RcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:32:22 -0400
Date: Wed, 30 Sep 2009 10:31:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v3 2/3] cpu: Offline state Framework.
Message-Id: <20090930103113.4361619d.randy.dunlap@oracle.com>
In-Reply-To: <20090915120706.20523.95464.stgit@sofia.in.ibm.com>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
	<20090915120706.20523.95464.stgit@sofia.in.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AC395E5.014D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 17:37:06 +0530 Gautham R Shenoy wrote:

> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> ---
>  Documentation/cpu-hotplug.txt |   22 +++++
>  drivers/base/cpu.c            |  181 +++++++++++++++++++++++++++++++++++++++--
>  include/linux/cpu.h           |   10 ++
>  3 files changed, 204 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
> index 9d620c1..dcec06d 100644
> --- a/Documentation/cpu-hotplug.txt
> +++ b/Documentation/cpu-hotplug.txt
> @@ -115,6 +115,28 @@ Just remember the critical section cannot call any
>  function that can sleep or schedule this process away. The preempt_disable()
>  will work as long as stop_machine_run() is used to take a cpu down.
>  
> +CPU-offline states
> +--------------------------------------
> +On architectures which allow the more than one valid state when

                                ^drop "the"

> +the CPU goes offline, the system administrator can decide
> +the state the CPU needs to go to when it is offlined.

s/needs to/should/

> +
> +If the architecture has implemented a cpu-offline driver exposing these
> +multiple offline states, the system administrator can use the following sysfs
> +interfaces to query the available hotplug states and also query and set the
> +current hotplug state for a given cpu:
> +
> +To query the hotplug states, on needs to perform a read on:

                                one

> +/sys/devices/system/cpu/cpu<number>/available_hotplug_states
> +
> +To query or set the current state for a particular CPU,
> +one needs to use the sysfs interface
> +
> +/sys/devices/system/cpu/cpu<number>/current_hotplug_state
> +
> +Writes to the "online" sysfs files are serialized against the writes to the
> +"current_hotplug_state" file.
> +
>  CPU Hotplug - Frequently Asked Questions.
>  
>  Q: How to enable my kernel to support CPU hotplug?


---
~Randy
