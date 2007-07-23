Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbXGWV5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbXGWV5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbXGWV53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:57:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51601 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbXGWV51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:57:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: [RFC] [PATCH 0/5] Dynamically allocated pageflags.
Date: Tue, 24 Jul 2007 00:05:21 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200707232305.12364.nigel@nigel.suspend2.net>
In-Reply-To: <200707232305.12364.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707240005.22163.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, 23 July 2007 15:05, Nigel Cunningham wrote:
> Hi all.
> 
> As we all know, pageflags have been a scarce resource for a while now. These 
> patches seek to help address that issue by adding support for a new type 
> of 'dynamically allocated' pageflag.
> 
> The basic idea is that we use per node & zone bitmaps built out of order zero 
> allocations, to replace bits in page->flags. Bitmaps can be sparse, being 
> populated when a bit on the page is set, and returning zero for all bits in 
> sparse pages. Untested hotplug support is included.
> 
> This method of storing the data does of course come with a performance hit. 
> I've included some simple timing loops in #ifdef'd code that help quantify 
> that.
> 
> Interestingly, the new implementation is actually quicker under some 
> circumstances. In cases where the usage pattern involves operating on the 
> flags for a number of pages in succession, the hit involved in getting the 
> struct pages from main memory appears to be greater than that involved in 
> calculating which unsigned long and bit to test.
> 
> Tested only on UP (x86_64) so far.

How does it compare to the memory bitmaps used by swsusp, defined in
kernel/power/snapshot.c?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
