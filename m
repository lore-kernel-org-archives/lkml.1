Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbYG1SYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbYG1SYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYG1SX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:23:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55671 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752484AbYG1SX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:23:58 -0400
Message-ID: <488E0EBD.7070304@sgi.com>
Date: Mon, 28 Jul 2008 11:23:57 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] cpus4096 fixes
References: <20080727190601.GA764@elte.hu> <200807281053.58267.rusty@rustcorp.com.au> <20080728081639.GA27708@elte.hu> <200807282321.53892.rusty@rustcorp.com.au>
In-Reply-To: <200807282321.53892.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Monday 28 July 2008 18:16:39 Ingo Molnar wrote:
>> * Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> Mike: I now think the right long-term answer is Linus' dense cpumap
>>> idea + a convenience allocator for cpumasks.  We sweep the kernel for
>>> all on-stack vars and replace them with one or the other.  Thoughts?
>> The dense cpumap for constant cpumasks is OK as it's clever, compact and
>> static.
>>
>> All-dynamic allocator for on-stack cpumasks ... is a less obvious
>> choice.
> 
> Sorry, I was unclear.  "long-term" == "more than 4096 CPUs", since I thought 
> that was Mike's aim.  If we only want to hack up 4k CPUS and stop, then I 
> understand the current approach.
> 
> If we want huge cpu numbers, I think cpumask_alloc/free gives the clearest 
> code.  So our approach is backwards: let's do that *then* put ugly hacks in 
> if it's really too slow.
> 
> Cheers,
> Rusty.

Well, yes, "long-term" is not really that long and the system will be capable
of supporting 16k cpus.  With the limit on clock scalability, core count is
going through the roof.  Fortunately, we have a whole new release cycle to
rethink some basic ideas.

I did bring up a number of suggestions on how to replace cpumask_t, but they
all seemed to hamper small systems in one way or another.  And the goal, again
was to minimize impact for 99.99% of the systems that won't have a thousand
or more cpus.  (Though it only takes 8 Larrabee chips to attain that.)

Thanks,
Mike
