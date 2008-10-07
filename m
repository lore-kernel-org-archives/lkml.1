Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbYJGQkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbYJGQkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYJGQju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:39:50 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:24559 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753237AbYJGQjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:39:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=o2qxlVAkvckzq16CJUT/kfAr6eLTFM4FHAwS0RRMWn8GSVuXaIiiw0LnXl2L0W+QBkeHUG48qNIvy2HVOuIqcbUFrnIpdr0C+AhziLW44TWbkp/Saj6LhpU+dt1q1lV7TkLx3vAbZAugAwp8cXjg5GPIl6hwXRzBwrJ04Fiz/h0=  ;
X-YMail-OSG: c18cuVUVM1l.KPIJe4vUtL1nOPMUt9Y20O1Kca20Eeradh2WtJIhYp9yVqmoBLvzNvEByCdBv6S5XyKl9ErelpYrBWr_RkkSBww2k5dP.n9mXIqFB8kCkWaSU24N8V0AeUeVasF8t.tPOrgl_95oXDAb2UaWQA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [patch][rfc] ddds: "dynamic dynamic data structure" algorithm, for adaptive dcache hash table sizing (resend)
Date: Wed, 8 Oct 2008 03:39:39 +1100
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       netdev@vger.kernel.org, Paul McKenney <paulmck@us.ibm.com>
References: <20081007064834.GA5959@wotan.suse.de> <20081007071827.GB5010@infradead.org> <18667.33351.854693.368568@harpo.it.uu.se>
In-Reply-To: <18667.33351.854693.368568@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080339.40300.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 02:37, Mikael Pettersson wrote:

> I missed the first post, but loooking at the patch it seems
> somewhat complex.

It is complex, but relatively self-contained, ie. it doesn't affect
the actual code that performs hash lookups very much (although there
can be some impact on atomicity if we have to consider something like
a full table traversal like the rt hash).


> How does this relate to traditional incremental hash tables
> like extensible hashing or linear hashing (not to be confused
> with linear probing)? In linear hashing a resize only affects
> a single collision chain at a time, and reads from other chains
> than the one being resized are unaffected.

I haven't actually seen any real implementations of those things.
AFAICS they don't exactly deal with concurrency. They are also likely
to be more costly to operate on, versus a well sized simple hash
table.
