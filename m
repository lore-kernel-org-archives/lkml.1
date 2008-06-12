Return-Path: <linux-kernel-owner+w=401wt.eu-S1759164AbYFLTIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164AbYFLTIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbYFLTI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:08:29 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:35006 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752894AbYFLTI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:08:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=q/aOBqheAWa4tL/vSs7M9bEDF6vVsygcwlOH9yiX4VfQu1ll7LIIx6R9ST8eufuWE9YqAd7CiYeqfgn85SB98tOdwZqygqeo0ieRFM9r+ON3cVpKwi2XqjFL0EJZpbnLWCNzRqWvyaJ41Zy5rma+GW7pprFY9t2/NqKvFpyJMoo=  ;
X-YMail-OSG: Eao5doEVM1nkknR9yIVb2l6j1kvdnaJrnO_Q9RVaC6VQJTNp1uODq4Dp1ElIyZaSn9VAQFefPMI7THYs3Pw42jn9OSA0KQuYFmPE89EhiiM4gEEjvvmk15faVhiIs88lxPE-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH] undo the brd.c part of ramfs-and-ram-disk-pages-are-unevictable.patch
Date: Fri, 13 Jun 2008 05:08:19 +1000
User-Agent: KMail/1.9.5
Cc: Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20080612135353.2d17436a@cuia.bos.redhat.com> <1213297257.6240.15.camel@lts-notebook>
In-Reply-To: <1213297257.6240.15.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806130508.19661.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2008 05:00, Lee Schermerhorn wrote:
> On Thu, 2008-06-12 at 13:53 -0400, Rik van Riel wrote:
> > Undo the brd.c part of ramfs-and-ram-disk-pages-are-unevictable.patch.
> > The brd pages do not live on the LRU at all, so there is no need to
> > play these tricks.
>
> Does this mean that these pages cannot be migrated?  E.g., to evacuate
> memory for hotplug?  Looks like all paths to migrate_pages() construct a
> list of pages to migrate by isolating them from the lru
> [isolate_lru_page()].  Any pages not found in the lru are skipped.

Yes. They have nothing to do with user pages or pagecache pages at all
really. brd is now a properly layered block device driver that does not
know anything about buffer cache ;)

You can think of the pages it allocates as completely private, and they
are used to implement the backing store for the block device.

The vm/fs layers will instantiate buffer cache over this device, which
is reclaimable.
