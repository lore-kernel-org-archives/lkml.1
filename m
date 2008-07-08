Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbYGHCQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbYGHCQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 22:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbYGHCQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 22:16:45 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:24256 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754691AbYGHCQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 22:16:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pThobvq4nk10VO16IJJ+Lerk02T4BlKIqMg+qCWH7pNsFbCEy5ZIP098MrLkyyTYecBET/9fpTrZaIHJYBEm9GLSJfhW30huARujC0PNCruIKBH4Ux/al47tOXOTP33A7KsLRgs2S81aX0y23WiX3OhwCJmZbKQXzDlHX4pZhfo=  ;
X-YMail-OSG: SyT83yUVM1mCsTDC4tSPqav6tR526gyYEeaHQS8qXdtT.tQoQjccRUmokQzo7Ci1CR_w966NDrL1ozUUds3oCVYmDf2tPsiFJ0u87mpoQQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jack Steiner <steiner@sgi.com>
Subject: Re: [patch 12/13] GRU Driver V3 -  export is_uv_system(), zap_page_range() & follow_page()
Date: Tue, 8 Jul 2008 12:16:21 +1000
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>, Christoph Hellwig <hch@infradead.org>,
       cl@linux-foundation.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com,
       linux-mm@kvack.org
References: <20080703213348.489120321@attica.americas.sgi.com> <Pine.LNX.4.64.0807071657450.17825@blonde.site> <20080707165358.GA16420@sgi.com>
In-Reply-To: <20080707165358.GA16420@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081216.22029.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 02:53, Jack Steiner wrote:
> On Mon, Jul 07, 2008 at 05:29:54PM +0100, Hugh Dickins wrote:

> > Maybe study the assumptions Nick is making in his arch/x86/mm/gup.c
> > in mm, and do something similar in your GRU driver (falling back to
> > the slow method when anything's not quite right).  It's not nice to
> > have such code out in a driver, but GRU is going to be exceptional,
> > and it may be better to have it out there than pretence of generality
> > in the core mm exporting it.
>
> Ok, I'll take this approach. Open code a pagetable walker into the GRU
> driver using the ideas of fast_gup(). This has the added benefit of being
> able to optimize for exactly what is needed for the GRU. For example,
> nr_pages is always 1 (at least in the current design).

Well... err, it's pretty tied to the arch and mm design. I'd rather
if you could just make another entry point to gup.c (perhaps, one
which doesn't automatically fall back to the get_user_pages slowpath
for you) rather than code it again in your driver.
