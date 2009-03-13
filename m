Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZCMJTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZCMJTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZCMJT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:19:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37910 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbZCMJT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:19:28 -0400
Date: Fri, 13 Mar 2009 10:18:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>, Greg Kroah-Hartman <gregkh@novell.com>
Subject: Re: [PATCH v2] x86: mtrr: don't modify RdDram/WrDram bits of fixed
	MTRRs
Message-ID: <20090313091812.GB2571@elte.hu>
References: <20090311150027.GK10490@alberich.amd.com> <20090312163937.GH20716@alberich.amd.com> <20090313015856.GA18760@elte.hu> <200903130942.38568.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903130942.38568.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Renninger <trenn@suse.de> wrote:

> On Friday 13 March 2009 02:58:56 Ingo Molnar wrote:
> > 
> > * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> > 
> > > Impact: bug fix + BIOS workaround
> > 
> > > Change to previous version:
> > > I slightly modified the log message (e.g. addition of FW_WARN).
> > > 
> > > Please consider to apply this patch for .29.
> > 
> > i've applied it to tip:x86/mtrr, thanks Andreas.
> > 
> > I've add a -stable backport tag - so if it's problem-free it 
> > should show up in .29.1.
> 
> What does -stable backport tag mean?

It means such lines added to commit logs:

    Cc: <stable@kernel.org>

Greg has scripting in place to pick up such commits 
automatically into -stable.

AFAIK Andrew Morton was the first maintainer who started using 
these tags consistently, at around 2006.

> Is this something tip:x86 or Ingo Molnar specific?

We do it consistently for all fixes we identify as -stable 
backport candidates that go via -tip but the practice existed 
upstream long before we started doing it.

Even with such tags it's still a lot of non-trivial work to keep 
-stable going:

 - there are those fixes which are identified as fixes only 
   after they have been committed (without tags)

 - there are those fixes that have not been tagged at all

 - often patches will not apply or break if applied out of 
   sequence.

But adding <stable@kernel.org> certainly helps.

> I saw quite some "easy" fixes not being added/submitted to 
> stable in other subsystems and doing double work going through 
> them, pick them out and submit them to stable is an 
> unnecessary waste of time and some fixes will slip through.

Pointing out specific examples where the backport was realized 
when the fix was committed but the tag was not added or outright 
lost, and talking to those those maintainers might help. Often 
it's a matter of "Oh, cool, did not know that!" realization.

Interestingly, the second-ever such tag i found in Git history 
was for a fix ... from you:

 commit 59d399d357a7705568f424c6e861ee8657f7f655
 Author: Thomas Renninger <trenn@suse.de>
 Date:   Tue Nov 8 05:27:00 2005 -0500

    [ACPI] Fix Null pointer deref in video/lcd/brightness

    http://bugzilla.kernel.org/show_bug.cgi?id=5571

    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
    Signed-off-by: Yu Luming <luming.yu@gmail.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

:-)

	Ingo
