Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYCZLp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYCZLp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYCZLpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:45:21 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:54296 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYCZLpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:45:20 -0400
Message-ID: <47EA3684.60107@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2008 17:11:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][-mm] Memory controller add mm->owner
References: <20080324140142.28786.97267.sendpatchset@localhost.localdomain> <6599ad830803240803s5160101bi2bf68b36085f777f@mail.gmail.com> <47E7D51E.4050304@linux.vnet.ibm.com> <6599ad830803240934g2a70d904m1ca5548f8644c906@mail.gmail.com> <47E7E5D0.9020904@linux.vnet.ibm.com> <6599ad830803241046l61e2965t52fd28e165d5df7a@mail.gmail.com> <47E8E4F3.6090604@linux.vnet.ibm.com>  <47EA2592.7090600@linux.vnet.ibm.com> <6599ad830803260420v236127cfydd8cf828fcce65bb@mail.gmail.com>
In-Reply-To: <6599ad830803260420v236127cfydd8cf828fcce65bb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Mar 26, 2008 at 3:29 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  >>
>>  >> - in the worst case, it's not going to be worse than doing a
>>  >> for_each_thread() loop
>>  >>
>>
>>  This will have to be the common case, since you never know what combination of
>>  clone calls did CLONE_VM and what did CLONE_THREAD. At exit time, we need to pay
>>  a for_each_process() overhead.
> 
> I'm not convinced of this. All we have to do is find some other
> process p where p->mm == current->mm and make it the new owner.
> Exactly what sequence of clone() calls was used to cause the sharing
> isn't really relevant. I really think that a suitable candidate will
> be found amongst your children or your first sibling in 99.9% of those
> cases where more than one process is using an mm.
> 

Hmmm.. the 99.9% of the time is just guess work (not measured, could be possibly
true). I see and understand your code below. But before I try and implement
something like that, I was wondering why zap_threads() does not have that
heuristic. That should explain my inhibition.

Can anyone elaborate on zap_threads further?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
