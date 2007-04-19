Return-Path: <linux-kernel-owner+w=401wt.eu-S1767023AbXDSUPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767023AbXDSUPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965044AbXDSUPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:15:02 -0400
Received: from waste.org ([66.93.16.53]:57243 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964935AbXDSUPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:15:00 -0400
Date: Thu, 19 Apr 2007 15:02:26 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] maps#2: Add /proc/kpagemap interface
Message-ID: <20070419200226.GG11115@waste.org>
References: <14.469046093@selenic.com> <1177009598.12599.152.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177009598.12599.152.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 12:06:38PM -0700, Dave Hansen wrote:
> On Fri, 2007-04-06 at 17:03 -0500, Matt Mackall wrote:
> > 
> > +static ssize_t kpagemap_read(struct file *file, char __user *buf,
> > +                            size_t count, loff_t *ppos)
> > +{
> ...
> > +               for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
> > +                       ppage = pfn_to_page(pfn);
> > +                       if (!ppage) {
> > +                               page[i] = 0;
> > +                               page[i + 1] = 0;
> > +                       } else {
> > +                               page[i] = ppage->flags;
> > +                               page[i + 1] = atomic_read(&ppage->_count);
> > +                       }
> > +               } 
> 
> I think this needs a pfn_valid() check for sparse/discontig systems.  I
> think we'll oops if we have holes because we don't check pfn_valid()
> inside of pfn_to_page().

Are there cases where pfn_valid is true but pfn_to_page doesn't work?
In other words, do I still only need two cases?

-- 
Mathematics is the supreme nostalgia of our time.
