Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbYHZIfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbYHZIfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYHZIfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:35:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYHZIfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:35:37 -0400
Date: Mon, 25 Aug 2008 22:35:34 -1000
From: Joshua Hoblitt <j_kernel@hoblitt.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080826083534.GH10646@hoblitt.com>
References: <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com> <20080822021512.GJ23377@hoblitt.com> <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com> <86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com> <20080822035024.GB30284@elte.hu> <20080822035609.GD30284@elte.hu> <86802c440808212148k74e56fa2mdb2e329ed4df1271@mail.gmail.com> <20080823002235.GL23377@hoblitt.com> <86802c440808222252j6f900f1dlfbf1378a7bc35ee4@mail.gmail.com> <20080823104311.GC25904@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080823104311.GC25904@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 12:43:11PM +0200, Ingo Molnar wrote:
> 
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > On Fri, Aug 22, 2008 at 5:22 PM, Joshua Hoblitt <j_kernel@hoblitt.com> wrote:
> > > I've confirmed that the boards in these systems are Tyan Tempest 
> > > i5400PW (S5397)s.  We've discovered a workload that will deadlock 
> > > the system under both 2.6.24.2 and -tip kernel with the mtrr masking 
> > > patch.  The only thing unusual about this workload is that one of 
> > > the binaries in it constantly segvs...  Is it possible that these 
> > > deadlocks (no kernel oops on console) are caused by MSR setup 
> > > wierdness or is it likely unrelated?
> > 
> > could be other problem.
> > 
> > cpu should be smarter enough to understand the missing bits in mask. 
> > at least amd cpu. remember that we didn't set mask bits to 40bits with 
> > opteron with LinuxBIOS, and everything still works well.
> 
> yeah. Is the deadlock debuggable? (does nmi_watchdog=1 produce anything 
> useful, or does the enabling of CONFIG_PROVE_LOCKING=y show anything 
> weird in the syslog during light, non-deadlocking use of this workload?)

Enabling the nmi_watchdog doesn't produce anything at all (I double
checked the .config... it should be working).  Rebuilding with
PROVE_LOCKING seems to have prevented the deadlock.  It used to take
30-45 mins to lock the system up under heavy load and we're going on 6
hours here with no issues.  Absolutely nothing in the dmesg.  Ugh.  Any
other suggestions?  How bad is it to leave PROVE_LOCKING enabled?

-J

--
