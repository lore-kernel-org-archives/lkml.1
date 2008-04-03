Return-Path: <linux-kernel-owner+w=401wt.eu-S1760273AbYDCSM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbYDCSM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYDCSMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:12:17 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:53606 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbYDCSMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:12:17 -0400
Message-ID: <47F51DE7.7010204@linux.vnet.ibm.com>
Date: Thu, 03 Apr 2008 23:41:51 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v7)
References: <20080403174433.26356.42121.sendpatchset@localhost.localdomain> <6599ad830804031058l1e2a7ad9p56cff47dca738d79@mail.gmail.com>
In-Reply-To: <6599ad830804031058l1e2a7ad9p56cff47dca738d79@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Apr 3, 2008 at 10:44 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  +
>>  +       /*
>>  +        * If there are other users of the mm and the owner (us) is exiting
>>  +        * we need to find a new owner to take on the responsibility.
>>  +        * When we use thread groups (CLONE_THREAD), the thread group
>>  +        * leader is kept around in zombie state, even after it exits.
>>  +        * delay_group_leader() ensures that if the group leader is around
>>  +        * we need not select a new owner.
>>  +        */
> 
> Hmm, is this new check for delay_group_leader() safe? Won't we have
> called exit_cgroup() by this point, and hence be reassigned to the
> root cgroup? And so mm->owner->cgroups won't point to the right place?
> 

cgroup_exit() comes in much later after exit_mm(). Moreover delay_group_leader()
is a function that checks to see if

We are the group leader and the thread group is not empty.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
