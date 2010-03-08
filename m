Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0CHUh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:37:27 -0500
Received: from mail.tmr.com ([64.65.253.246]:53949 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab0CHUhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:37:21 -0500
Message-ID: <4B955FF6.5060300@tmr.com>
Date: Mon, 08 Mar 2010 15:37:10 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Intel microcode loader performance improvement
References: <20100305174203.GA19638@sgi.com> <b647ffbd1003080233y5f06797fucaca3cf839e4de57@mail.gmail.com>
In-Reply-To: <b647ffbd1003080233y5f06797fucaca3cf839e4de57@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> On 5 March 2010 18:42, Dimitri Sivanich <sivanich@sgi.com> wrote:
>> We've noticed that on large SGI UV system configurations, running
>> microcode.ctl can take very long periods of time.  This is due to
>> the large number of vmalloc/vfree calls made by the Intel
>> generic_load_microcode() logic.
>>
>> By reusing allocated space, the following patch reduces the time
>> to run microcode.ctl on a 1024 cpu system from approximately 80
>> seconds down to 1 or 2 seconds.
>>
>> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> This approach seems reasonable in the scope of the current framework.
> 
> Acked-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> 
> However, I think a better approach would be to have some kind of
> shared storage for loaded microcode updates. Given that for the
> majority of SMP systems all the cpus are normally updated to the very
> same new instance of microcode, it should be enough to do a search for
> the first cpu, cache the instance of microcode and then reuse it for
> others.
> 
The assumption that all CPUs are the same is not always true in practice, people 
buy a system and don't always fully populate initially, and when they add 
processors, they have a more recent stepping. So reusing microcode or updating 
in parallel would add complexity, and 2 sec for 1024 CPUs puts a pretty low 
upper bound on possible improvement. Does more improvement to a one time small 
delay justify additional complexity?

Systems that size are probably not booted all that often. Something to consider 
before putting a lot of effort into it, I think.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
