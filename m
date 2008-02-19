Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbYBSGpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbYBSGpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 01:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYBSGpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 01:45:05 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:51341 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbYBSGpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 01:45:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IjC+AGH0IfR7kWlAPGCdGea/hYKRWlJchozJgvSl0Aqlw25NZczH8lenGkywSU2/V50rMYPLanDzTRPrhZTcPeQGSLk2WsiqQcmEvgsaowYnSlyb7zTmMeW+IMB2JiYewc7qC0JdDFQOtUa7vdYSCL+33I6K/Qz8/njoLHEH4JQ=
Message-ID: <64bb37e0802182244i69f161d0y34ac4cace386147c@mail.gmail.com>
Date: Tue, 19 Feb 2008 07:44:59 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc2
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0802181553180.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
	 <alpine.LFD.1.00.0802181553180.7833@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 12:54 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 16 Feb 2008, Torsten Kaiser wrote:
> >
> > [ 5282.056415] ------------[ cut here ]------------
> > [ 5282.059757] kernel BUG at lib/list_debug.c:33!
>
> Is there any chance that you could try to bisect this, if it's repeatable
> enough for you? Even if you can't bisect it *all* the way, it would be
> really good to do a handful of bisection runs which should already
> hopefully narrow it down a bit more.
>
>                 Linus
>

It's repeatable, but not in a really reliable way.
So to mark a kernel good I need to compile around 100 KDE packages,
and even then I'm not 100% sure, if it's good or if I was just lucky.

But I did a partly bisect against 2.6.24-rc6-mm1:
2.6.24-rc6 + mm-patches up to (including) git.nfsd -> worked
2.6.24-rc6 + mm-patches up to (including) git.xfs -> crashed

I think the only added patch between rc2-mm1 and rc3-mm2 in that range
where the iommu changes that I later ruled out.
That leaves some git trees as suspects:
git-ocfs2.patch
git-selinux.patch
git-s390.patch
git-sched.patch
git-sh.patch
git-scsi-misc.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
git-x86.patch
git-xfs.patch

(see http://marc.info/?l=linux-kernel&m=120276641105256 )

Torsten
