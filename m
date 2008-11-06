Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYKFH3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYKFH3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbYKFH2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:28:32 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:48296 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYKFH2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:28:31 -0500
Message-ID: <49129601.4040008@linux.vnet.ibm.com>
Date: Thu, 06 Nov 2008 12:30:17 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [mm] [PATCH 4/4] Memory cgroup hierarchy feature selector
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop> <20081101184902.2575.11443.sendpatchset@balbir-laptop> <20081102143817.99edca6d.kamezawa.hiroyu@jp.fujitsu.com> <490D42C7.4000301@linux.vnet.ibm.com> <20081102152412.2af29a1b.kamezawa.hiroyu@jp.fujitsu.com> <490DCCC9.5000508@linux.vnet.ibm.com> <6599ad830811032237q14c065efx4316fee8f8daa515@mail.gmail.com>
In-Reply-To: <6599ad830811032237q14c065efx4316fee8f8daa515@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Sun, Nov 2, 2008 at 7:52 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> That should not be hard, but having it per-subtree sounds a little complex in
>> terms of exploiting from the end-user perspective and from symmetry perspective
>> (the CPU cgroup controller provides hierarchy control for the full hierarchy).
>>
> 
> The difference is that the CPU controller works in terms of shares,
> whereas memory works in terms of absolute memory size. So it pretty
> much has to limit the hierarchy to a single tree. Also, I didn't think
> that you could modify the shares for the root cgroup - what would that
> mean if so?
> 

The shares are proportional for the CPU controller. I am confused as to which
shares (CPU you are talking about?

> With this patch set as it is now, the root cgroup's lock becomes a
> global memory allocation/deallocation lock, which seems a bit painful.

Yes, true, but then that is the cost associated with using a hierarchy.

> Having a bunch of top-level cgroups each with their own independent
> memory limits, and allowing sub cgroups of them to be constrained by
> the parent's memory limit, seems more useful than a single hierarchy
> connected at the root.

That is certainly do-able, but can be confusing to users, given how other
controllers work. We can document that

> 
> In what realistic circumstances do you actually want to limit the root
> cgroup's memory usage?
> 

Good point, I would expect that people would mostly use the hierarchy with
soft-limits or shares. I am now beginning to like Kamezawa and your suggestion
of limiting usage to subtrees.


-- 
	Balbir
