Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZG2O6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZG2O6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZG2O6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:58:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49316 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZG2O6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:58:42 -0400
Date: Wed, 29 Jul 2009 15:58:39 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Moussa Ba <moussa.a.ba@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rientjes@google.com, xiyou.wangcong@gmail.com, adobriyan@gmail.com,
       mpm@selenic.com, yinghan@google.com, npiggin@suse.de, jaredeh@gmail.com
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or
	mapped vma clearing
Message-ID: <20090729145839.GB15102@csn.ul.ie>
References: <alpine.DEB.2.00.0907271339070.17425@chino.kir.corp.google.com> <7928e7bd0907271514y699d1de4j54f9c562b94ef0cc@mail.gmail.com> <alpine.DEB.2.00.0907271543420.23587@chino.kir.corp.google.com> <7928e7bd0907271638x5ddbfd2ckba2802338a33765a@mail.gmail.com> <alpine.DEB.2.00.0907271657160.27881@chino.kir.corp.google.com> <4A6F2AF4.6050505@gmail.com> <alpine.DEB.2.00.0907281401150.7140@chino.kir.corp.google.com> <4A6F8115.7000500@gmail.com> <20090728165245.65d5cb23.akpm@linux-foundation.org> <7928e7bd0907281700s13d9937yc3b2933b13cfae9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7928e7bd0907281700s13d9937yc3b2933b13cfae9f@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 05:00:54PM -0700, Moussa Ba wrote:
> The patch makes the clear_refs more versatile in adding the option to
> select anonymous pages or file backed pages for clearing.  This
> addition has a measurable impact on user space application performance
> as it decreases the number of pagewalks in scenarios where one is only
> interested in a specific type of page (anonymous or file mapped).
> 

I think what Andrew might be looking for is a repeat of the use-case for
using clear_refs at all and what the additional usecase is that makes this
patch beneficial. To be honest, I had to go digging for a bit to find out
why clear_refs is used at all and the potential benefits of this patch were
initially unclear to me although they were obvious to others. I confess I
haven't read the patch closely to determine if it's behaving as advertised
or not.

Bonus points for a wee illustration of a script that measures the apparent
working set of a process using clear_refs, showing the working set for anon
vs filebacked and the difference of measuring just anon versus the full
process for example. Such a script could be added to Documentation/vm as
I didn't spot any example in there already.

Total aside, is there potential to really mess with LRU aging by abusing
clear_refs a lot, partcularly as clear_refs is writable by the process
owner? Does it matter?

> 
> On Tue, Jul 28, 2009 at 4:52 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> > On Tue, 28 Jul 2009 15:52:05 -0700
> > "Moussa A. Ba" <moussa.a.ba@gmail.com> wrote:
> >
> >> This patch adds anonymous and file backed filters to the clear_refs interface.
> >> echo 1 > /proc/PID/clear_refs resets the bits on all pages
> >> echo 2 > /proc/PID/clear_refs resets the bits on anonymous pages only
> >> echo 3 > /proc/PID/clear_refs resets the bits on file backed pages only
> >> Any other value is ignored
> >
> > The changelog is missing any rationale for making this change.
> > Originally we were told that it "makes the clear_refs proc interface a
> > bit more versatile", but that's a bit thin.
> >
> > How do we justify making this change to Linux?  What value does it
> > have?  Can you describe a usage scenario which would help people
> > understand the usefulness of the change?
> >
> > Thanks.
> >
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
