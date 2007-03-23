Return-Path: <linux-kernel-owner+w=401wt.eu-S1422783AbXCWKr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422783AbXCWKr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 06:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422787AbXCWKr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 06:47:56 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:29282 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422783AbXCWKr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 06:47:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=vMpODRKINvDN+f0t/DfhBIv4pnDoHFWF5iQd9IyFBubf7gIiDwGxBuI5AMA802TpFZtYGQqX++MPQ4eqL7kSFEsCZfnalOzr9meBQx+0ImM1neZFKwej5VoZU/FajcggEiCgp56IQqSeO1SqtRyoudJDgqBKkcJchUtfoX9Bwpo=  ;
X-YMail-OSG: G7X5Cp4VM1nC.F852L77PIVIvcDn5BjvKxYCZRbkZj2u9EuaYpyH8tFIABW_Mrbr85sLpG5FGDVZDzvPDvrfwLM75rmvuq9cnfa.v9vZX9HtAGpcZyrSEHUlB0UxuCrO9ZIdXK8XBih3Q6i3MAiqfk_LNw--
Message-ID: <4603B051.8000108@yahoo.com.au>
Date: Fri, 23 Mar 2007 21:47:45 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Dave Hansen <hansendc@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       menage@google.com, Andrew Morton <akpm@linux-foundation.org>,
       xemul@sw.ru
Subject: Re: controlling mmap()'d vs read/write() pages
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>	<20070306140036.4e85bd2f.akpm@linux-foundation.org>	<45F3F581.9030503@sw.ru>	<20070311045111.62d3e9f9.akpm@linux-foundation.org>	<20070312010039.GC21861@MAIL.13thfloor.at>	<1173724979.11945.103.camel@localhost.localdomain>	<20070312224129.GC21258@MAIL.13thfloor.at>	<20070312220439.677b4787.akpm@linux-foundation.org>	<1173806793.6680.44.camel@localhost.localdomain>	<20070313190931.1417c012@lxorguk.ukuu.org.uk>	<m1mz2enh0u.fsf@ebiederm.dsl.xmission.com>	<1174062660.8184.8.camel@localhost.localdomain>	<m1tzwlm33i.fsf@ebiederm.dsl.xmission.com>	<1174074412.8184.29.camel@localhost.localdomain>	<m1zm6ajvns.fsf@ebiederm.dsl.xmission.com>	<1174407335.26166.146.camel@localhost.localdomain>	<m13b3zmx4b.fsf@ebiederm.dsl.xmission.com>	<46036C54.6030502@yahoo.com.au> <m1tzwc5kw6.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1tzwc5kw6.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> 
> 
>>Eric W. Biederman wrote:
>>
>>>Dave Hansen <hansendc@us.ibm.com> writes:
>>>
>>>
>>>
>>>>So, I think we have a difference of opinion.  I think it's _all_ about
>>>>memory pressure, and you think it is _not_ about accounting for memory
>>>>pressure. :)  Perhaps we mean different things, but we appear to
>>>>disagree greatly on the surface.
>>>
>>>
>>>I think it is about preventing a badly behaved container from having a
>>>significant effect on the rest of the system, and in particular other
>>>containers on the system.
>>
>>That's Dave's point, I believe. Limiting mapped memory may be
>>mostly OK for well behaved applications, but it doesn't do anything
>>to stop bad ones from effectively DoSing the system or ruining any
>>guarantees you might proclaim (not that hard guarantees are always
>>possible without using virtualisation anyway).
>>
>>This is why I'm surprised at efforts that go to such great lengths
>>to get accounting "just right" (but only for mmaped memory). You
>>may as well not even bother, IMO.
>>
>>Give me an RSS limit big enough to run a couple of system calls and
>>a loop...
> 
> 
> Would any of them work on a system on which every filesystem was on
> ramfs, and there was no swap?  If not then they are not memory attacks
> but I/O attacks.
> 
> I completely concede that you can DOS the system with I/O if that is
> not limited as well.
> 
> My point is that is not a memory problem but a disk I/O problem which is
> much easier to and cheaper to solve.  Disk I/O is fundamentally a slow
> path which makes it hard to modify it in a way that negatively affects
> system performance.
> 
> I don't think with a memory RSS limit you can DOS the system in a way
> that is purely about memory.  You have to pick a different kind of DOS
> attack.

It can be done trivially without performing any IO or swap, yes.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
