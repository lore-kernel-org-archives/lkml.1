Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbXKMSdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbXKMSdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759671AbXKMSdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:33:03 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:59177 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759589AbXKMSc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:32:58 -0500
Date: Tue, 13 Nov 2007 10:32:39 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, gregkh@suse.de, akpm@osdl.org,
       linux-kernel@vger.kernel.org, perfmon2-devel@lists.sourceforge.net,
       perfmon@napali.hpl.hp.com
Subject: Re: perfmon2 merge news
Message-ID: <20071113183239.GF4319@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113151718.GA3804@erda.amd.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 13, 2007 at 04:17:18PM +0100, Robert Richter wrote:
> On 10.11.07 21:32:39, Andi Kleen wrote:
> > It would be really good to extract a core perfmon and start with
> > that and then add stuff as it makes sense.
> > 
> > e.g. core perfmon could be something simple like just support
> > to context switch state and initialize counters in a basic way 
> > and perhaps get counter numbers for RDPMC in ring3 on x86[1]
> 
> Perhaps a core could provide also as much functionality so that
> Perfmon can be used with an *unpatched* kernel using loadable modules?
> One drawback with today's Perfmon is that it can not be used with a
> vanilla kernel. But maybe such a core is by far too complex for a
> first merge.
> 
Note that I am not against the gradual approach such as:
	- system-wide only counting
	- per-thread counting
	- user-level sampling support
	- in-kernel sampling buffer support
	- in-kernel customizable sampling buffer formats via modules
	- event set multiplexing
	- PMU description modules

It would obvisouly cause a lot of troubles to existing perfmon libraries and
applications (e.g. PAPI). It would also be fairly tricky to do because you'd 
have to make sure that in the beginning, you leave enough flexiblity such that
you can add the rest while maintaining total backward compatibility. But given
that we already have the full solution, it could just be a matter of dropping
features without disrupting the user level API. Of course there would be a bigger
burden on the maintainer because he would have two trees to maintain but I think
that is already commonplace in many of the kernel-related projects.

Let's take a simple example. The set of syscalls necessary to control a system-wide
monitoring session is exactly the same as for a per-thread session. The difference is
just a flag when the session is created. Thus, we could keep the same set of syscalls,
but only accept system-wide sessions. Later on, when we add per-thread, we would just
have to expose the per-thread session flag.

Having said that, does not mean that this is necessarily what we will do. I am just
try to present my understanding of the comments from Andrew, Andi and others.

I think that going with a kernel module will not address the 'complexity/bloat' perception
that some people have. There is a logic to that, I did not just wakeup one day saying
'wouldn't it be cool to add set multiplexing?'. There was a true need expressed by users or
developers and it was justfied by what the hardware offered then. This unfortunately still
stands today. I admit that justification is not necessarily spelled out clearly in the code. So
I understand most of those worries and I am trying to figure out how we could best address them.

-- 
-Stephane
