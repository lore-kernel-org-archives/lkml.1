Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbYADU45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbYADU45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYADU4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:56:49 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:35199 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbYADU4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:56:48 -0500
Date: Fri, 4 Jan 2008 21:56:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH x86] [5/16] Replace hard coded reservations in x86-64 early boot code with dynamic table II
Message-ID: <20080104205644.GC32174@uranus.ravnborg.org>
References: <20080103442.621670000@suse.de> <200801041338.08093.ak@suse.de> <20080104144140.GA4203@elte.hu> <200801041603.58358.ak@suse.de> <20080104175128.GB31382@uranus.ravnborg.org> <20080104180650.GA2998@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104180650.GA2998@bingen.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 07:06:50PM +0100, Andi Kleen wrote:
> > What is then considered "obvious style issues" are today implemented
> > as errors / warnings in checkpatch for the most part. Not everyone
> 
> In my experience checkpatch has a lot of false positives. e.g. when 
> I run it over my pile 20+% of the warnings are just bogus. And in
> a lot of other cases it is that the rules of thumbs it applies
> do not apply to that specific case. 

Tried it on my pile of patches here.
ERROR: "foo * bar" should be "foo *bar"
#33: FILE: scripts/basic/docproc.c:61:
+FILELINE * docsection;

Legitimate error.

And a bunch of > 80 chars WARNINGS.
The warnings I ignore because I prefer readability on my 22" widescreen
but the ERROR should never had hit me.

But thats me that does not adhere to CodingStyle and checkpatch is correct.

> > No-one should submit patches with white-space errors - thank you.
> 
> No I disagree. If white space is suddenly that important -- it is still
> unclear to me why that should be -- then the right way to handle that is 
> at the maintainer level while merging patches. But rejecting patches
> for reasons that a trivial script can fix up is just unnecessary friction
> in the merging process and unnecessary bureaucracy.

Disagree. This is about a distributed model where the individual
submitters shall make life as easy as possible for the maintainer.
And the maintainer shall not be distracted by imporlerly formatted source
code that looks wird. It simple does not scale.
And no tool will help here because first review happens at the diff level
before applying any patch to any code base and the diff has thus never
seen a tool on the maintainer side.

> Unnecessary bureaucracy defined as in rituals that do not 
> actually improve any code or prevent bugs (or even style). I must say I find 
> it a little sad that Linux is dissolving into that now. Ok perhaps
> it is the eventual fate of anything that has been around for quite a long time,
> but it seems to get worse much quicker recently.
Several reasons why it has accelerated:
1) Ingo cares about checkpatch compliance
2) Ingo accepts patches fixing checkpatch compliance
3) We have a codebase that has lower quality than we usually praise us to have

I think it is fine to fix style issue when we do some major surgery in a file,
like unification.
But starting to randomly attack files all over the kernel is IMO to overdue it
and this is happening at the moment. And only carefull reviewing prevents bugs.

	Sam
