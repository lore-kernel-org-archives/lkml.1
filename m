Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbYDDI3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbYDDI3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 04:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYDDI24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 04:28:56 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:40828 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946AbYDDI2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 04:28:55 -0400
Message-ID: <47F5E69C.9@linux.vnet.ibm.com>
Date: Fri, 04 Apr 2008 13:58:12 +0530
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
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain> <6599ad830804040112q3dd5333aodf6a170c78e61dc8@mail.gmail.com>
In-Reply-To: <6599ad830804040112q3dd5333aodf6a170c78e61dc8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Apr 4, 2008 at 1:05 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  After the thread group leader exits, it's moved to init_css_state by
>>  cgroup_exit(), thus all future charges from runnings threads would
>>  be redirected to the init_css_set's subsystem.
> 
> And its uncharges, which is more of the problem I was getting at
> earlier - surely when the mm is finally destroyed, all its virtual
> address space charges will be uncharged from the root cgroup rather
> than the correct cgroup, if we left the delayed group leader as the
> owner? Which is why I think the group leader optimization is unsafe.

It won't uncharge for the memory controller from the root cgroup since each page
 has the mem_cgroup information associated with it. For other controllers,
they'll need to monitor exit() callbacks to know when the leader is dead :( (sigh).

Not having the group leader optimization can introduce big overheads (consider
thousands of tasks, with the group leader being the first one to exit).

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
