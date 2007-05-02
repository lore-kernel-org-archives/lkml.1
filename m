Return-Path: <linux-kernel-owner+w=401wt.eu-S2992687AbXEBDo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992687AbXEBDo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161591AbXEBDo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:44:26 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:54474 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161512AbXEBDoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:44:24 -0400
Message-ID: <46380901.2050001@linux.vnet.ibm.com>
Date: Wed, 02 May 2007 09:14:01 +0530
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
References: <20070427104607.252541000@menage.corp.google.com> <20070427111300.015604000@menage.corp.google.com> <46377BA4.6030701@linux.vnet.ibm.com> <20070501114030.62b85494.pj@sgi.com>
In-Reply-To: <20070501114030.62b85494.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
>   [[ I have bcc'd one or more batch scheduler experts on this post.
>      They will know who they are, and should be aware that they are
>      not listed in the public cc list of this message.     - pj ]]
> 
> Balbir Singh, responding to Paul Menage's Container patch set on lkml, wrote:
>>> +*** notify_on_release is disabled in the current patch set. It may be
>>> +*** reactivated in a future patch in a less-intrusive manner
>>> +
>> Won't this break user space tools for cpusets?
> 
> 
> Yes - disabling notify_on_release would definitely break some important
> uses of cpusets.  This feature must be reactivated somehow before I'll
> sign up for putting this patch set in the main line.
> 
> Actually, after I posted a few days ago in another lkml post:
> 	http://lkml.org/lkml/2007/4/29/66
> 
> that just the simplest cpuset command:
> 	mount -t cpuset cpuset /dev/cpuset
> 	mkdir /dev/cpuset/foo
> 	echo 0 > /dev/cpuset/foo/mems
> 
> caused an immediate kernel deadlock (Srivatsa has proposed a fix), it
> is pretty clear that this container patch set is not getting the cpuset
> testing it will need for acceptance.  That's partly my fault.
> 
> The batch scheduler folks, such as the variants of PBS, LSF and SGE are
> major user of cpusets on NUMA hardware.
> 
> This container based replacement for cpusets isn't ready for the main
> line until at least one of those schedulers can run through one of
> their test suites.  I hesitate to even acknowledge this, as I might be
> the only person in a position to make this happen, and my time
> available to contribute to this patch set has been less than I would
> like.
> 
> But if it looks like we have all the pieces in place to base cpusets
> on containers, with no known regressions in cpuset capability, then
> we must find a way to ensure that one of these batch schedulers, using
> cpusets on a NUMA box, still works.
> 

Would it be possible to extract those test cases and integrate them
with a testing framework like LTP? Do you have any regression test
suite for cpusets that can be made available publicly so that
any changes to cpusets can be validated?

The reason I ask for the test suite is that I suspect that the
container framework will evolve further and a reliable testing
mechanism would be extremely useful.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
