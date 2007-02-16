Return-Path: <linux-kernel-owner+w=401wt.eu-S932502AbXBPRKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbXBPRKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbXBPRKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:10:48 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:58012 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483AbXBPRKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:10:46 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 16 Feb 2007 12:06:03 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Richard Knutsson <ricknu-0@student.ltu.se>
cc: Andreas Schwab <schwab@suse.de>, linux-mm@kvack.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ] [PATCH] is_power_of_2 in ia64mm
In-Reply-To: <45D5DE6F.6030604@student.ltu.se>
Message-ID: <Pine.LNX.4.64.0702161202270.32716@CPE00045a9c397f-CM001225dbafb6>
References: <1171627435.6127.0.camel@wriver-t81fb058.linuxcoe>
 <45D5C789.1090607@student.ltu.se> <jeire2nnik.fsf@sykes.suse.de>
 <45D5D47F.3000303@student.ltu.se> <je3b56nlds.fsf@sykes.suse.de>
 <45D5DE6F.6030604@student.ltu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i'm not clear on what the possible problem is here:

On Fri, 16 Feb 2007, Richard Knutsson wrote:

> Andreas Schwab wrote:
> > Richard Knutsson <ricknu-0@student.ltu.se> writes:
> >
> >> Andreas Schwab wrote:
> >>
> >>> Richard Knutsson <ricknu-0@student.ltu.se> writes:
> >>>
> >>>
> >>>> Vignesh Babu BM wrote:
> >>>>
> >>>>> @@ -175,7 +176,7 @@ static int __init hugetlb_setup_sz(char *str)
> >>>>>  		tr_pages = 0x15557000UL;
> >>>>>   	size = memparse(str, &str);
> >>>>> -	if (*str || (size & (size-1)) || !(tr_pages & size) ||
> >>>>> +	if (*str || !is_power_of_2(size) || !(tr_pages & size) ||
> >>>>>  		size <= PAGE_SIZE ||
> >>>>>  		size >= (1UL << PAGE_SHIFT << MAX_ORDER)) {
> >>>>>  		printk(KERN_WARNING "Invalid huge page size specified\n");
> >>>>>
> >>>> As we talked about before; is this really correct? !is_power_of_2(0) ==
> >>>> true while (0 & (0-1)) == 0.
> >>>>
> >>> size == 0 is also covered by the next two conditions, so the overall value
> >>> does not change.
> >>>
> >> Yes, but is it meant to state that 'size' is not a power of two?
> >>
> >
> > What else can it mean?

> What about !one_or_less_bit()? It has not been implemented (yet?)
> but been discussed.

but whether or not it's been implemented doesn't change whether or not
the code above can be simplified.  given what's being tested, and the
error message about whether a page size is valid, it seems fairly
clear that this is a power of two test.  what's the problem?

> It ended by concluding that is_power_of_2() should be fixed up first
> and then we can see about it.

there's nothing about is_power_of_2() that needs "fixing".  it's
correct as it's currently implemented.

> And as I stated before; !is_power_of_2(size) != (size & (size-1))!
> It may be a bug but then we have to be sure it is suppose to be the
> power of 2.

it may be that certain tests in the current code need to be examined
carefully to clarify what's being tested.  but the code above seems
straightforward.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
