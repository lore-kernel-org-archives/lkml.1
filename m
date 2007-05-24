Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbXEXHbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbXEXHbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 03:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbXEXHbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 03:31:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34017 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964AbXEXHbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 03:31:44 -0400
Date: Thu, 24 May 2007 09:31:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070524073131.GA17501@elte.hu>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <46540DB2.5000605@googlemail.com> <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com> <4654AC94.6080601@googlemail.com> <20070523150122.f9946f37.akpm@linux-foundation.org> <Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com> <20070523153730.e0e9e91d.akpm@linux-foundation.org> <Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com> <20070523182145.7d7f1f7e.randy.dunlap@oracle.com> <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> +SLUB Debug output
> +-----------------
> +
> +Here is a sample of slub debug output:
> +
> +*** SLUB kmalloc-8: Redzone Active@0xc90f6d20 slab 0xc528c530 offset=3360 flags=0x400000c3 inuse=61 freelist=0xc90f6d58
> +  Bytes b4 0xc90f6d10:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
> +    Object 0xc90f6d20:  31 30 31 39 2e 30 30 35                         1019.005
> +   Redzone 0xc90f6d28:  00 cc cc cc                                     .
> +FreePointer 0xc90f6d2c -> 0xc90f6d58
> +Last alloc: get_modalias+0x61/0xf5 jiffies_ago=53 cpu=1 pid=554
> +Filler 0xc90f6d50:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ

when constructing debug output it's a good idea to make it as 
'context-free' as possible. I.e. instead of saying 'Filler' and 
explaining it somewhere in Documentation/*, just say:

  Expected memory values at 0xc90f6d50:  5a 5a 5a 5a 5a 5a 5a 5a
  ... but found the following values:    12 34 56 78 90 12 34 56

(or whatever it means)

please also put in one of the keywords as the first word of whatever 
SLUB prints:

   BUG: ...
   WARNING: ...
   INFO: ...

the output should be compact, but never at the price of 
understandability. For example i tried to make lockdep output as 
self-explanatory as possible - and a good portion of lockdep.c is about 
having around the kind of information to make the error more 
understandable (tracking lock-acquire stacktraces, tracking 
initialization points, tracking initialization-time symbol names, etc.), 
and there's even quite some algorithmic complexity from that. I probably 
spent more time on making lockdep output easier to decode than on any 
other sub-feature of lockdep. The output format literally went over 
hundreds of revisions. Output to humans is _the_ most important thing 
that a debug facility can do, sometimes more important than the 
debugging it offers ;-) And even the existing lockdep output sometimes 
confuses people.

	Ingo
