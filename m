Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZLDWUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZLDWUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZLDWUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:20:23 -0500
Received: from verein.lst.de ([213.95.11.210]:34733 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbZLDWUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:20:22 -0500
From: Torsten Duwe <duwe@lst.de>
Organization: LST e.V.
To: arun@linux.vnet.ibm.com
Subject: Re: [v10 PATCH 2/9]: cpuidle: cleanup drivers/cpuidle/cpuidle.c
Date: Fri, 4 Dec 2009 23:20:00 +0100
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20091202095427.GA27251@linux.vnet.ibm.com> <20091202095705.GC27251@linux.vnet.ibm.com>
In-Reply-To: <20091202095705.GC27251@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912042320.01320.duwe@lst.de>
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 December 2009, Arun R Bharadwaj wrote:
> * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-12-02 15:24:27]:
>
> This patch cleans up drivers/cpuidle/cpuidle.c
> Earlier cpuidle assumed pm_idle as the default idle loop. Break that
> assumption and make it more generic.

Is there a problem with the old pm_idle? Couldn't it be integrated more 
transparently, instead of replacing it this intrusively?

> --- linux.trees.git.orig/include/linux/cpuidle.h
> +++ linux.trees.git/include/linux/cpuidle.h
> @@ -41,7 +41,7 @@ struct cpuidle_state {
>  	unsigned long long	usage;
>  	unsigned long long	time; /* in US */
>
> -	int (*enter)	(struct cpuidle_device *dev,
> +	void (*enter)	(struct cpuidle_device *dev,
>  			 struct cpuidle_state *state);
>  };

While it may be a good idea to move the residency calculation to one central 
place, at least in theory a cpuidle_state->enter() function could have a 
better method to determine its value.

Either way you're implicitly introducing an API change here, and you're at 
least missing two functions on ARM and SuperH, respectively. Could you 
separate this API change out, and not take it for granted in the other 
patches?

	Torsten
