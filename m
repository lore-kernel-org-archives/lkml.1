Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbYAAW1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbYAAW1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 17:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbYAAW1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 17:27:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39588 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754902AbYAAW1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 17:27:22 -0500
Date: Tue, 1 Jan 2008 14:26:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Boaz Harrosh <bharrosh@panasas.com>, Alan Cox <alan@redhat.com>
Subject: Re: 2.6.24-rc6-git7: Reported regressions from 2.6.23
In-Reply-To: <200801012202.57851.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0801011408470.32517@woody.linux-foundation.org>
References: <200801012202.57851.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jan 2008, Rafael J. Wysocki wrote:
> 
> Subject	: Could not set non-blocking flag with 2.6.24-rc5
> Submitter	: Tino Keitel <tino.keitel@gmx.de>
> Date		: 2007-12-13 16:27
> References	: http://lkml.org/lkml/2007/12/13/392
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9557
> Handled-By	: 
> Patch		: 

That strace shows that trying to open /dev/null fails with ENXIO:

	[pid  6050] open("/dev/null", O_RDONLY <unfinished ...>
	[pid  6050] <... open resumed> )        = -1 ENXIO (No such device or address)

and everything goes downhill from there.

It would be worth looking at your /dev/null to see what kind of (broken) 
device node it is, and get a clue about *why* it is broken.

Greg, any udev breakage that could affect /dev/null? 

> Subject	: Problems on booting
> Submitter	: "werner" <werner@copaya.yi.org>
> Date		: 2007-12-22 14:29
> References	: http://lkml.org/lkml/2007/12/22/110
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9621
> Handled-By	: 
> Patch		: 

Hmm. I assume the "-git6" and "-git7" are 2.6.24-rc4-gitX, ie commits

 - 2.6.24-rc5-git6: 3e3b3916a9c5c28a16528585478de19fea59816b
 - 2.6.24-rc5-git7: fbdcf18df73758b2e187ab94678b30cd5f6ff9f9

and doing a

	gitk 3e3b3916a9..fbdcf18df7

does show a SCSI merge, and two commits that touch drivers/scsi/initio.*.

James, Alan and Boaz, ideas? 

		Linus
