Return-Path: <linux-kernel-owner+w=401wt.eu-S937819AbXLTPsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937819AbXLTPsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965606AbXLTPeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:34:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965599AbXLTPeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:34:03 -0500
Date: Thu, 20 Dec 2007 10:33:32 -0500
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [patch 17/20] non-reclaimable mlocked pages
Message-ID: <20071220103332.11c4bbd2@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0712192317420.13118@schroedinger.engr.sgi.com>
References: <20071218211539.250334036@redhat.com>
	<20071218211550.186819416@redhat.com>
	<200712191156.48507.nickpiggin@yahoo.com.au>
	<Pine.LNX.4.64.0712192317420.13118@schroedinger.engr.sgi.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 23:19:00 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 19 Dec 2007, Nick Piggin wrote:
> 
> > These mlocked pages don't need to be on a non-reclaimable list,
> > because we can find them again via the ptes when they become
> > unlocked, and there is no point background scanning them, because
> > they're always going to be locked while they're mlocked.
> 
> But there is something to be said for having a consistent scheme. 

The code as called from .c files should indeed be consistent.

However, since we never need to scan the non-reclaimable list,
we could use the inline functions in the .h files to have an
mlock count instead of a .lru list head in the non-reclaimable
pages.

At least, I think so.  I'm going to have to think about the
details a lot more.  I have no idea yet if there will be any
impact from batching the pages on pagevecs, vs. an atomic
mlock count...
