Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZJ3Nxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZJ3Nxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 09:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbZJ3Nxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 09:53:34 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:30911 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbZJ3Nxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 09:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=lNhHw/p6iJnBmk1L4n8HqvHQ9xEOzIQV2SjALwv6h51cbjTmk8KGCJnJm+C9POAAZy
         OLmHbw6d5voWj4qTDUvomm2pA1sl70/bkAHMsIdnezzhyBqe/dJARMKeR93QoXMV8DG2
         IunpLv8h7pbnyW0BkgwIb0c03NgqMrcH1Zg4Y=
Message-ID: <4AEAEFDD.5060009@gmail.com>
Date: Fri, 30 Oct 2009 14:53:33 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
References: <hav57c$rso$1@ger.gmane.org> <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com> <hb2cfu$r08$2@ger.gmane.org> <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com> <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com> <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <4AE846E8.1070303@gmail.com> <alpine.DEB.2.00.0910281307370.23279@chino.kir.corp.google.com> <4AE9068B.7030504@gmail.com> <alpine.DEB.2.00.0910290132320.11476@chino.kir.corp.google.com> <4AE97618.6060607@gmail.com> <alpine.DEB.2.00.0910291225460.27732@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0910291225460.27732@chino.kir.corp.google.com>
X-Age: 25
X-Location: Lovran, Croatia
X-OS: Debian GNU/Linux
X-Face: +Lg7^E:?#]P.Y{N@61yW{aY#>fRcOE6MMqgAM|Kwk"fK!y!i4+h6&?E`Jt@uame[-SLu#*<fGtMmVfh8qo,"kJ'ql^Ni?]l|ax{fvvmD<k:2w^e(y8J2YWO`M=u17OWli}Rf^e:|w2]LulgE(:u0|}mNBZFid[YEWAC>?k:)dZv<!'a)N0b=LFDZKY!!@[%mmVO-7y`Nkj?{<C6rm9Uz$EXu;0I<PubM.Po|vlT.2&vPkJG07G.l0Ty)B/dR0k:KU<;?+WAR\f_ms2b~i"g@e}a)i1N$WLBa{vBoDs4!}k\g?lItt=|]=M{Fm@ce|^6PXq&
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:

> Ok, so this is the forkbomb problem by adding half of each child's 
> total_vm into the badness score of the parent.  We should address this 
> completely seperately by addressing that specific part of the heuristic, 
> not changing what we consider to be a baseline.
> thunderbird.
>
> You're making all these claims and assertions based _solely_ on the theory 
> that killing the application with the most resident RAM is always the 
> optimal solution.  That's just not true, especially if we're just 
> allocating small numbers of order-0 memory.

Well, you are kernel hacker, not me. You know how linux mm works much
more than I do. I just reported a, what I think is a big problem, which
needs to be solved ASAP (2.6.33). I'm afraid that we'll just talk much
and nothing will be done with solution/fix postponed indefinitely. Not
sure if you are interested, but I tested this on windowsxp also, and
nothing bad happens there, system continues to function properly.

For 2-3 years I had memory overcommit turn off. I didn't get any OOM,
but sometimes Java didn't work and it seems that because of some kernel
weirdness (or misunderstanding on my part) I couldn't use all the
available memory:

# echo 2 > /proc/sys/vm/overcommit_memory

# echo 95 > /proc/sys/vm/overcommit_ratio
% ./test  /* malloc in loop as before */
malloc: Cannot allocate memory /* Great, no OOM, but: */

% free -m
          total       used       free     shared    buffers     cached
Mem:      3458        3429         29          0        102       1119
-/+ buffers/cache:    2207       1251

There's plenty of memory available. Shouldn't cache be automatically
dropped (this question was in my original mail, hence the subject)?

All this frustrated not only me, but a great number of users on our
local Croatian linux usenet newsgroup with some of them pointing that as
the reason they use solaris. And so on...

> Much better is to allow the user to decide at what point, regardless of 
> swap usage, their application is using much more memory than expected or 
> required.  They can do that right now pretty well with /proc/pid/oom_adj 
> without this outlandish claim that they should be expected to know the rss 
> of their applications at the time of oom to effectively tune oom_adj.

Believe me, barely a few developers use oom_adj for their applications,
and probably almost none of the end users. What should they do, every
time they start an application, go to console and set the oom_adj. You
cannot expect them to do that.

> What would you suggest?  A script that sits in a loop checking each task's 
> current rss from /proc/pid/stat or their current oom priority though 
> /proc/pid/oom_score and adjusting oom_adj preemptively just in case the 
> oom killer is invoked in the next second?

:)

