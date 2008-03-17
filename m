Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYCQFKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYCQFKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 01:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYCQFKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 01:10:38 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:41927 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbYCQFKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 01:10:37 -0400
Message-ID: <47DDFCEA.3030207@linux.vnet.ibm.com>
Date: Mon, 17 Mar 2008 10:38:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][0/3] Virtual address space control for cgroups
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain> <6599ad830803161626q1fcf261bta52933bb5e7a6bdd@mail.gmail.com> <47DDCDA7.4020108@cn.fujitsu.com> <6599ad830803161857r6d01f962vfd0f570e6124ab24@mail.gmail.com>
In-Reply-To: <6599ad830803161857r6d01f962vfd0f570e6124ab24@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Mar 17, 2008 at 9:47 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>  It will be code duplication to make it a new subsystem,
> 
> Would it? Other than the basic cgroup boilerplate, the only real
> duplication that I could see would be that there'd need to be an
> additional per-mm pointer back to the cgroup. (Which could be avoided
> if we added a single per-mm pointer back to the "owning" task, which
> would generally be the mm's thread group leader, so that you could go
> quickly from an mm to a set of cgroup subsystems).
> 

I understand the per-mm pointer overhead back to the cgroup. I don't understand
the part about adding a per-mm pointer back to the "owning" task. We already
have task->mm. BTW, the reason by we directly add the mm_struct to mem_cgroup
mapping is that there are contexts from where only the mm_struct is known (when
we charge/uncharge). Assuming that current->mm's mem_cgorup is the one we want
to charge/uncharge is incorrect.

> And the advantage would that you'd be able to more easily pick/choose
> which bits of control you use (and pay for).

I am not sure I understand your proposal fully. But, if it can help provide the
flexibility you are referring to, I am all ears.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
