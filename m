Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbXFLP3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbXFLP3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXFLP3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:29:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:14319 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbXFLP3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:29:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,412,1175497200"; 
   d="scan'208";a="238263374"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Tue, 12 Jun 2007 08:29:21 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706071530.51552.jesse.barnes@intel.com> <20070612145007.GA5986@ucw.cz>
In-Reply-To: <20070612145007.GA5986@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706120829.21465.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 12, 2007 7:50:08 Pavel Machek wrote:
> Hi!
>
> > On some machines, buggy BIOSes don't properly setup WB MTRRs to
> > cover all available RAM, meaning the last few megs (or even gigs)
> > of memory will be marked uncached.  Since Linux tends to allocate
> > from high memory addresses first, this causes the machine to be
> > unusably slow as soon as the kernel starts really using memory
> > (i.e. right around init time).
> >
> > +	if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
> > +		printk(KERN_WARNING "***************\n");
> > +		printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
> > +		printk(KERN_WARNING "**** MTRRs don't cover all of "
> > +		       "memory, trimmed %ld pages\n", end_pfn -
> > +		       (highest_addr >> PAGE_SHIFT));
> > +		printk(KERN_WARNING "***************\n");
> > +		end_pfn = highest_addr >> PAGE_SHIFT;
>
> Missing 4K of memory is not worth 4K of junk in syslog per boot. Can
> you drop the stars and stop shouting?

How missing about 1G of memory?  We already discussed this, and Andi and 
Venki felt that either a panic or a really obnoxious message was the 
way to go...

Jesse
