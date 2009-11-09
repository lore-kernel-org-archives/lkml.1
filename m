Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZKIIIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZKIIIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbZKIIIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:08:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42685 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbZKIIIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:08:38 -0500
Date: Mon, 9 Nov 2009 09:08:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ma, Ling" <ling.ma@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
Message-ID: <20091109080830.GI453@elte.hu>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
 <4AF457E0.4040107@zytor.com>
 <4AF4784C.5090800@zytor.com>
 <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
 <4AF7C66C.6000009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF7C66C.6000009@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/08/2009 11:24 PM, Ma, Ling wrote:
> > Hi All
> > 
> > Today we run our benchmark on Core2 and Sandy Bridge:
> > 
> 
> Hi Ling,
> 
> Thanks for doing that.  Do you also have access to any older CPUs?  I 
> suspect that the CPUs that Andi are worried about are older CPUs like 
> P4, K8 or Pentium M/Core 1.  (Andi: please do clarify if you have 
> additional information.)
> 
> My personal opinion is that if we can show no significant slowdown on 
> P4, K8, P-M/Core 1, Core 2, and Nehalem then we can simply use this 
> code unconditionally.  If one of them is radically worse than 
> baseline, then we have to do something conditional, which is a lot 
> more complicated.
> 
> [Ingo, Thomas: do you agree?]

Yeah. IIRC the worst-case were the old P2's which had a really slow, 
microcode based string ops. (Some of them even had erratums in early 
prototypes although we can certainly ignore those as string ops get 
relied on quite frequently.)

IIRC the original PPro core came up with some nifty, hardwired string 
ops, but those had to be dumbed down and emulated in microcode due to 
SMP bugs - making it an inferior choice in the end.

But that should be ancient history and i'd suggest we ignore the P4 
dead-end too, unless it's some really big slowdown (which i doubt). If 
anyone cares then some optional assembly implementations could be added 
back.

Ling, if you are interested, could you send a user-space test-app to 
this thread that everyone could just compile and run on various older 
boxes, to gather a performance profile of hand-coded versus string ops 
performance?

( And i think we can make a judgement based on cache-hot performance
  alone - if then the strings ops will perform comparatively better in
  cache-cold scenarios, so the cache-hot numbers would be a conservative
  estimate. )

	Ingo
