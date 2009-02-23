Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZBWOCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZBWOCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbZBWOCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:02:07 -0500
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:28159 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754548AbZBWOCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:02:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=n9ShBdOOJivp/0TZioosNN+9Cv4ijnrmanmp7n0ifLkx44OIyif2HAlVhvcnEZXQXsjnw8Xd5PkkukvoZUH0AYBnAt0qtb3gLxNEJ6k2+eWaWEk9AT6JO9B9YOYcvW50jZxQThEZUAUa6azb7xbnrI4C8MMcvEdk8RwNueUgZc0=  ;
X-YMail-OSG: z65fW9IVM1nJHDx8BR1KR1iUNx6mZmOOWgaHlDjVujrEcD9A6tWYDNrIJRvMXFxJIs8o7QMhrqMR2MfLqkhAyIKWRLU7E2C4xOLMTTFIcredQfIR0qaUiz6Vrkyg_PfqTv1_vERq_SOJWjYZYvmFkVXj3cpUSCBhYoDEDCEotFtBvkPPb2ZJM8l44V_erw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/7] slab: introduce kzfree()
Date: Tue, 24 Feb 2009 01:01:24 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Vrabel <david.vrabel@csr.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
References: <499BE7F8.80901@csr.com> <499DB6EC.3020904@cs.helsinki.fi> <Pine.LNX.4.64.0902192022210.8254@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902192022210.8254@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240101.26362.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009 07:36:48 Hugh Dickins wrote:
> On Thu, 19 Feb 2009, Pekka Enberg wrote:

> > Quite frankly, I fail to see how kzfree() is fundamentally different from
> > kfree(). I don't see kzfree() as a memset() + kfree() but rather as a
> > kfree() "and make sure no one sees my data". So the zeroing happens
> > _after_ you've invalidated the pointer with kzfree() so there's no
> > "zeroing of buffer going on".
>
> Well, that would be one way of picturing it, yes.
> Imagine the "z" as for "zap" rather than "zero",
> and the mechanism as opaque as Hannes suggests.
>
> > So the way I see it, Linus' argument for having const for kfree() applies
> > to kzfree().
> >
> > That said, if you guys think it's a merge blocker, by all means remove
> > the const. I just want few less open-coded ksize() users, that's all.
>
> I wouldn't call it a merge blocker, no; though I still
> think it makes far more sense without the "const" there.

Well, the buffer is only non-modified in the case of one of the
allocators (SLAB). All others overwrite some of the data region
with their own metadata.

I think it is OK to use const, though. Because k(z)free has the
knowledge that the data will not be touched by the caller any
longer.

