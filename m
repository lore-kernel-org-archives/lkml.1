Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbXEJEK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbXEJEK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 00:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXEJEKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 00:10:20 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:34548 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbXEJEKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 00:10:19 -0400
Message-ID: <46429B13.6090402@linux.vnet.ibm.com>
Date: Thu, 10 May 2007 09:39:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: menage@google.com, vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net,
       balbir@in.ibm.com, haveblue@us.ibm.com, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, devel@openvz.org, ebiederm@xmission.com,
       mbligh@google.com, rohitseth@google.com, serue@us.ibm.com,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] [PATCH 1/9] Containers (V9): Basic container framework
References: <20070427104607.252541000@menage.corp.google.com> <20070427111300.015604000@menage.corp.google.com> <46377BA4.6030701@linux.vnet.ibm.com> <20070501114030.62b85494.pj@sgi.com> <46380901.2050001@linux.vnet.ibm.com> <20070501231254.4267777e.pj@sgi.com>
In-Reply-To: <20070501231254.4267777e.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Balbir wrote:

> 
> 1) Testing batch schedulers against cpusets:
> 
>     I doubt that the batch scheduler developers would be able to
>     extract a cpuset test from their tests, or be able to share it if
>     they did.  Their tests tend to be large tests of batch schedulers,
>     and only incidentally test cpusets -- if we break cpusets,
>     in sometimes even subtle ways that they happen to depend on,
>     we break them.
> 
>     Sometimes there is no way to guess exactly what sorts of changes
>     will break their code; we'll just have to schedule at least one
>     run through one or more of them that rely heavily on cpusets
>     before a change as big as rebasing cpusets on containers is
>     reasonably safe.  This test cycle won't be all that easy, so I'd
>     wait until we are pretty close to what we think should be taken
>     into the mainline kernel.
> 
>     I suppose I will have to be the one co-ordinating this test,
>     as I am the only one I know with a presence in both camps.
> 
>     Once this test is done, from then forward, if we break them,
>     we'll just have to deal with it as we do now, when the breakage
>     shows up well down stream from the main kernel tree, at the point
>     that a major batch scheduler release runs into a major distribution
>     release containing the breakage.  There is no practical way that I
>     can see, as an ongoing basis, to continue testing for such breakage
>     with every minor change to cpuset related code in the kernel.  Any
>     breakage found this way is dealt with by changes in user level code.
> 
>     Once again, I have bcc'd one or more developers of batch schedulers,
>     so they can see what nonsense I am spouting about them now ;).
> 

That sounds reasonable to me

> 2) Testing cpusets with a specific test.
> 
>     There I can do better.  Attached is the cpuset regression test I
>     use.  It requires at least 4 cpus and 2 memory nodes to do anything
>     useful.  It is copyright by SGI, released under GPL license.
> 
>     This regression test is the primary cpuset test upon which I
>     relied during the development of cpusets, and continue to rely.
>     Except for one subtle race condition in the test itself, it has
>     not changed in the last two to three years.
> 
>     This test requires no user level code not found in an ordinary
>     distro.  It does require the taskset and numactl commands,
>     for the purposes of testing certain interactions with them.
>     It assumes that there are not other cpusets currently setup in
>     the system that happen to conflict with the ones it creates.
> 
>     See further comments within the test script itself.
> 

Thanks for the script. Would you like to contribute this script to
LTP for wider availability and testing?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
