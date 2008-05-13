Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbYEMVpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbYEMVpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbYEMVpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:45:35 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:5466 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbYEMVpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:45:34 -0400
From: Frans Pop <elendil@planet.nl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [Bug #10616] Horrendous Audio Stutter - current git
Date: Tue, 13 May 2008 23:44:34 +0200
User-Agent: KMail/1.9.9
Cc: parag.warudkar@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       peterz@infradead.org
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.K6.1w1JIB@chimera> <82e4877d0805111428j3f73f436w1c6094c779f6110d@mail.gmail.com> <82e4877d0805111428j3f73f436w1c6094c779f6110d@mail.gmail.com> <20080511214131.GM1645@cs181133002.pp.htv.fi>
In-reply-To: <20080511214131.GM1645@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805132344.35645.elendil@planet.nl>
X-OriginalArrivalTime: 13 May 2008 21:44:36.0194 (UTC) FILETIME=[89A6D420:01C8B542]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 May 2008, you wrote:
> On Sun, May 11, 2008 at 05:28:47PM -0400, Parag Warudkar wrote:
> > On Sun, May 11, 2008 at 4:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > >
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.25.  Please verify if it still should be listed.
> > >
> > >
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10616
> > > Subject         : Horrendous Audio Stutter - current git
> >
> > Still present both in Linus tree and sched-devel - root cause is not
> > yet well understood per Ingo.
> >
> > Worked around by disabling GROUP_SCHED stuff by default (commit
> > aac6abca858386438d9a7233c3471d2ecfa2f704 ).
>
> What causes this regression?
>
> Is this commit 018d6db4cb5bbdcd65424a16f2dcca692ed32ae4
> (sched: re-do "sched: fix fair sleepers") that had already been reverted
> in 2.6.25 for causing such regressions or is this caused by a different
> commit?

No, it's not that commit. That commit also caused a (less severe and fairly 
hard to reproduce) latency issue, but that has now been fixed by the patch 
listed in the BR (committed as a992241de614dd2b7c97a9ba64e28c0e563f19bf).


The issue reported by Parag as "Horrendous Audio Stutter" (and confirmed by 
me) is much more severe and is indeed related to group scheduling.

The group scheduling related issue disappeared for me with -rc1 after 
reverting the following two commits (as suggested by Mike Galbraith):
- 7ba2e74ab5a0518bc953042952dd165724bc70c9
  sched: debug: show a weight tree
- 8f1bc385cfbab474db6c27b5af1e439614f3025c
  sched: fair: weight calculations

Given the confusing and partially incorrect information in this BR, it seems 
best to me to close it and open a new one for the issue reported by Parag.

Cheers,
FJP
