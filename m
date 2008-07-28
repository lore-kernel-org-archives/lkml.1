Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYG1NWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYG1NWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 09:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYG1NWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 09:22:03 -0400
Received: from ozlabs.org ([203.10.76.45]:39084 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYG1NWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 09:22:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] cpus4096 fixes
Date: Mon, 28 Jul 2008 23:21:53 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Travis <travis@sgi.com>
References: <20080727190601.GA764@elte.hu> <200807281053.58267.rusty@rustcorp.com.au> <20080728081639.GA27708@elte.hu>
In-Reply-To: <20080728081639.GA27708@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807282321.53892.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008 18:16:39 Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Mike: I now think the right long-term answer is Linus' dense cpumap
> > idea + a convenience allocator for cpumasks.  We sweep the kernel for
> > all on-stack vars and replace them with one or the other.  Thoughts?
>
> The dense cpumap for constant cpumasks is OK as it's clever, compact and
> static.
>
> All-dynamic allocator for on-stack cpumasks ... is a less obvious
> choice.

Sorry, I was unclear.  "long-term" == "more than 4096 CPUs", since I thought 
that was Mike's aim.  If we only want to hack up 4k CPUS and stop, then I 
understand the current approach.

If we want huge cpu numbers, I think cpumask_alloc/free gives the clearest 
code.  So our approach is backwards: let's do that *then* put ugly hacks in 
if it's really too slow.

Cheers,
Rusty.
