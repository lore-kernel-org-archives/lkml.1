Return-Path: <linux-kernel-owner+w=401wt.eu-S1764691AbXJPKD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764691AbXJPKD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758319AbXJPKDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:03:19 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1279 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403AbXJPKDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:03:18 -0400
Date: Tue, 16 Oct 2007 11:03:11 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] 2.6.23-git8 kernel oops at __rb_rotate_left+0x7/0x70
Message-ID: <20071016100311.GD17517@shadowen.org>
References: <47144B4F.3050108@linux.vnet.ibm.com> <20071016091012.GB24341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016091012.GB24341@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 11:10:12AM +0200, Ingo Molnar wrote:
> 
> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > While running kernbench with the 2.6.23-git8 following oops is 
> > produced
> > 
> > Unable to handle kernel NULL pointer dereference at 0000000000000010 RIP: 
> >  [<ffffffff8033f347>] __rb_rotate_left+0x7/0x70
> 
> that looks nasty ...
> 
> and -git8 should have the v2.6.23 scheduler code in essence.

To fill in a few details.  This was triggered in the middle of a
kernbench run on the machine.  A job with just dbench runs in it ran to
completion.  The machine is a 4 node numa x86_64 system.

Seems that most schedular options are on:

CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_USER_SCHED=y

At the moment we don't have any historical jobs back from 2.6.23 so I
cannot be more specific as to when it arrived in mainline.  The x86/x86_64
merge broke our build process; a bad assumption here, not a problem with
the merge.

-apw
