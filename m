Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbYBYXoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbYBYXoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbYBYXoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:44:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33005 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbYBYXoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:44:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [xfs-masters] filesystem corruption on xfs after 2.6.25-rc1 (bisected, powerpc related?)
Date: Tue, 26 Feb 2008 00:42:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, johannes@sipsolutions.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080225112310.GA5516@soziologie.ch> <47C305BD.1060408@sandeen.net>
In-Reply-To: <47C305BD.1060408@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260042.35918.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 of February 2008, Eric Sandeen wrote:
> Gaudenz Steinlin wrote:
> > Hi
> > 
> > Since upgrading to 2.6.25-rc1 I see filesystem corruption on my XFS
> > filesystem. I can reproduce this by doing "git reset --hard v2.6.25-rc1"
> > on a git checkout which is on some other revision. Git outputs strange
> > error messages (like file xxx is a directory when xxx really is a file)
> > and sometimes the filesystem "hangs" (I can no longer do any operations
> > on it even from another shell). If I reboot with a working kernel and
> > check the filesystem xfs_check reports many errors. I also see the
> > problem when doing other (not related to git) operations on the
> > filesystem. Git reset is just the easiest way to reproduce it.
> > 
> > I was able to track this corruption down to commit
> > a69b176df246d59626e6a9c640b44c0921fa4566 ([XFS] Use the generic bitops
> > rather than implementing them ourselves.) using git bisect.
> > 
> > Reverting edd319dc527733e61eec5bdc9ce20c94634b6482 ([XFS] Fix
> > xfs_lowbit64) to avoid merge conflicts and the faulty commit on top of
> > 2.6.25-rc3 fixes the problem.
> 
> If you're feeling motivated, maybe you can narrow it down to which of
> the changes - xfs_highbit32, xfs_highbit64, xfs_lowbit32, or
> xfs_lowbit64 - is causing the problem?  (or maybe they all are ...)
> 
> Or maybe someone looking at the commit can immediately see the
> problem... but I can't :)

Well, IMO a reproducible filesystem corruption is a serious enough issue
for reverting all of the commits in question.

Thanks,
Rafael
