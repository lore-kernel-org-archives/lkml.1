Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbYCEUli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbYCEUli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 15:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYCEUla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 15:41:30 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:40274 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbYCEUl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 15:41:29 -0500
Date: Wed, 5 Mar 2008 20:40:41 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: preempt bug in set_pmd_pfn?
In-Reply-To: <47CEF20D.5070608@goop.org>
Message-ID: <Pine.LNX.4.64.0803052027590.32046@blonde.site>
References: <47CDBB87.8090906@goop.org> <20080304212821.GB8944@elte.hu>
 <47CDBEDC.1050302@goop.org> <20080305064814.GB28398@elte.hu>
 <Pine.LNX.4.64.0803051407310.22243@blonde.site> <47CECEE9.3000801@goop.org>
 <Pine.LNX.4.64.0803051721200.13410@blonde.site> <47CEF20D.5070608@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Jeremy Fitzhardinge wrote:
> 
> Fixmap slots are global, not percpu; you may be thinking of kmap_atomic, which
> reserves percpu fixmap slots for its use.

Ah yes, of course you're right, I was misremembering: thanks.

> Most uses of set_fixmap are early
> in boot, where preemption (or other CPUs) isn't a factor.  The exception is
> mapping the compat vdso global mapping.   However, that is special-cased
> anyway, since the set_fixmap is followed by an explicit all-cpu tlb flush.

Mmm, yes, I hadn't noticed that one: rather a weird case.

(If root had a mind to do so, she could be flipping compat_vdso
back and forth on all cpus concurrently; but I don't see an actual
problem of getting a worse outcome than she deserves for doing so -
the pages involved never get freed.)

> It seems to me that the correct fix is to just make __set_fixmap disable
> preemption for its duration; it probably doesn't make much difference for the
> native case, and it makes Xen happy.

I'd have thought it better done just in that one peculiar case,
with a comment that it's to keep Xen happy; but I'd better back
out now and leave it to you and Ingo.

Hugh
