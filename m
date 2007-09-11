Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbXIKS1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbXIKS1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764072AbXIKS11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:27:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764071AbXIKS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:27:26 -0400
Date: Tue, 11 Sep 2007 11:25:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: clockevents: fix resume logic
Message-Id: <20070911112531.80bac380.akpm@linux-foundation.org>
In-Reply-To: <200709111409.13796.rjw@sisk.pl>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	<200709111323.56030.rjw@sisk.pl>
	<20070911042228.1ef690e0.akpm@linux-foundation.org>
	<200709111409.13796.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 14:09:12 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, 11 September 2007 13:22, Andrew Morton wrote:
> > On Tue, 11 Sep 2007 13:23:55 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Tuesday, 11 September 2007 12:31, Andrew Morton wrote:
> > > > On Tue, 11 Sep 2007 11:16:04 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> > > > 
> > > > > On Tue, 2007-09-11 at 01:35 -0700, Andrew Morton wrote:
> > > > > > On Tue, 11 Sep 2007 01:20:05 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > > 
> > > > > > > On Tue, 11 Sep 2007 09:47:20 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> > > > > > > 
> > > > > > > > On Tue, 2007-09-11 at 09:23 +0200, Thomas Gleixner wrote:
> > > > > > > > > > I went back to the original patch which I sent to Linus and it matches
> > > > > > > > > > 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6.  So all I can think is that there
> > > > > > > > > > must have been something else in the tree which I tested which fixed the
> > > > > > > > > > bug which 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6 introduced.  argh.
> > > > > > > > > > 
> > > > > > > > > > Can you think what would cause the symptoms which I described?  
> > > > > > > > > 
> > > > > > > > > It seems that time is not updated. Timer interrupt not active or some
> > > > > > > > > other odd thing. I figure out what's going on when I find a box which
> > > > > > > > > exposes the problem.
> > > > > > > 
> > > > > > > 2.6.22-rc6-mm1's git-acpi.patch contains something which fixes this bug. 
> > > > > > 
> > > > > > Len's current tree fixes it too.
> > > 
> > > Do you mean this one:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git
> > 
> > Nope.
> > 
> > Here's the algorthm: go to the latest -mm tree and look at the first line
> > of broken-out/git-acpi.patch:
> > 
> > GIT f94aac9883f9b02700270cf286577a9bccf98f47 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git#test
> > 
> > that gives the URL, the branch and the top-level commit.  All the -mm git
> > trees have that first line.
> > 
> > 
> > 
> > Anyway, I was able to extract all the diffs and generate a patch series. 
> > The below patch fixes current mainline on the Vaio.
> 
> It evidently assumes cpuidle to be present, which is not in the mainline.

Bear in mind that the cpuidle patch fixes resume-from-ram when cpuidle is
disabled in config.

> It seems to me that the total effect of this one and the hackpatch is that
> the C states are not handled any more.

hm.

dmesg without the cpuidle patch: http://userweb.kernel.org/~akpm/dmesg-bad.txt
dmesg with the cpuidle patch: http://userweb.kernel.org/~akpm/dmesg-good.txt
difference: http://userweb.kernel.org/~akpm/dmesg-diff.txt

there doesn't seem to be a lot of difference in the time handling, except
there are large changes in when things happen in the bootup sequence.

