Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbXDLVB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbXDLVB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbXDLVB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:01:58 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:61014 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbXDLVB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:01:56 -0400
Message-ID: <461E9DEF.3090707@in.ibm.com>
Date: Fri, 13 Apr 2007 02:30:31 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelianov <xemul@sw.ru>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@sw.ru>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH] Cpu statistics accounting based on Paul Menage patches
References: <461CF883.2030308@sw.ru> <20070411114927.1277d7c9.akpm@linux-foundation.org>
In-Reply-To: <20070411114927.1277d7c9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 11 Apr 2007 19:02:27 +0400
> Pavel Emelianov <xemul@sw.ru> wrote:
> 
>> Provides a per-container statistics concerning the numbers of tasks
>> in various states, system and user times, etc. Patch is inspired
>> by Paul's example of the used CPU time accounting. Although this
>> patch is independent from Paul's example to make it possible playing
>> with them separately.
> 
> Why is this actually needed?  If userspace has a list of the tasks which
> are in a particular container, it can run around and add up the stats for
> those tasks without kernel changes?
> 
> It's a bit irksome that we have so much accounting of this form in core
> kernel, yet we have to go and add a completely new implementation to create
> something which is similar to what we already have.  But I don't
> immediately see a fix for that.  Apart from paragraph #1 ;)
> 
> Should there be linkage between per-container stats and
> delivery-via-taskstats?  I can't think of one, really.
> 
> You have cpu stats.  Later, presumably, we'll need IO stats, MM stats,
> context-switch stats, number-of-syscall stats, etc, etc.  Are we going to
> reimplement all of those things as well?  See paragraph #1!
> 
> Bottom line: I think we seriously need to find some way of consolidating
> per-container stats with our present per-task stats.  Perhaps we should
> instead be looking at ways in which we can speed up paragraph #1.


This should be easy to build. per container stats can live in parallel
with per-task stats, but they can use the same general mechanism for
data communication to user space.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
