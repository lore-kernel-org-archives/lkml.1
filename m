Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZAVMPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZAVMPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 07:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZAVMPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 07:15:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58800 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZAVMPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 07:15:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ykzhao <yakui.zhao@intel.com>
Subject: Re: Suspned/resume can't work on the 2.6.29-rc1 but it can work well on the 2.6.28
Date: Thu, 22 Jan 2009 13:14:47 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: travis@sgi.com, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <1232413680.3971.32.camel@yakui_zhao.sh.intel.com> <200901202132.04682.rjw@sisk.pl> <1232590009.3651.16.camel@localhost.localdomain>
In-Reply-To: <1232590009.3651.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901221314.47801.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009, ykzhao wrote:
> On Wed, 2009-01-21 at 04:32 +0800, Rafael J. Wysocki wrote:
> > On Tuesday 20 January 2009, Ingo Molnar wrote:
> > >
> > > * Zhao Yakui <yakui.zhao@intel.com> wrote:
> > >
> > > > Hi, All
> > > >     I do some tests about suspend/resume on my two boxes. One is HP
> > > > laptop and the other is Asus EEEPC901. The suspend/resume can't work
> > > > well. Even after core is selected as the test mode, it still can't work
> > > > well.(echo core > /sys/power/pm_test)
> > > >
> > > >     Then I do the same test by using the 2.6.28 kernel. And
> > > > suspend/resume can work well.
> > > >
> > > >     Of course I will try to use the git-bisect to identify the first bad
> > > > commit ASAP.
> > >
> > > make sure you try this patch from Rafael first (it's not on lkml it
> > > appears - Rafael, mind resending the patch to this thread?):
> > 
> > Appended, and it is at:
> > http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commit;h=aa8c6c93747f7b55fa11e1624fec8ca33763a805
> > 
> > > Subject: [PATCH] PCI PM: Restore standard config registers of all devices early
> > >         (was: Re: EeePC resume failure - timers)
> > >
> > >       Ingo
> > 
> > However, first please verify if the patches from
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=12495 (3 patches)
> > http://bugzilla.kernel.org/show_bug.cgi?id=12422 (1 patch)
> > 
> > on top of the current mainline fix the problem.
> Sorry for the slow response. Thanks for the patches.
> After the four patches are applied on the 2.6.29-rc2 kernel, the
> suspend/resume can work again on the two boxes. After the
> commit(﻿aa8c6c93747f7b55fa11e1624fec8ca33763a805) is applied, it still
> works well.

Good, thanks for the confirmation.
 
> But when I use git-bisect, the git-bisect reports that the
> commit(9ea09af3bd3090e8349ca2899ca2011bd94cda85) is the bad commit.
>  >stop_machine: introduce stop_machine_create/destroy
>   As several patches are included in this patch set, I don't try whether
> the suspend/resume can work well by reverting them.

This has been fixed by commit a0e280e0f33f6c859a235fb69a875ed8f3420388
(stop_machine/cpu hotplug: fix disable_nonboot_cpus).

Thanks,
Rafael
