Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZH1Glf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZH1Glf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 02:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZH1Gle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 02:41:34 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:42620 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZH1Gld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 02:41:33 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/4]: CPUIDLE: Introduce architecture independent
 cpuidle_pm_idle in drivers/cpuidle/cpuidle.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20090828044901.GA10283@linux.vnet.ibm.com>
References: <20090827114908.GA24986@linux.vnet.ibm.com>
	 <20090827115354.GC24986@linux.vnet.ibm.com>
	 <1251377607.18584.96.camel@twins>
	 <20090828044901.GA10283@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 08:40:11 +0200
Message-Id: <1251441611.18584.112.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-28 at 10:19 +0530, Arun R Bharadwaj wrote:
> 
> 
> This only does the job of picking the right idle loop for current
> latency and power requirement. This is already done in ladder/menu
> governors under the routines menu_select()/ladder_select().
> I'm not sure whats the purpose of it here.

I can't seem to find ladder_select() but menu_select() doesn't manage
pm_idle and its not clear what it does manage.

> Here we are only concerned about the main idle loop, which is
> pm_idle/ppc_md.power_save. After setting the main idle loop to
> cpuidle_pm_idle, that would call cpuidle_idle_call() which would do
> the job of picking the right low level idle loop based on latency and
> other requirements.

It also gets pm_idle unexported and avoids anybody directly tinkering
with the function pointer, _that_ is the whole goal.

pm_idle is it exists today, and the whole cpuidle_{un,}install*() is
utter crap. It relies on unmanaged access to this function pointer.

/me stop looking at drivers/cpuidle/, convoluted mess that is, shame on
you for wanting to have anything to do with it.



