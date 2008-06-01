Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYFAHYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYFAHYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 03:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYFAHYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 03:24:15 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:49791 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYFAHYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 03:24:14 -0400
Date: Sun, 1 Jun 2008 08:23:43 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
In-Reply-To: <20080531173950.c4f04028.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806010752510.24919@blonde.site>
References: <20080530102619.GA2468@elf.ucw.cz> <Pine.LNX.4.64.0805301451020.19914@blonde.site>
 <20080530204307.GA4978@ucw.cz> <Pine.LNX.4.64.0805311925190.27293@blonde.site>
 <20080531173950.c4f04028.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008, Andrew Morton wrote:
> On Sat, 31 May 2008 19:44:49 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:
> > 
> > All I can say so far is that I find the same as you do:
> > SYNC_FILE_RANGE_WRITE (after writing) takes a significant amount of time,
> > more than half as long as when you add in SYNC_FILE_RANGE_WAIT_AFTER too.
> > 
> > Which make the sync_file_range call pretty pointless: your usage seems
> > perfectly reasonable to me, but somehow we've broken its behaviour.
> > I'll be investigating ...
> 
> It will block on disk queue fullness - sysrq-W will tell.

Ah, thank you.  What a disappointment, though it's understandable.
Doesn't that very severely limit the usefulness of the system call?

I admit the flag isn't called SYNC_FILE_RANGE_WRITE_WITHOUT_WAITING,
but I don't suppose Pavel and I are the only ones misled by it.

Hugh
