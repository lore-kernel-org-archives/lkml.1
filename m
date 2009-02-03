Return-Path: <linux-kernel-owner+w=401wt.eu-S1752417AbZBCByJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbZBCByJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZBCBx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:53:56 -0500
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:21734 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750799AbZBCBxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:53:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Cbq3GtIBV/i5Gan7hIQU4BdE1MvRusGO2yosV429TJzuXnxL3oXaveZmIMKo27Z7+z6OZXoeugDdhTNb22lE3W2UV4p+RlZJTL5cTe8cnjoz5MpZ11F8tsl/mBNkYYaoJ4mLok1Si4tuninPTD2l1E7Am+SpTZ8GOGPoUuUkq80=  ;
X-YMail-OSG: Pnw1L2QVM1kxKBBCKcxTzvo68bgttLWao_sLldSl3qpI5INQbOiACKvXkNLz.9R.yAQ4KKsDS4HZjMjgnXOSKLdKb0hcejHE60TXvpqhg6osT_QaC7lYvkzbzO0V7EXz0i4S4UeyrxeUpcHTtlw3GMHMLpNGSYWMNeXxnF2yt3T_Cgvs.oANaOmcPKYJuw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
Date: Tue, 3 Feb 2009 12:53:26 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20090114155923.GC1616@wotan.suse.de> <20090123155307.GB14517@wotan.suse.de> <alpine.DEB.1.10.0901261225240.1908@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0901261225240.1908@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031253.28078.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009 04:28:03 Christoph Lameter wrote:
> n Fri, 23 Jan 2009, Nick Piggin wrote:
> > According to memory policies, a task's memory policy is supposed to
> > apply to its slab allocations too.
>
> It does apply to slab allocations. The question is whether it has to apply
> to every object allocation or to every page allocation of the slab
> allocators.

Quite obviously it should. Behaviour of a slab allocation on behalf of
some task constrained within a given node should not depend on the task
which has previously run on this CPU and made some allocations. Surely
you can see this behaviour is not nice.


> > > Memory policies are applied in a fuzzy way anyways. A context switch
> > > can result in page allocation action that changes the expected
> > > interleave pattern. Page populations in an address space depend on the
> > > task policy. So the exact policy applied to a page depends on the task.
> > > This isnt an exact thing.
> >
> > There are other memory policies than just interleave though.
>
> Which have similar issues since memory policy application is depending on
> a task policy and on memory migration that has been applied to an address
> range.

What similar issues? If a task ask to have slab allocations constrained
to node 0, then SLUB hands out objects from other nodes, then that's bad.


> > But that is wrong. The lists obviously have high water marks that
> > get trimmed down. Periodic trimming as I keep saying basically is
> > alrady so infrequent that it is irrelevant (millions of objects
> > per cpu can be allocated anyway between existing trimming interval)
>
> Trimming through water marks and allocating memory from the page allocator
> is going to be very frequent if you continually allocate on one processor
> and free on another.

Um yes, that's the point. But you previously claimed that it would just
grow unconstrained. Which is obviously wrong. So I don't understand what
your point is.

