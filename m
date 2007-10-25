Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbXJYJpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbXJYJpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbXJYJpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:45:22 -0400
Received: from main.gmane.org ([80.91.229.2]:52595 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431AbXJYJpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:45:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Samuel Tardieu <sam@rfc1149.net>
Subject: Re: Is gcc thread-unsafe?
Date: Thu, 25 Oct 2007 11:40:22 +0200
Message-ID: <874pgf1qih.fsf@willow.rfc1149.net>
References: <MDEHLPKNGKAHNMBLJOLKAEOKHLAC.davids@webmaster.com> <200710251447.51370.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: zaphod.rfc1149.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:jWH66yiv3lyRMf+o85F4MVgGr9Y=
X-Leafnode-NNTP-Posting-Host: 2001:6f8:37a:2::2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nick" == Nick Piggin <nickpiggin@yahoo.com.au> writes:

Nick> Hi David, [BTW. can you retain cc lists, please?]

Nick> On Thursday 25 October 2007 14:29, David Schwartz wrote:
>> > Well that's exactly right. For threaded programs (and maybe even
>> > real-world non-threaded ones in general), you don't want to be >
>> even _reading_ global variables if you don't need to. Cache misses
>> > and cacheline bouncing could easily cause performance to
>> completely > tank in some cases while only gaining a cycle or two
>> in > microbenchmarks for doing these funny x86 predication things.
>> 
>> For some CPUs, replacing an conditional branch with a conditional
>> move is a *huge* win because it cannot be mispredicted.

Nick> A *conditional* store should no be a problem.

Nick> However the funny trick of doing this conditional add
Nick> (implemented with unconditional store), is what is going to
Nick> cause breakage.

Nick> On the CPUs where predicated instructions are a big win, I'd
Nick> expect they should also implement a conditional store for use
Nick> here. However they might be slower than an unconditional store
Nick> (eg. x86's cmov), and in those cases, gcc might just do the
Nick> non-conditional store.


>> In general, compilers should optimize for unshared data since
>> that's much more common in typical code.  Even for shared data, the
>> usual case is that you are going to access the data few times, so
>> pulling the cache line to the CPU is essentially free since it will
>> happen eventually.

Nick> This is not just a question of data that you were going to use
Nick> anyway.  gcc generates memory accesses to locations that would
Nick> never be accessed Even stores. It is basically impossible to say
Nick> that this is a real performance win. Even on single threaded
Nick> code: consider that cache misses take the vast majority of time
Nick> in many loads, which gives a little hint that maybe it's a bad
Nick> idea to do this ;)


>> Heuristics may show that the vast majority of such constructs write
>> anyway.  So the optimization may also be valid based on such
>> heuristics.

Nick> I'd never say the optimisation would always be useless. But it's
Nick> a nasty thing to have on by default, and apparently even with no
Nick> good way to supress it even if we want to.


>> A better question is whether it's legal for a compiler that claims
>> to support POSIX threads. I'm going to post on
>> comp.programming.threads, where the threading experts hang out.

Nick> Either way, I think we really need a way to turn it off for
Nick> Linux.

-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/

