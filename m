Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbZFWMew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbZFWMew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZFWMep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:34:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:44121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbZFWMep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:34:45 -0400
Subject: Re: [PATCH] radeon: use vmalloc instead of kmalloc
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Jerome Glisse <jglisse@redhat.com>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970906230442n3dcfeff8le0ffc3b8ea0c3bd0@mail.gmail.com>
References: <1245691561-15336-1-git-send-email-jglisse@redhat.com>
	 <1245756936.19816.1652.camel@twins>
	 <21d7e9970906230442n3dcfeff8le0ffc3b8ea0c3bd0@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Jun 2009 14:34:54 +0200
Message-Id: <1245760494.19816.1726.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 21:42 +1000, Dave Airlie wrote:
> On Tue, Jun 23, 2009 at 9:35 PM, Peter Zijlstra<peterz@infradead.org> wrote:
> > On Mon, 2009-06-22 at 19:26 +0200, Jerome Glisse wrote:
> >> We don't need to allocated contiguous pages in cs codepath
> >> so use vmalloc instead.
> >
> > Best would be to not require >PAGE_SIZE allocations at all of course.
> 
> It gets messy when you have copy from user and spinlocks, it would be nice
> to just parse the userspace PAGE_SIZE at a time, but it would mean dropping
> a lock we probably need to hold.

Can't you play tricks with refcounts?
