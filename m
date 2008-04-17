Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYDQDli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYDQDli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 23:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYDQDla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 23:41:30 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:40139 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbYDQDla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 23:41:30 -0400
Message-ID: <4806C633.3000302@linux.vnet.ibm.com>
Date: Thu, 17 Apr 2008 09:08:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       serue@us.ibm.com, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
References: <48036677.3010807@linux.vnet.ibm.com> <20080414170709.736819b6.akpm@linux-foundation.org> <20080415171359.GA352@tv-sign.ru> <6599ad830804151113i73010bb4x48e658195f295d41@mail.gmail.com> <20080415195950.GA113@tv-sign.ru>
In-Reply-To: <20080415195950.GA113@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 04/15, Paul Menage wrote:
>> On Tue, Apr 15, 2008 at 10:13 AM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
>>>  Let's suppose the process with a lot of threads does exit_group() and nobody
>>>  else uses this ->mm. How many time we will re-assign mm->owner and iterate
>>>  over the all threads in system ?
>>>
>> In general we won't get to the third loop, since one of the first two
>> loops (children or siblings) will find another mm user.
> 
> Well yes, the second loop checks parent->children ... all sub-threads have
> the same parent.
> 
> I'd suggest to use ->real_parent though. And the third loop could be
> 

real_parent is for ptraced processes right?

> 	for_each_process(g) {
> 		c = g;
> 		do {
> 			if (!c->mm)
> 				continue;
> 			if (c->mm != mm)
> 				break;
> 			goto assign_new_owner;
> 		} while_each_thread(g, c);
> 	}
> 

I had this loop earlier (inspired from zap_threads()), is this loop more
efficient than what we have?

> Still. can't we make mm->mm_users_list ?
> 

I suspect that will be expensive to maintain. Specially with large number of
threads. I see a large space overhead and time overhead and additional
synchronization overhead. Apart from finding the next owner is there any other
advantage?

> Oleg.
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
