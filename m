Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbYAFOFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbYAFOFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYAFOFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:05:08 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37218 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbYAFOFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:05:06 -0500
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Osterlund <petero2@telia.com>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
References: <20080102162534.GA4041@elte.hu>
	 <1199292381.3258.32.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
	 <20080102194030.GC11638@parisc-linux.org>
	 <1199304735.3258.53.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>
	 <1199316785.3258.85.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
	 <m3ir27oe7f.fsf@telia.com>
	 <alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 08:04:56 -0600
Message-Id: <1199628296.5205.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-01-05 at 19:43 -0800, Linus Torvalds wrote:
> This all still leaves the question unanswered why that commit 
> 6f5391c283d7fdcf24bf40786ea79061919d1e1d changed any behaviour at
> all. 
> Because the thing that Peter is describing has nothing to do with any 
> low-level drivers what-so-ever.

It isn't even a secondary effect like I thought.  This commit genuinely
didn't have anything to do with the bug, it was purely accidental.  It
came about because if you look at the reporter's recipe to reproduce,
which all of us tried without success, it's missing several steps.  To
get the bug, these steps must have been done somehow, but I bet by pure
chance they weren't when reverting
6f5391c283d7fdcf24bf40786ea79061919d1e1d which led to wrongly fingering
this commit.

Now, if only someone who understood the mechanics of what the commit was
doing tried to stop you reverting it we could have saved a lot of
trouble ...

James


