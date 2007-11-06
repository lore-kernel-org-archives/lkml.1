Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbXKFU0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbXKFU0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbXKFU0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 15:26:09 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:13966 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbXKFU0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 15:26:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QRbL0zT95BKKQ+R/H0hZFxCjLgIYnr0gnPQaQ3b0R5Py/dP7MltHWw118p4ZP2lls6Em6I34ZooZDS6VGmuPG+n8+r+Y1lnl53ncf0FZorpLCHGSJBxP+KoDzH3VqV7FjhB9n2nBppye+f2yZgLDHHLdT7xiMENqLPpeLDHRydM=
Message-ID: <64bb37e0711061226l48dce395ub2f9539efc66ecc0@mail.gmail.com>
Date: Tue, 6 Nov 2007 21:26:05 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: writeout stalls in current -git
Cc: "David Chinner" <dgc@sgi.com>, "Fengguang Wu" <wfg@mail.ustc.edu.cn>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
In-Reply-To: <1194375682.6289.88.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <393903856.06449@ustc.edu.cn> <E1InmAI-0003ME-2i@localhost>
	 <1193998532.27652.343.camel@twins>
	 <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
	 <20071102204258.GR995458@sgi.com>
	 <64bb37e0711040319l5de285c3xea64474540a51b6e@mail.gmail.com>
	 <20071105014510.GU66820511@sgi.com>
	 <64bb37e0711051027v49869699s9593ea54713b15ff@mail.gmail.com>
	 <20071106042527.GT995458@sgi.com> <1194375682.6289.88.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2007-11-06 at 15:25 +1100, David Chinner wrote:
>
> > I'm struggling to understand what possible changed in XFS or writeback that
> > would lead to stalls like this, esp. as you appear to be removing files when
> > the stalls occur.
>
> Just a crazy idea,..
>
> Could there be a set_page_dirty() that doesn't have
> balance_dirty_pages() call near? For example modifying meta data in
> unlink?
>
> Such a situation could lead to an excess of dirty pages and the next
> call to balance_dirty_pages() would appear to stall, as it would
> desperately try to get below the limit again.

Only if accounting of the dirty pages is also broken.
In the unmerge testcase I see most of the time only <200kb of dirty
data in /proc/meminfo.

The system has 4Gb of RAM so I'm not sure if it should ever be valid
to stall even the emerge/install testcase.

Torsten

Now building a kernel with the skipped-pages-accounting-patch reverted...
