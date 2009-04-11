Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbZDKKI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbZDKKI2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 06:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbZDKKHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 06:07:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62291 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757963AbZDKKHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 06:07:30 -0400
Message-ID: <49E06C05.2060502@cn.fujitsu.com>
Date: Sat, 11 Apr 2009 18:08:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/7] tracing: bug fixes for tracing/filters
References: <49E04C22.4040608@cn.fujitsu.com> <1239442248.8793.65.camel@tropicana>
In-Reply-To: <1239442248.8793.65.camel@tropicana>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Zanussi wrote:
> Hi,
> 
> On Sat, 2009-04-11 at 15:52 +0800, Li Zefan wrote:
>> This patchset fixes some bugs in tracing/filters. Most of the change
>> goes to the last patch, and others are small ones.
>>
> 
> At first glance, they look good and fix real problems - thanks for
> fixing them.  Re patch 7, there's been some discussion about using rcu
> for this.  See:
> 
> http://lkml.org/lkml/2009/4/5/46
> 

Hm, I didn't notice it, since I just started looking into tracing/filters
2 days ago.

>>From that discussion, it seems some non-trivial changes to rcu would be
> needed for this.  I'm playing around with a different idea now to
> hopefully avoid the need for that, or the other approach mentioned, of
> temporarily stopping tracing while removing/changing the filters.
> 
> Basically my thought is to avoid the problem by not allocating or
> destroying the preds when removing filters but instead switch out the
> pred->fns with a nop version while keeping the fields intact for awhile.
> I think that will work for removing filters, but I still need to think
> about how it would (or would not) work for replacing them.
>  

I'll keep an eye on this issue.
