Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYJCE33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYJCE33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 00:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYJCE3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 00:29:20 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:21736 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750936AbYJCE3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 00:29:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=A0Oe4P/03Qgq/fzdMIk+Mf8P3j53M4ymSr8FqPeAl5qtTWc7eO44XPzrHN1H9AXl3LZrbZwU+J3w+TLZnZgOQIfnLcV/MuEuA62chC3pebdVLNmJhfB9tDLUkCo7HvsFOJDNBGyVa8YnFel18y5nD2+ioJRq+Ofi+uQvrbZDJpk=  ;
X-YMail-OSG: tmoZvUQVM1m9lPb4fQlaDHLdaxxHNz.cbqwu74.Ml67Ivp8.OUO7alkGPYpN.KEmjK7jbHydFSCGI9705WrHPYOWuY2oGEzapJB0rvv6CHNeIaIrMI4ZHHh70F.WarzrD4elsISNFQ.d8YSZ7iKgF7cfstaf9CJ9Rq1rt4F5Db2r3RVeyNM-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Memory management livelock
Date: Fri, 3 Oct 2008 14:29:09 +1000
User-Agent: KMail/1.9.5
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
References: <20080911101616.GA24064@agk.fab.redhat.com> <200810031407.55406.nickpiggin@yahoo.com.au> <20081002211752.68994206.akpm@linux-foundation.org>
In-Reply-To: <20081002211752.68994206.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031429.10040.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008 14:17, Andrew Morton wrote:
> On Fri, 3 Oct 2008 14:07:55 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
> > Possibly a new mutex in the address_space?
>
> That's another, umm 24 bytes minimum in the address_space (and inode).
> That's fairly ouch, which is why Miklaus did that hokey bit-based
> thing.

Well yeah, it would be a bit based mutex in mapping->flags with
hashed waitqueues. Like Miklaus's.


> > Yeah... I went to break the sync/async cases into two, but it looks like
> > it may not have been worthwhile. Just another branch might be the best
> > way to go.
>
> Yup.  Could add another do-this flag in the writeback_control, perhaps.
> Or even a function pointer.

Yeah... possibly we could just _always_ do the PAGECACHE_TAG_FSYNC thing
if mode != WB_SYNC_NONE. I think if we had the infrastructure there to
do it all, it should always be something we want to do for data integrity
writeout.
