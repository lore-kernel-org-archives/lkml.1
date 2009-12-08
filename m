Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbZLHJbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbZLHJbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZLHJbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:31:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbZLHJbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:31:47 -0500
Message-ID: <4B1E1D96.1020304@redhat.com>
Date: Tue, 08 Dec 2009 17:34:14 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC Patch] getrusage: fill ru_ixrss, ru_idrss and ru_isrss fields
References: <20091208173730.B5C3.A69D9226@jp.fujitsu.com> <4B1E13C8.70704@redhat.com> <20091208181117.B5C9.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091208181117.B5C9.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> KOSAKI Motohiro wrote:
>>> 	The next three fields, the subject of this patch, are named ru_XXrss:
>>> 	though the 80-column comment omits to say "resident set" before "size",
>>> 	I believe they'd be expected to account (subdivided) resident set sizes?
>>>
>>>
>>> your calculation is not rss nor not integral.
>>>
>> Hmm, I misunderstood rss here. Does it mean the memory stayed in
>> physical mem? i.e. not swapped out.
> 
> Yes.
> 
> Plus, 'integral' mean "tick * rss". but in dyntick environment, per tick statistics is not
> so easy nor low cost.

Thanks for explanation!

> 
>> So, if I want to get those rss statistics, I have to add some more
>> mm_counter by myself? I only find file_rss and anon_rss in mm_struct.
> 
> Hmm..
> I doubt nobody use such statistics. if nobody explain real world usage, I oppose to add
> new counter overhead.

Well, this is one of the usages. :)

I just checked more, I found it's not easy to add rss statistics for
stack, executable, etc... the reason is that we don't have a page flag
to mark a page as used for stack etc.


