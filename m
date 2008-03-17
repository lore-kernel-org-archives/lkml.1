Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYCQWyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYCQWyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYCQWyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 18:54:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158AbYCQWyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:54:35 -0400
Date: Mon, 17 Mar 2008 15:52:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anders Eriksson <aeriksson@fastmail.fm>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-Reply-To: <20080317210901.0135A93C911@tippex.mynet.homeunix.org>
Message-ID: <alpine.LFD.1.00.0803171548480.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com> <alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org> <200803162054.04757.bzolnier@gmail.com> <20080316225921.CAA082DC044@tippex.mynet.homeunix.org>
 <alpine.LFD.1.00.0803161618480.3020@woody.linux-foundation.org> <20080317210901.0135A93C911@tippex.mynet.homeunix.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Mar 2008, Anders Eriksson wrote:
> 
> Mar 17 21:57:30 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
> Mar 17 21:58:00 tippex hda: lost interrupt
> 
> And the usual freeze. This is on -rc5 with Barts latest suggestion.
> 
> next?

Do you get into ide_error() too? That 176 is WIN_SMART, but you had 
earlier WIN_SMART commands that worked ok, so it's something specific that 
triggers it. data_phase = 1 is TASKFILE_IN.

So try to see if you get to ide_error(), which is where Bartlomiejs latest 
patch was in effect - but add a few printk's there to print out the 'stat' 
variable etc to see if it actually triggers. And maybe a WARN_ON(1) to get 
the trace..

		Linus

