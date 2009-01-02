Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbZABLA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbZABLA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 06:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZABLAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 06:00:11 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:6776 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751587AbZABLAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 06:00:09 -0500
Date: Fri, 2 Jan 2009 19:57:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mark Miller <mark@mirell.org>
Cc: Rob Landley <rob@landley.net>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090102105742.GB28078@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mark Miller <mark@mirell.org>, Rob Landley <rob@landley.net>,
	Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <20090102095023.GA28078@linux-sh.org> <2D4EECE3-784E-4853-BF6E-B0915C15EC02@mirell.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2D4EECE3-784E-4853-BF6E-B0915C15EC02@mirell.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 04:32:42AM -0600, Mark Miller wrote:
> On Jan 2, 2009, at 3:50 AM, Paul Mundt wrote:
> >Misguided rhetoric aside, what does this actually accomplish? If folks
> >add meaningful tools in to the kernel that require python, and it is
> >generally regarded as being fairly ubiquitous, I can't imagine there
> >being any substantiated objections against it.
> 
> And if the said meaningful tools introduce complex dependencies, then  
> there should be an open discussion as to why exactly we need those  
> tools as opposed to a simpler implementation.
> 
Complex is relative, something that is fairly ubiquitious can hardly be
labelled as complex, regardless of whether historically people have had
issues with that dependency in certain spaces. In any event, simplifying
things is always good, but this open discussion thing is pure fancy,
since when was the kernel a democracy?

> >Your main reasons against inclusion of perl seem to be that there is
> >no realistic expectation for target systems that will be self-hosting
> >will have perl included, or the inherent complexity in maintaining a
> >coherent cross compiling environment. Both of these things are issues
> >with your own environment, and in no way are these representative of
> >the  embedded development community at large.
> 
> I feel that if you attempted to look for discussions on "cross- 
> compiling perl", you will meet with a variety of complaints on what a  
> nightmare it is to do so in a sandboxed environment.
> 
I've had to deal with cross compiling perl for over a decade, in all of
its various forms, in all manner of embedded applications, so please tell
someone who cares. There are various options around this headache today,
as there have been for ages (though the options these days are rather
less painful), and if you felt like attempting to look for discussions on
those rather than trying to push this silly matter perhaps you might come
up with something.

The key thing you hit on is that there are a variety of complaints, and
that is all they have ever been. If your system is so constrained, you
shouldn't be doing builds on it in the first place. You certainly won't
be able to build anything in your crippled environment outside of some
simple applications anyways, this isn't a valid technical reason for
keeping the kernel a policy stranglehold.

> >Now with that out of the way, this entire series fundamentally fails
> >to convert half of the perl scripts shipped with the kernel today,
> >some that are required for build depending on Kconfig options,
> 
[snip]

> From what I can tell, it allows one to fully build the Linux kernel  
> without Perl.

Wrong, re-read what I said and try again.

> >Ignoring the compile-time dependencies that you overlooked, what you
> >define as "development and debugging" scripts are still an integral  
> >part of the system, unless you are trying to argue that embedded
> >developers have no interest in things like checkstack due to the
> >trouble of trying to get perl built.
> 
> Do I need that to compile a kernel? No.
> 
Compile-time dependencies you do, yes.

> Perl was not required to build the Linux kernel. Now it is. It adds  
> another dependency to the Linux kernel. Requiring bash is far less a  
> dependency that Perl is.
> 
Perhaps so, but that is largely irrelevant. Moving off of the bash
dependency is a lot more trivial than moving off of the perl one. The
kernel bashisms are fairly marginal, and if someone were to do the leg
work for that, it might even be accepted. Getting rid of perl is an
uphill battle for no visible gain. People will continue to write and add
scripts both in bash and perl on a routine basis regardless.

> >The kernel is and always has been about using the right tool for the  
> >job, not a matter of dictating what tools you must use in order to
> >accomplish a task you are interested in. Common sense does apply here
> >though, so this might be a more daunting task for some than others.
> 
> How is Perl a better tool for the job than what currently bash and  
> other standard utilities already offer?
> 
How is bash a better tool for than job than what sed and posix shell
already offer? Yes, we can reduce our dependencies to the bare minimum,
but that is not constructive for the folks that are actually writing the
scripts in the first place.

Likewise, this is not even a real problem in the embedded developer
demographic, the only place this is a problem is in specially stripped
distributions or people that don't want to go through the pain of cross
compiling perl. None of which is of any concern.

If people are going to write useful things that are reasonably expected
to be standard on build machines, there is no reason to restrict what
tools they are permitted to use. If you have a personal vendetta against
something that is fairly standard, that is entirely your own personal
problem, you can choose to deal with it or patch out of tree for your own
crippled environment (assuming patch isn't too much of an obscure
dependency).
