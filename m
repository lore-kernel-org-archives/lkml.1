Return-Path: <linux-kernel-owner+w=401wt.eu-S932686AbXBSVPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbXBSVPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932696AbXBSVPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:15:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49123 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686AbXBSVPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:15:40 -0500
Subject: Re: [PATCH 0/7] [RFC] hugetlb: pagetable_operations API
From: Arjan van de Ven <arjan@infradead.org>
To: Adam Litke <agl@us.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1171913691.22940.30.camel@localhost.localdomain>
References: <20070219183123.27318.27319.stgit@localhost.localdomain>
	 <1171910581.3531.89.camel@laptopd505.fenrus.org>
	 <1171913691.22940.30.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 19 Feb 2007 22:15:35 +0100
Message-Id: <1171919736.3531.98.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 13:34 -0600, Adam Litke wrote:
> On Mon, 2007-02-19 at 19:43 +0100, Arjan van de Ven wrote:
> > On Mon, 2007-02-19 at 10:31 -0800, Adam Litke wrote:
> > > The page tables for hugetlb mappings are handled differently than page tables
> > > for normal pages.  Rather than integrating multiple page size support into the
> > > main VM (which would tremendously complicate the code) some hooks were created.
> > > This allows hugetlb special cases to be handled "out of line" by a separate
> > > interface.
> > 
> > ok it makes sense to clean this up.. what I don't like is that there
> > STILL are all the double cases... for this to work and be worth it both
> > the common case and the hugetlb case should be using the ops structure
> > always! Anything else and you're just replacing bad code with bad
> > code ;(
> 
> Hmm.  Do you think everyone would support an extra pointer indirection
> for every handle_pte_fault() call?  

maybe. I'm not entirely convinced... (I like the cleanup potential a lot
code wise.. but if it costs performance, then... well I'd hate to see
linux get slower for hugetlbfs)

> If not, then I definitely wouldn't
> mind creating a default_pagetable_ops and calling into that.

... but without it to be honest, your patch adds nothing real.. there's
ONE user of your code, and there's no real cleanup unless you get rid of
all the special casing.... since the special casing is the really ugly
part of hugetlbfs, not the actual code inside the special case..


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

