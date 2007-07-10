Return-Path: <linux-kernel-owner+w=401wt.eu-S1761669AbXGJCCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761669AbXGJCCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbXGJCCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:02:36 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:43751 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755061AbXGJCCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:02:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Bm1Z+QfhT3B43R83/qDhXd/coomlMmb4pZ2mFGTCYG1fotp7JVCBsDcdZunnQ/rqgzVCSqYLzRyZ4+aBchwm3dmutmt1Z21mJDD6Xw9BY9zB+KLS4T5hmyM+gjPuU7FSoy1gC4uTOxmtvVd+KHDYJocgK7WxnuECP3lnYuxvEWQ=  ;
X-YMail-OSG: kTiPUv8VM1nLABCCq5BFMNaGNOr2Xcktb8sqsFzmvuwtDUaiLVv74WdLcBtmAeVW33LeK2Dc4g--
Message-ID: <4692E8B5.3030404@yahoo.com.au>
Date: Tue, 10 Jul 2007 12:02:29 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org> <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com> <20070709095116.c2ea700f.akpm@linux-foundation.org> <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com> <4692E44E.6000606@yahoo.com.au> <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 10 Jul 2007, Nick Piggin wrote:
> 
> 
>>I don't see any problems with maintaining SLOB. It is simple enough
>>that I was able to write a userspace test harness for it and hack
>>away at it after reading the code the first time for half an hour or
>>so. It is nothing even slightly comparable to the problems of SLAB,
>>for example. And you don't have to maintain it at all anyway!
> 
> 
> I have to maintain it because I have to keep the slab APIs consistent 
> (recently I added GFP_ZERO support and had to provide shims for slab 
> defreag). It is not in a good state as described in the patch and has a 
> history of not being maintained properly. Everyone that modifies the 
> behavior of the slab allocator has to do something to avoid breaking SLOB. 
> Its certainly fun to hack on but is that a criterion for keeping it in the 
> tree?

Pretty standard fare that when you add something or change APIs, most
of the burden is on you to not break the kernel. I'd love nothing better
than to remove all but about 3 filesystems :)

It is reasonable to expect some help from maintainers, but I notice you
didn't even CC the SLOB maintainer in the patch to remove SLOB! So maybe
if you tried working a bit closer with him you could get better results?


>>I like removing code as much as the next person, but I don't
>>understand why you are so intent on removing SLOB and willing to
>>dismiss its advantages so quickly.
> 
> 
> Quickly? We have considered this for months now.

Quickly -- as in you quickly sweep the savings of 100s of K under the
rug and just declare that it is insignificant :)

-- 
SUSE Labs, Novell Inc.
