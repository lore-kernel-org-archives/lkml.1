Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbZAWQR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbZAWQR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 11:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbZAWQRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 11:17:50 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:25020 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756663AbZAWQRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 11:17:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=f1tBxkeyb94mmTdAv35wfvYlgBislSW4nrOvuQzXd1VpZjOecMSoDy+m5Jdrh6YlqFG0zukTrEUQAy55xV++a3v4pKg4zZVf96gBTu4o3rc6ZHp6/CkFEREAZjuoW/OufXFE6ndV5urZpg7lcL6Uu7ykiqi+v5+PSUSYbW/12I0=  ;
X-YMail-OSG: e0GncX8VM1l_6yBRSCaXiY3uQ35eF_rbgsuL8e9XljgaIw.M5pkCLH1CYdkuHRNGups9jU8idcOe7hbK1Q7BSbGHTFDc8L1PwAgBm1NZgYzmlBtrq0wXnUwN5ZrPhZEGQZqLlq4R9OjOxnBqwrwHAS36zf8Cms4urYooQhngxb8lFEe9F3_eaIT3.mHFsA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
Date: Sat, 24 Jan 2009 03:17:25 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI> <200901240241.06670.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0901231057280.32253@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0901231057280.32253@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901240317.26227.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2009 02:59:17 Christoph Lameter wrote:
> On Sat, 24 Jan 2009, Nick Piggin wrote:
> > Page allocator is never going to be as fast as slab allocator, for
> > issues I explained a long time ago. Not to say it can't be improved,
> > just stating facts.
>
> Why not? Remember the discussion we had a while ago. You can bring the
> pages into a state where minimal manipulations are required for alloc free
> and avoid all the checks in the hot paths. The SLUB method could be used
> taking a big contiguous chunk and then issueing page size portions of it.
> That could be quite fast.
>
> Or if you prefer order-0. Do a single linked list like SLQB does.

The fundamental issues I guess are that slab pages are kernel mapped, and
within a given slab, the zone and movability are irrelevant.

Other ones which could be changed but could introduce regressions are
watermarks, buddy merging, and struct page error checking and setup.

I brought all this up when it was discussed. Did you find any ways to
improve anything?

(I did make that patch to enable refcounting to be avoided FWIW, which
avoids a couple of atomic operations, but I don't think it brought
performance up too much, but I still intend to dust it off at some
point).

