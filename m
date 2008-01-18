Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbYARJ4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbYARJ4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYARJ4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:56:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45230 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbYARJ4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:56:42 -0500
Date: Fri, 18 Jan 2008 10:56:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] [0/36] Great change_page_attr patch series v3
Message-ID: <20080118095627.GB30637@elte.hu>
References: <200801161114.239449000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801161114.239449000@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> Changes to previous versions: 
> - Ported to the latest git-x86 including the PAT patchkit
> This undoes some changes in the PAT patches and reimplements them
> in a different way. End result should be equivalent, but this
> made it easier for me to merge the patches.
> - Fix NX bit handling (I think even after Jeremy's fixes it was
> still not completely right) 
> - Minor fixes based on feedback

thanks Andi for porting your CPA queue ontop of PAT. Now that PAT 
support is getting into shape i've test-merged your CPA series to 
x86.git.

v2.6.25 merging of CPA is still somewhat in limbo but worst-case i think 
we can still get away with just doing wbinvd instead of clflush and get 
rid of most of the risks that way. Could you please add a boot option 
and Kconfig option that does that? Something like "noclflush" and a 
.config option to achieve the same - just like we do for PAT.

We've got way too much stuff going on at the moment - and the PAT bits 
are more fundamental and more important than nice but non-essential 
optimizations like CPA. There's still a lot of cruft all around this 
area.

One thing, you undid a cleanup patch:

|  Subject: CPA: Undo white space changes
|  From: Andi Kleen <ak@suse.de>
|
|  Undo random white space changes. This reverts
|  ddb53b5735793a19dc17bcd98b050f672

this is perfectly fine as we do not want to make your merging harder via 
cleanups, as long as you redo the cleanups after your series. Your new 
code is pretty ugly to look at, and this very much shows in the 
checkpatch metrics too:

                                       errors   lines of code   errors/KLOC
 arch/x86/mm/pageattr_32.c                 29             419          69.2
 arch/x86/mm/pageattr_64.c                 31             384          80.7

prior the undo it was:

                                       errors   lines of code   errors/KLOC
 arch/x86/mm/pageattr_32.c                  0             294             0
 arch/x86/mm/pageattr_64.c                  0             275             0

please restore that cleanliness state. Thanks,

	Ingo
