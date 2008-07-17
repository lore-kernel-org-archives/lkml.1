Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbYGQOUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbYGQOUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbYGQOUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:20:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640AbYGQOUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:20:35 -0400
Date: Thu, 17 Jul 2008 10:20:25 -0400
From: Rik van Riel <riel@redhat.com>
To: Chris Snook <csnook@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Eric Rannaud <eric.rannaud@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Subject: Re: madvise(2) MADV_SEQUENTIAL behavior
Message-ID: <20080717102025.6b7f0e40@cuia.bos.redhat.com>
In-Reply-To: <487E628A.3050207@redhat.com>
References: <1216163022.3443.156.camel@zenigma>
	<1216210495.5232.47.camel@twins>
	<20080716105025.2daf5db2@cuia.bos.redhat.com>
	<487E628A.3050207@redhat.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008 17:05:14 -0400
Chris Snook <csnook@redhat.com> wrote:

> > I believe that for mmap MADV_SEQUENTIAL, we will have to do
> > an unmap-behind from the fault path.  Not every time, but
> > maybe once per megabyte, unmapping the megabyte behind us.
> > 
> > That way the normal page cache policies (use once, etc) can
> > take care of page eviction, which should help if the file
> > is also in use by another process.
> 
> Wouldn't it just be easier to not move pages to the active list when 
> they're referenced via an MADV_SEQUENTIAL mapping?  

You want to check the MADV_SEQUENTIAL hint at pageout time and
discard the referenced bit from the pte?

> If we keep them on the inactive list, they'll be candidates for
> reclaiming

Only if we ignore the referenced bit.  Which I guess we can do.

-- 
All Rights Reversed
