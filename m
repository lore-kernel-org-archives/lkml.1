Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbXFIPGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbXFIPGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 11:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbXFIPGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 11:06:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:51126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbXFIPGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 11:06:00 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Greg KH <greg@kroah.com>
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Date: Sat, 9 Jun 2007 17:05:56 +0200
User-Agent: KMail/1.9.5
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com>
In-Reply-To: <20070609001703.GA17644@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706091705.57082.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 June 2007 02:17, Greg KH wrote:
> On Sat, Jun 09, 2007 at 12:03:57AM +0200, Andreas Gruenbacher wrote:
> > AppArmor is meant to be relatively easy to understand, manage, and
> >  customize, and introducing a labels layer wouldn't help these goals.
> 
> Woah, that describes the userspace side of AA just fine, it means
> nothing when it comes to the in-kernel implementation. There is no 
> reason that you can't implement the same functionality using some
> totally different in-kernel solution if possible.

I agree that the in-kernel implementation could use different abstractions 
than user-space, provided that the underlying implementation details can be 
hidden well enough. The key phrase here is "if possible", and in fact "if 
possible" is much too strong: very many things in software are possible, 
including user-space drives and a stable kernel module ABI. Some things make 
sense; others are genuinely bad ideas while still possible.

The things in my reply you chose not to quote make up the essential part of 
the model, argue why mapping from an AppArmor-like user-space to a 
label-based in-kernel model is fundamentally hard, how implementation details 
cannot be hidden, and how such a mapping would lead to disadvantages no 
matter which way you look at it.

> > SELinux is applicable in areas where AppArmor is not (e.g., MLS), but
> > this comes at a cost. For me the question is not SELinux or AppArmor,
> > but if AppArmor's security model is a good solution in common
> > scenarios. In my opinion, AppArmor is a better answer than SELinux in
> > a number of scenarios. This gives it value, nonwithstanding the fact
> > that SELinux can be taken further.
> 
> I am still not completely certian that we can not properly implement AA
> functionality using a SELinux backend solution.  Yes, the current tools
> that try to implement this are still lacking, and maybe the kernel needs
> to change, but that is possible.

I did not pull all of this out of my hat ad hoc. The AppArmor team spent a 
fair amount of time researching various ways how AppArmor-like semantics 
could be implemented on top of SELinux, as well as ways how AppArmor could be 
implemented better. We *really* tried hard. The reason why we are still 
proposing this non-SELinux approach is because none of the alternatives 
worked out.

If things were as simple as mapping an AppArmor frontend to the SELinux 
backend, even with extensions to the SELinux backend (and I know that it 
wouldn't be impossible to extend SELinux in reasonable ways), this would 
indeed be nice. The issues that SEEdit is having unfortunately only confirm 
what we were already certain to know: it just doesn't work.

> I still want to see a definition of the AA "model" that we can then use
> to try to implement using whatever solution works best.  As that seems
> to be missing the current argument of if AA can or can not be
> implemented using SELinux or something totally different should be
> stopped.

There is no need to start all over implementing something from scratch. People 
have already tried emulating AppArmor on top of SELinux, and SEEdit is the 
current best result. All it takes is the time to understand the SELinux and 
AppArmor models. From there it is not hard to see that SEEdit does the best 
it can do, and how it is just not a good idea. There are a few things that 
could be improved with additional SELinux in-kernel infrastructure, but the 
fundamental problems remain. It just remains a very bad idea.

> So, AA developers, do you have such a document anywhere?  I know there
> are some old research papers, do they properly describe the current
> model you are trying to implement here?

We wrote an AppArmor technical documentation, and it was posted as part of the 
last two AppArmor submissions. It describes the model, and how the model is 
implemented. If you need a better description of the model, let us know how 
we can improve it.

  http://forgeftp.novell.com//apparmor/LKML_Submission-May_07/techdoc.pdf

What you'll not find in there is a detailed comparison between AppArmor and 
SELinux, and the problems that emulating AppArmor on top of SELinux would 
cause -- some details on that can be found in the SEEdit documentation, and 
in addition, this LKML thread seems best to me at the moment.

Andreas
