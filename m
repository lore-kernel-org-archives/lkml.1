Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYFLT3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYFLT3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbYFLT3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:29:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbYFLT3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:29:15 -0400
Date: Thu, 12 Jun 2008 15:29:05 -0400
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.26-rc5-mm2
Message-ID: <20080612152905.6cb294ae@cuia.bos.redhat.com>
In-Reply-To: <200806120958.38545.nickpiggin@yahoo.com.au>
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
	<200806101848.22237.nickpiggin@yahoo.com.au>
	<20080611140902.544e59ec@bree.surriel.com>
	<200806120958.38545.nickpiggin@yahoo.com.au>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 09:58:38 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > Does loopback over tmpfs use a different allocation path?
> 
> I'm sorry, hmm I didn't look closely enough and forgot that
> write_begin/write_end requires the callee to allocate the page
> as well, and that Hugh had nicely unified most of that.
> 
> So maybe it's not that. It's pretty easy to hit I found with
> ext2 mounted over loopback on a tmpfs file.

Turns out the loopback driver uses splice, which moves
the pages from one place to another.  This is why you
were seeing the problem with loopback, but not with
just a really big file on tmpfs.

I'm trying to make sense of all the splice code now
and will send fix as soon as I know how to fix this
problem in a nice way.

-- 
All Rights Reversed
