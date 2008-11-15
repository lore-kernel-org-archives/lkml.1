Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbYKOAUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbYKOAUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 19:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYKOAUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 19:20:21 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:52617 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYKOAUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 19:20:20 -0500
Date: Sat, 15 Nov 2008 00:19:50 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Christoph Lameter <cl@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_OPTIMIZE_INLINING fun
In-Reply-To: <Pine.LNX.4.64.0811141343510.30981@quilx.com>
Message-ID: <Pine.LNX.4.64.0811150001430.2087@blonde.site>
References: <Pine.LNX.4.64.0811141804030.29883@blonde.site>
 <Pine.LNX.4.64.0811141244060.29394@quilx.com> <Pine.LNX.4.64.0811141923030.10125@blonde.site>
 <Pine.LNX.4.64.0811141343510.30981@quilx.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Christoph Lameter wrote:
> On Fri, 14 Nov 2008, Hugh Dickins wrote:
> 
> > What I was intending anyway, quite independently of the INLINING
> > issue, was changing those and some others to VM_BUG_ONs, which are
> > intended really for VM testers rather than for distros to turn on.
> > (Though perhaps Nick has shifted his position on that.)
> 
> Some distros have a bad habit of turning these on for production releases.

Okay, then they'll get what they've asked for.  DEBUG_VM has
an outstandingly appropriate help text, Nick deserves a medal:

  Enable this to turn on extended checks in the virtual-memory system
  that may impact performance.

  If unsure, say N.

> > But I suspect
> > it's irrelevant, that changing those functions to macros would not
> > actually have any effect on the problem - that's what we've often
> > been assured, anyway, that the compiler nowadays does inlines as
> > efficiently as the preprocessor does macros.  I do wonder though.
> 
> Maybe try to compare it with a old kernel that still has the page flags
> macros? That way we would have a testcase useful for bringing to the
> attention of the gcc people.

I've now put a 2.6.25 #define-style page-flags.h into my 2.6.28-rc4
build tree, added in enough of the missing stuff to build my config,
and rebuilt with gccs 4.2.1 and 4.3.2.

You'll be relieved to hear that using the macros makes no difference:
well, of course it eliminates all those " Page" functions with 4.2.1,
hard for it not to; but leaves just as many constant_test_bit()s.

Hugh
