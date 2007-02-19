Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbXBSOzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbXBSOzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbXBSOzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:55:55 -0500
Received: from smtp.nokia.com ([131.228.20.173]:55471 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbXBSOzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:55:54 -0500
Subject: Re: [PATCH 16/44 take 2] [UBI] scanning unit implementation
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <20070219110543.GE16930@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165545.5845.27214.sendpatchset@localhost.localdomain>
	 <20070219110543.GE16930@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Feb 2007 16:11:14 +0200
Message-Id: <1171894274.14817.9.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Feb 2007 14:11:14.0179 (UTC) FILETIME=[D082FD30:01C7542F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 11:05 +0000, Christoph Hellwig wrote:
> > +	cond_resched();
> > +	list_for_each_entry(seb, &si->erase, u.list)
> > +		if (seb->ec == NAND_SCAN_UNKNOWN_EC)
> > +			seb->ec = si->mean_ec;
> 
> You really shouldn't need random cond_resched all over the place.

Good point. I will review the code and clean up stuff like this.

While we are on the point, could you please formulate your criteria of
when cond_resched() should be used.

> > +static int compare_lebs(const struct ubi_info *ubi,
> > +			const struct ubi_scan_leb *seb, int pnum,
> > +			const struct ubi_vid_hdr *vid_hdr);
> 
> forward declarations in the middle of the file are really annoying.  Please try
> to reorder the code to not need them at all if needed, and if needed add them
> to the top of the file.

I tried to layout the code like: top level functions first, low level
last. This is matter of taste, isn't it? I am reluctant to change this,
because it is big useless work (I'll need to change it everywhere in
UBI). But will do this with great delight if it annoys too many people
(you are the second so far).

> > +	list_for_each_entry_safe(seb, seb_tmp, &si->alien, u.list) {
> > +		list_del(&seb->u.list);
> > +		ubi_free_scan_leb(seb);
> > +	}
> 
> no locking needed here?

No, initialization stage does not need any locking.


Thanks,
Artem.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

