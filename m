Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbYAVOGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbYAVOGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYAVOGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:06:23 -0500
Received: from www.tglx.de ([62.245.132.106]:57814 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYAVOGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:06:22 -0500
Date: Tue, 22 Jan 2008 15:06:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr patch
 series v3)
In-Reply-To: <20080122132355.GA24320@wotan.suse.de>
Message-ID: <alpine.LFD.1.00.0801221439520.3199@apollo.tec.linutronix.de>
References: <200801161114.239449000@suse.de> <200801181819.58675.ak@suse.de> <20080121164052.GA11364@elte.hu> <200801211813.45102.ak@suse.de> <alpine.LFD.1.00.0801221119180.3199@apollo.tec.linutronix.de> <20080122132355.GA24320@wotan.suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008, Andi Kleen wrote:

> > First priority is getting CPA and PAT consolidated before we put new
> 
> PAT seems to be still quite unstable and frankly for me it is 
> unclear how long it will take to it become stable. It would
> not surprise me if it takes longer than the .26 merge window.

Definitely, if we change the code further without doing anything to
consolidate it in the first place. 

Have you even cared to look, why PAT is so ugly and fragile ? Simply
because it interferes/interacts with CPA and the page table code. So
adding further stuff to that area without considering the requirements
of PAT will make it worse.

> You're saying you want to delay an relatively simple and imho
> relatively mature feature like gbpages after that complicated and risky 
> feature PAT? Please take a look at the patches; they're really
> not very complicated.

It's not a question of complicated or not. Fact is, that PAT is
interfering with all this and any new feature will make it harder to
stabilize.

> That seems to me like against your own principles -- simple stuff
> first -- that you two harped on so extensively on earlier this thread.

Not at all. If the simple stuff makes it harder to do something else,
then it is not longer simple. Then it is simply in the way. 

If your patches are so simple, then they can be done on top of a
consolidated CPA/PAT easily.

> For me it would make much more sense to put the gbpages first
> than to delay them for PAT. I only didn't argue this strongly
> earlier because PAT was already rushed in (for me quite suprisingly) 
> and I didn't want to argue for dropping it.
>
> But now that it is gone again anyways delaying the gbpages for it again
> would be quite unfortunate from my perspective.

I can understand that, because it is in the way of your particular
interests, but we have to look at the global picture and not at the
personal preferences of you or anyone else.

Thanks,
	tglx
