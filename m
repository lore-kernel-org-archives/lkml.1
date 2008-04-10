Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbYDJJLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbYDJJLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbYDJJLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:11:16 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:41614 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbYDJJLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:11:15 -0400
Message-ID: <47FDD947.8020600@linux.vnet.ibm.com>
Date: Thu, 10 Apr 2008 14:39:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain> <47F7BB69.3000502@linux.vnet.ibm.com> <6599ad830804051057n2f2802e4w6179f2e108467494@mail.gmail.com> <47F7CC08.4090209@linux.vnet.ibm.com> <6599ad830804051629k3649dbc4na92bb3d0cd7a0492@mail.gmail.com> <47F861C8.7080700@linux.vnet.ibm.com> <6599ad830804072337g2e7b4613hdcc05062dc2ca4e0@mail.gmail.com> <47FB162D.1020506@linux.vnet.ibm.com> <6599ad830804072357o2fd5e9bco3309d151e270e62e@mail.gmail.com> <47FB193A.8070801@linux.vnet.ibm.com> <6599ad830804080029v1d8f2ff7g5254f32362fd7cb9@mail.gmail.com>
In-Reply-To: <6599ad830804080029v1d8f2ff7g5254f32362fd7cb9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Apr 8, 2008 at 12:05 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> Paul Menage wrote:
>>  > On Mon, Apr 7, 2008 at 11:52 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  >>  I agree, but like I said earlier, this was the easily available ready made
>>  >>  application I found. Do you know of any other highly threaded micro benchmark?
>>  >>
>>  >
>>  > How about a simple program that creates N threads that just sleep,
>>  > then has the main thread exit?
>>  >
>>
>>  That is not really representative of anything. I have that program handy. How do
>>  we measure the impact on throughput?
> 
> It's very representative of how much additional overhead in terms of
> mm->owner churn there is in a large multi-threaded application
> exiting, which is the thing that you're trying to optimize with the
> delayed thread group leader checks.
> 

I see almost no overhead after the notification change optimization (notify only
if owner belongs to a different cgroup).

My program creates n processes with k threads each and forces the thread group
leader to exit. For my experiment I created 10 processes with 800 threads each
(NOTE: you need to change ulimit -s for this to work).

I am going to remove the delay_group_leader() optimization and submit v9.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
