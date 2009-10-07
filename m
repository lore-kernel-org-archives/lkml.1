Return-Path: <linux-kernel-owner+w=401wt.eu-S933412AbZJGNC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412AbZJGNC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbZJGNCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:02:25 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:11452 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbZJGNCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:02:24 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [v7 PATCH 0/7]: cpuidle/x86/POWER: Cleanup idle power
 management code in x86, cleanup drivers/cpuidle/cpuidle.c and introduce
 cpuidle to POWER.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Arjan van de Ven <arjan@infradead.org>, arun@linux.vnet.ibm.com,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20091007112648.GC7646@dirshya.in.ibm.com>
References: <20091006152421.GA7278@linux.vnet.ibm.com>
	 <20091006163521.GA10425@linux.vnet.ibm.com>
	 <1254852279.17055.2.camel@laptop>
	 <20091007112648.GC7646@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 15:05:11 +0200
Message-Id: <1254920711.26976.243.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 16:56 +0530, Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-10-06 20:04:39]:
> 
> > On Tue, 2009-10-06 at 22:05 +0530, Arun R Bharadwaj wrote:
> > 
> > > Also, the per-cpu nature of registration/unregistration of cpuidle
> > > has been maintained as ACPI needs this.
> > 
> > Right, so can't we ditch that and have acpi default to the lowest
> common
> > C-state and warn when various cpus report different C-states?
> 
> Hi Peter,
> 
> As Arjan mentioned previously, the per-cpu registration has to stay
> for x86 for now due to legacy ACPI compatibility.  Breaking that may
> break lot of existing users and we do not have a clean fallback
> method.  

>From what I understood some broken ass bioses report different C state
availability on different CPUs in the same SMP system.

I'm suggesting to work around that by limiting all CPUs to the subset of
C states reported on all CPUs, instead of the current mess.

I haven't heard anybody tell me why that wouldn't be possible on x86

