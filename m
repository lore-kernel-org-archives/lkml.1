Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbZKKLgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbZKKLgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 06:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZKKLgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 06:36:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35082 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbZKKLgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 06:36:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [linux-pm] intermittent suspend problem again
Date: Wed, 11 Nov 2009 12:38:22 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc6-tst; KDE/4.3.1; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200910291936.14082.rjw@sisk.pl> <87my2tnvtu.fsf@tac.ki.iif.hu>
In-Reply-To: <87my2tnvtu.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911111238.22696.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 November 2009, Ferenc Wagner wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Thursday 29 October 2009, Ferenc Wagner wrote:
> >
> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> 
> >>> On Wednesday 28 October 2009, Ferenc Wagner wrote:
> >>> 
> >>>> 2.6.32-rc5 feels particularly bad, with frequent failures to switch
> >>>> off the machine after "S|" or freezes after "Snapshotting system".
> >>>> The former does not cause much trouble in itself, as the machine can
> >>>> be switched off and resumed all right, but the latter is nasty.
> >>>> Suspend to RAM works all the time.  The issue is not reproducible,
> >>>> unfortunately, and the kernel change happened almost together with a
> >>>> BIOS upgrade.  Yesterday I switched back to 2.6.31 to see whether it
> >>>> still works stably with the new BIOS.  I'll report back my findings in
> >>>> a couple of days.
> >>>
> >>> OK, thanks.
> >>>
> >>> Still, I'm really afraid we won't be able to debug it any further without a
> >>> reproducible test case.
> >>
> >> Can't you perhaps suggest a way forward there?  Or some tricks to create a
> >> reproducible test case here?
> >
> > Well, you can test if the problem is reproducible in the "shutdown" mode of
> > hibernation.
> 
> Well, both failure modes happen with "shutdown" mode as well (the S|
> freeze with yesterday's git, too), but still not reproducibly.  When
> s2disk is stuck in "Snapshotting system", the system is not completely
> dead, it echoes line feeds and Ctrl-C at least (as added to #14504).
> 
> I wonder what you did if the issue was reproducible...  Is that totally
> unapplicable if the problem happens with 10% probability only?  Slow,
> sure, but until I manage to set up an automated testing bench...

I would try to identify the commit that made the problem appear using git
bisection.  However, this is really difficult with problems that are not
reliably reproducible.

Failing that, I would add some instrumentation to the code to identify the
exact place where it hangs.

BTW, did you carry out the /sys/power/pm_test "core" test on the box?

Rafael
