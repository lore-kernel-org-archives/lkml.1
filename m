Return-Path: <linux-kernel-owner+w=401wt.eu-S1763679AbXIKL5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763679AbXIKL5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 07:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762632AbXIKL5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 07:57:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35389 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbXIKL5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 07:57:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: clockevents: fix resume logic
Date: Tue, 11 Sep 2007 14:09:12 +0200
User-Agent: KMail/1.9.5
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <200707220159.l6M1xBgH001236@hera.kernel.org> <200709111323.56030.rjw@sisk.pl> <20070911042228.1ef690e0.akpm@linux-foundation.org>
In-Reply-To: <20070911042228.1ef690e0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111409.13796.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 September 2007 13:22, Andrew Morton wrote:
> On Tue, 11 Sep 2007 13:23:55 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Tuesday, 11 September 2007 12:31, Andrew Morton wrote:
> > > On Tue, 11 Sep 2007 11:16:04 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> > > 
> > > > On Tue, 2007-09-11 at 01:35 -0700, Andrew Morton wrote:
> > > > > On Tue, 11 Sep 2007 01:20:05 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > 
> > > > > > On Tue, 11 Sep 2007 09:47:20 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> > > > > > 
> > > > > > > On Tue, 2007-09-11 at 09:23 +0200, Thomas Gleixner wrote:
> > > > > > > > > I went back to the original patch which I sent to Linus and it matches
> > > > > > > > > 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6.  So all I can think is that there
> > > > > > > > > must have been something else in the tree which I tested which fixed the
> > > > > > > > > bug which 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6 introduced.  argh.
> > > > > > > > > 
> > > > > > > > > Can you think what would cause the symptoms which I described?  
> > > > > > > > 
> > > > > > > > It seems that time is not updated. Timer interrupt not active or some
> > > > > > > > other odd thing. I figure out what's going on when I find a box which
> > > > > > > > exposes the problem.
> > > > > > 
> > > > > > 2.6.22-rc6-mm1's git-acpi.patch contains something which fixes this bug. 
> > > > > 
> > > > > Len's current tree fixes it too.
> > 
> > Do you mean this one:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git
> 
> Nope.
> 
> Here's the algorthm: go to the latest -mm tree and look at the first line
> of broken-out/git-acpi.patch:
> 
> GIT f94aac9883f9b02700270cf286577a9bccf98f47 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git#test
> 
> that gives the URL, the branch and the top-level commit.  All the -mm git
> trees have that first line.
> 
> 
> 
> Anyway, I was able to extract all the diffs and generate a patch series. 
> The below patch fixes current mainline on the Vaio.

It evidently assumes cpuidle to be present, which is not in the mainline.

It seems to me that the total effect of this one and the hackpatch is that
the C states are not handled any more.
