Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbXDISoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbXDISoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932178AbXDISoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:44:18 -0400
Received: from holomorphy.com ([66.93.40.71]:38174 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbXDISoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:44:16 -0400
Date: Mon, 9 Apr 2007 11:44:14 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ten percent test
Message-ID: <20070409184414.GX2986@holomorphy.com>
References: <200703290237.38777.kernel@kolivas.org> <20070406100333.GA19855@elte.hu> <200704071650.43905.kernel@kolivas.org> <200704071212.57401.gene.heskett@gmail.com> <20070407180818.GB23861@elte.hu> <1175973261.6288.2.camel@Homer.simpson.net> <20070409175143.GV2986@holomorphy.com> <20070409180356.GA17739@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409180356.GA17739@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> I strongly suggest assembling a battery of cleanly and properly 
>> written, configurable testcases, and scripting a series of regression 
>> tests as opposed to just randomly running kernel compiles and relying 
>> on Braille.

On Mon, Apr 09, 2007 at 08:03:56PM +0200, Ingo Molnar wrote:
> there's interbench, written by Con (with the purpose of improving 
> RSDL/SD), which does exactly that, but vanilla and SD performs quite the 
> same in those tests.
> it's quite hard to test interactivity, because it's both subjective and 
> because even for objective workloads, things depend so much on exact 
> circumstances. So the best way is to wait for actual complaints, and/or 
> actual testcases that trigger badness, and victims^H^H^H^H^H testers.
> (also note that often it needs _that precise_ workload to trigger some 
> badness. For example make -j depends on the kind of X shell terminal 
> that is used - gterm behaves differently from xterm, etc.)

Interactivity will probably have to stay squishy. The DoS affairs like
fiftyp.c, tenp.c, etc. are more of what I had in mind. There are also
a number of instances where CPU bandwidth distributions are gauged by
top(1) with noninteractive tests where the scriptable testcase affair
should be coming into play.

There are other, relatively obvious testcases for basic functionality
missing, too. For instance, where is the testcase to prove that nice
levels have the intended effect upon CPU bandwidth distribution between
sets of CPU-bound tasks? Or one that gauges the CPU bandwidth
distribution between a task that sleeps some (command-line configurable)
percentage of the time and some (command-line configurable) number of
competing CPU-bound tasks? Or one that gauges the CPU bandwidth
distribution between sets of cooperating processes competing with
ordinary CPU-bound processes? Can it be proven that any of this is
staying constant across interactivity or other changes? Is any of it
being changed as an unintended side-effect? Are the CPU bandwidth
distributions among such sets of competing tasks even consciously decided?

There should be readily-available answers to these questions, but they
are not so.


-- wli
