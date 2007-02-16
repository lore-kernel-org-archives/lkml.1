Return-Path: <linux-kernel-owner+w=401wt.eu-S964889AbXBPRAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889AbXBPRAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964989AbXBPRAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:00:54 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:57410 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964889AbXBPRAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:00:53 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 16 Feb 2007 11:58:57 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Richard Knutsson <ricknu-0@student.ltu.se>
cc: Andreas Schwab <schwab@suse.de>, Vignesh Babu BM <vignesh.babu@wipro.com>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>,
       linux-mm@kvack.org, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ] [PATCH] is_power_of_2 in ia64mm
In-Reply-To: <45D5D47F.3000303@student.ltu.se>
Message-ID: <Pine.LNX.4.64.0702161157450.32716@CPE00045a9c397f-CM001225dbafb6>
References: <1171627435.6127.0.camel@wriver-t81fb058.linuxcoe>
 <45D5C789.1090607@student.ltu.se> <jeire2nnik.fsf@sykes.suse.de>
 <45D5D47F.3000303@student.ltu.se>
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

On Fri, 16 Feb 2007, Richard Knutsson wrote:

> Andreas Schwab wrote:
> > Richard Knutsson <ricknu-0@student.ltu.se> writes:
> >
> >
> > > Vignesh Babu BM wrote:
> > >
> > > > @@ -175,7 +176,7 @@ static int __init hugetlb_setup_sz(char *str)
> > > >  		tr_pages = 0x15557000UL;
> > > >   	size = memparse(str, &str);
> > > > -	if (*str || (size & (size-1)) || !(tr_pages & size) ||
> > > > +	if (*str || !is_power_of_2(size) || !(tr_pages & size) ||
> > > >  		size <= PAGE_SIZE ||
> > > >  		size >= (1UL << PAGE_SHIFT << MAX_ORDER)) {
> > > >  		printk(KERN_WARNING "Invalid huge page size specified\n");
> > > >
> > > >
> > > As we talked about before; is this really correct?
> > > !is_power_of_2(0) == true while (0 & (0-1)) == 0.
> >
> > size == 0 is also covered by the next two conditions, so the
> > overall value does not change.
> >
> Yes, but is it meant to state that 'size' is not a power of two?
> Otherwise, imho, it should be left as-is.

i think the above change is fine.  as long as the final, overall
semantics of the condition are identical, then there's no problem.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
