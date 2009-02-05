Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbZBERYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbZBERYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZBERY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:24:26 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:41514 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZBERYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:24:25 -0500
Date: Thu, 5 Feb 2009 17:23:29 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
In-Reply-To: <1233791329.4612.23.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0902051713550.1445@blonde.anvils>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>  <pWZw1SZjMCH.A.sIE.wuYiJB@chimera>
 <1233791329.4612.23.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, Benjamin Herrenschmidt wrote:
> On Wed, 2009-02-04 at 11:24 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> 
> I still don't know what's the best way to handle that one... the bug is
> in X and I don't see a way to work around it without removing support
> for legacy memory access from the kernel :-( Or doing it in a way that
> doesn't allow userspace to differenciate between the kernel not
> supporting it vs. the HW not supporting it, causing X to fallback to
> even more broken crap.

Is it a really a bug in X, or a misunderstanding between X and
the kernel as to what existence of the legacy_mem file implies?

I may have got this quite wrong, but to me it appears that X assumes
that existence of the legacy_mem file implies that it will be useful;
whereas the kernel thinks it can make the legacy_mem file available,
even if it cannot be used for mmapping mem - which is its sole purpose?

What if pci_create_legacy_files() were to call some new verification
routine, and only create the legacy_mem file if it would be usable?
(But perhaps that cannot be known at the time it needs to be created.)

Hugh

> 
> I'll try to find out the extent of the X problem and whether that's
> fixable in a way that can hit distros.
> 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12608
> > Subject		: 2.6.29-rc powerpc G5 Xorg legacy_mem regression
> > Submitter	: Hugh Dickins <hugh@veritas.com>
> > Date		: 2009-01-21 21:12 (15 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d3a54014e2a94bd37b7dee5e76e03f7bc4fab49a
> > References	: http://marc.info/?l=linux-kernel&m=123257250431870&w=4
> > Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
