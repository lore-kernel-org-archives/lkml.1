Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbYBFEuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbYBFEuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 23:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758088AbYBFEuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 23:50:39 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:36503 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYBFEui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 23:50:38 -0500
Date: Wed, 6 Feb 2008 04:49:49 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm] stop c_p_a corrupting the pds
In-Reply-To: <26590.1202263535@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0802060428050.9030@blonde.site>
References: <Pine.LNX.4.64.0802052218190.11822@blonde.site>           
 <Pine.LNX.4.64.0802052226140.11822@blonde.site> <26590.1202263535@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 05 Feb 2008 22:27:21 GMT, Hugh Dickins said:
> > When change_page_attr splits a large page on x86_32 (without PAE), it is
> > currently corrupting every process's page directory: fix that by removing
> > the thinko which passes down a physical instead of a virtual address -
> > this version of the patch being the hotfix for 2.6.24-mm1.
> > 
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> <snark>
> I *knew* there was a reason we should have had this patch series in -mm for a while.
> </snark>
> 
> :)

Seriously, I do agree with you on that.  It seems like the excitement
of making great changes has overtaken proper caution here.

Though I guess it was just coincidence that made it more debuggable
in my -mm kernel (which gave "bad pgd" errors after starting X), when
the -git kernel just crashed somehow in starting X.  And I was lucky
to have CONFIG_VMSPLIT_2G_OPT on that machine, which placed the
corruption somewhere that soon got noticed.

Hugh
