Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYGSMNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYGSMNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYGSMNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:13:31 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50982 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbYGSMNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:13:30 -0400
Date: Sat, 19 Jul 2008 06:13:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: Russ Anderson <rja@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 0/2] Migrate data off physical pages with corrected memory errors (Version 7)
Message-ID: <20080719121328.GA20138@parisc-linux.org>
References: <20080718203514.GD29621@sgi.com> <87prpa88iw.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87prpa88iw.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 12:37:11PM +0200, Andi Kleen wrote:
> Russ Anderson <rja@sgi.com> writes:
> 
> > [PATCH 0/2] Migrate data off physical pages with corrected memory errors (Version 7)
> 
> FWIW I discussed this with some hardware people and the general
> opinion was that it was way too aggressive to disable a page on the
> first corrected error like this patchkit currently does.  

I think it's reasonable to take a page out of service on the first error.
Then a user program needs to be notified of which bit is suspected.
It can then subject that page to an intense set of tests (I'd start
by stealing the ones from memtest86+) and if no more errors are found,
it could return the page to service.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
