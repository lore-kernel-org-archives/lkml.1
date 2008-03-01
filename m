Return-Path: <linux-kernel-owner+w=401wt.eu-S1761094AbYCAPhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094AbYCAPhn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 10:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYCAPhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 10:37:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:40852 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbYCAPhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 10:37:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=qLBlfIfKJSGzLs11w06ijwDIwlYo4R1IpH1WRHgF374fBr4+8MYmBwcz99JwejXR1uNkEelUFd4K16m2Vb6yiQQAJu3ffy9HMeK1ZH0rWzJtdrLWxiXNldP2TXoI/15SDlh5Mi5uNp8m5T+PRx2dYsmrABsNjHoaC05V66RHNvw=
Date: Sat, 1 Mar 2008 16:37:13 +0100
To: Adrian Bunk <bunk@kernel.org>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 00/24] ide-tape: remove pipelined mode operation
Message-ID: <20080301153713.GA30547@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Adrian Bunk <bunk@kernel.org>,
	bzolnier@gmail.com, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <20080301102038.GC25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080301102038.GC25835@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 12:20:38PM +0200, Adrian Bunk wrote:
> On Sat, Mar 01, 2008 at 09:58:24AM +0100, Borislav Petkov wrote:
> > Hi Bart,
> > 
> > here's the 1st draft of the pipeline removal series. As the diffstat below openly
> > states it, a lot of code got removed - even more than the cleanup series we did
> > earlier.
> >...
> 
> After seeing commit d48567dd43868b3d2e1fcc33ee76dc2d38a1ddeb that 
> schedules ide-tape for removal I'm wondering whether any cleanups of 
> this driver make any sense at all:

Hi Adrian,

you're right and I'm expecting Bart's input on that. However, removing
tape support in ide altogether is probably not the right thing to do and
Bart wanted to keep some kind of a basic, ide-tape "light" version in so,
yes, the above commit is misleading.

Here's a fix, Bart please apply.

--
>From 11c41d7760dd0b8f4cd1ab3076c86a2c4beec4de Mon Sep 17 00:00:00 2001
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sat, 1 Mar 2008 16:31:17 +0100
Subject: [PATCH] ide-tape: keep a light version in ide tree

Keep a light version of the driver in for the
small amount of ide tape hardware still using it.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 Documentation/feature-removal-schedule.txt |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index ba899ff..4d3aa51 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -172,16 +172,6 @@ Who:	Len Brown <len.brown@intel.com>
 
 ---------------------------
 
-What:	ide-tape driver
-When:	July 2008
-Files:	drivers/ide/ide-tape.c
-Why:	This driver might not have any users anymore and maintaining it for no
-	reason is an effort no one wants to make.
-Who:	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov
-	<petkovbb@googlemail.com>
-
----------------------------
-
 What: libata spindown skipping and warning
 When: Dec 2008
 Why:  Some halt(8) implementations synchronize caches for and spin
-- 
1.5.4.1

-- 
Regards/Gruﬂ,
    Boris.
