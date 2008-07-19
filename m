Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYGSPHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYGSPHD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 11:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbYGSPGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 11:06:53 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:48600 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbYGSPGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 11:06:52 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: Russ Anderson <rja@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 0/2] Migrate data off physical pages with corrected memory errors (Version 7)
From: Andi Kleen <andi@firstfloor.org>
References: <20080718203514.GD29621@sgi.com>
	<87prpa88iw.fsf@basil.nowhere.org>
	<20080719121328.GA20138@parisc-linux.org>
Date: Sat, 19 Jul 2008 17:06:49 +0200
In-Reply-To: <20080719121328.GA20138@parisc-linux.org> (Matthew Wilcox's message of "Sat, 19 Jul 2008 06:13:28 -0600")
Message-ID: <87ljzx9aly.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Jul 2008 15:06:46.0800 (UTC) FILETIME=[100F9900:01C8E9B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> On Sat, Jul 19, 2008 at 12:37:11PM +0200, Andi Kleen wrote:
>> Russ Anderson <rja@sgi.com> writes:
>> 
>> > [PATCH 0/2] Migrate data off physical pages with corrected memory errors (Version 7)
>> 
>> FWIW I discussed this with some hardware people and the general
>> opinion was that it was way too aggressive to disable a page on the
>> first corrected error like this patchkit currently does.  
>
> I think it's reasonable to take a page out of service on the first error.
> Then a user program needs to be notified of which bit is suspected.
> It can then subject that page to an intense set of tests (I'd start
> by stealing the ones from memtest86+) and if no more errors are found,
> it could return the page to service.

That would only really help if really only parts of that specific page
is corrupted.  But my understanding is that DIMM failures usually
cluster in larger units (channels, DIMMs, memory chips on them, banks
inside the chips etc., all far larger than a 4K page)

So to do your proposal you would need to do this on the units of whole
DIMMs or at least their pages, otherwise it is somewhat
pointless. Since the memory systems typically interleave this would
likely need to be done on multiple DIMMs, potentially covering a large
memory area.

In the end you'll end up with most of the mess of memory hot unplug
because the more memory is affected the more likely it is 
some unmoveable kernel data is affected.

-Andi
