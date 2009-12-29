Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbZL2V3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbZL2V3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZL2V3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:29:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40491 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZL2V3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:29:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14730] sky2 won't work after suspend/resume cycle
Date: Tue, 29 Dec 2009 22:29:47 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Maciej J. Woloszyk" <mat@esi.com.pl>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.6LD.JxhOLB@chimera> <878wcltyg5.fsf@devron.myhome.or.jp>
In-Reply-To: <878wcltyg5.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912292229.47644.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, OGAWA Hirofumi wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14730
> > Subject		: sky2 won't work after suspend/resume cycle
> > Submitter	: Maciej J. Woloszyk <mat@esi.com.pl>
> > Date		: 2009-12-04 09:02 (26 days old)
> 
> This seems to be related to commit 4b77b0a2ba27d64f58f16d8d4d48d8319dda36ff.
> 
> It clears dev->state_saved blindly, but pci_pm_resume() calls
> pci_restore_standard_config() before pm->resume() (by probably
> historical reason).

The other way around.  pci_restore_standard_config() is the new thing and the
pci_restore_state() in ->resume() is supposed to be unnecessary.  Unfortunately
in this case the restoration of PCI config registers in
pci_restore_standard_config() doesn't work.

I'd like to understand the reason, but temporarily we can just set
pdev->state_saved to 1 in sky2_resume(), as proposed in the bug entry.

> So, I guess it became the cause of restore regression before changing
> PCI power state. It might be better to revert
> 4b77b0a2ba27d64f58f16d8d4d48d8319dda36ff for now, until changing pci
> generic stuff.

In fact 4b77b0a2ba27 is a bug fix so I'm afraid it won't be safe to revert it.

Rafael
