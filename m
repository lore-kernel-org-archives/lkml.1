Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbXGJI1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbXGJI1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbXGJI1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:27:16 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:35278 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752541AbXGJI1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:27:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=iNuTBADFGLnOIXXEvMXBtUjKx23HMPi7EQkmPWkd9CCGiwU3erZ0Q65DBfc7rSSOe6KPw6aP79nqjWBN/VazpC0cHBGGHv3LxDZ67H/Tbv7WBP98xCTHqEnLYiWWst95zJozhFt5dEceXNHBigi2+9e66KdvIMrif2O43/BlWyY=  ;
X-YMail-OSG: kCYxxGYVM1lwfIoRSDTEQRHBRb6tWsyisz4cYSo0ZeefXLu.nXWAeflBe9F_D.oDasF9S0WgaQ--
Message-ID: <469342DC.8070007@yahoo.com.au>
Date: Tue, 10 Jul 2007 18:27:08 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <20070708034952.022985379@sgi.com>  <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu>  <20070708110224.9cd9df5b.akpm@linux-foundation.org>  <4691A415.6040208@yahoo.com.au> <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com> <Pine.LNX.4.64.0707090907010.13970@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0707101049230.23040@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0707101049230.23040@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:

> Curious, /proc/meminfo immediately after boot shows:
> 
> SLUB (debugging enabled):
> 
> (none):~# cat /proc/meminfo 
> MemTotal:        30260 kB
> MemFree:         22096 kB
> 
> SLUB (debugging disabled):
> 
> (none):~# cat /proc/meminfo 
> MemTotal:        30276 kB
> MemFree:         22244 kB
> 
> SLOB:
> 
> (none):~# cat /proc/meminfo 
> MemTotal:        30280 kB
> MemFree:         22004 kB
> 
> That's 92 KB advantage for SLUB with debugging enabled and 240 KB when 
> debugging is disabled.

Interesting. What kernel version are you using?


> Nick, Matt, care to retest SLUB and SLOB for your setups?

I don't think there has been a significant change in the area of
memory efficiency in either since I last tested, and Christoph and
I both produced the same result.

I can't say where SLOB is losing its memory, but there are a few
places that can still be improved, so I might get keen and take
another look at it once all the improvements to both allocators
gets upstream.

-- 
SUSE Labs, Novell Inc.
