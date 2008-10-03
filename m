Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbYJCClq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbYJCClq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 22:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYJCClg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 22:41:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014AbYJCClf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 22:41:35 -0400
Date: Thu, 2 Oct 2008 19:40:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
Subject: Re: [PATCH] Memory management livelock
Message-Id: <20081002194034.7957bccb.akpm@linux-foundation.org>
In-Reply-To: <200810031232.23836.nickpiggin@yahoo.com.au>
References: <20080911101616.GA24064@agk.fab.redhat.com>
	<Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
	<20080923154905.50d4b0fa.akpm@linux-foundation.org>
	<200810031232.23836.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008 12:32:23 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > yup, that's pretty much unfixable, really, unless new locks are added
> > which block threads which are writing to unrelated sections of the
> > file, and that could hurt some workloads quite a lot, I expect.
> 
> Why is it unfixable? Just ignore nr_to_write, and write out everything
> properly, I would have thought.

That can cause fsync to wait arbitrarily long if some other process is
writing the file.  This happens.
