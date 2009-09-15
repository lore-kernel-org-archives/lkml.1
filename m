Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbZIOMMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbZIOMMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZIOMMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:12:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:56195 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZIOMMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:12:03 -0400
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 14:11:41 +0200
Message-Id: <1253016701.5506.73.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 17:36 +0530, Gautham R Shenoy wrote:
> This patchset contains the offline state driver implemented for
> pSeries. For pSeries, we define three available_hotplug_states. They are:
> 
>         online: The processor is online.
> 
>         offline: This is the the default behaviour when the cpu is offlined
>         even in the absense of this driver. The CPU would call make an
>         rtas_stop_self() call and hand over the CPU back to the resource pool,
>         thereby effectively deallocating that vCPU from the LPAR.
>         NOTE: This would result in a configuration change to the LPAR
>         which is visible to the outside world.
> 
>         inactive: This cedes the vCPU to the hypervisor with a cede latency
>         specifier value 2.
>         NOTE: This option does not result in a configuration change
>         and the vCPU would be still entitled to the LPAR to which it earlier
>         belong to.
> 
> Any feedback on the patchset will be immensely valuable.

I still think its a layering violation... its the hypervisor manager
that should be bothered in what state an off-lined cpu is in. 



