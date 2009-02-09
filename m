Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZBIEDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZBIEDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 23:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZBIEDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 23:03:04 -0500
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:21103 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753863AbZBIEDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 23:03:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=x2rPfwHj5xljdAyimIAGhbY90XUR2X+IZiKUD7BDskUiQy8DzSeD+pjtAcqXfuqtu2AtpSZu1xM2MBAFZ7wiEtUc0cRNufxxpa8aa/dtnyfx76omoZk3+t6GlRVyAUKiWp5cxgRDyTqOnwYMQplnoJWJXKM6EsnzUqP9BCcgeZg=  ;
X-YMail-OSG: Igu0p9EVM1n1G2sXCN0LR0jdumFGBXl3D94wam4k4i3B5sb4pt0mTZbSHtR_OlV7oVgVhERPnnOWN8LZUb9O7C7MdeJrFzQBapYs8PO.mcyTf_gXsh8.5X85iakFkTZLNbUtxgG2T3W5Lh2lTj8jUUSe5IBNgYziGqXQkd6pa0j1IZTAvOJ4GQdSXHVe4bYqioR73WGrKzUfMdLTaTvhQ.h7uSjff3xlSw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Menage <menage@google.com>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the unallowed node when memory spread is set
Date: Mon, 9 Feb 2009 15:02:25 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: miaox@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, cl@linux-foundation.org
References: <4976D77C.3020107@cn.fujitsu.com> <4989606F.9030804@cn.fujitsu.com> <6599ad830902061119t2d82c782pb6442f9a35fbb01c@mail.gmail.com>
In-Reply-To: <6599ad830902061119t2d82c782pb6442f9a35fbb01c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902091502.27056.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 February 2009 06:19:27 Paul Menage wrote:
> On Wed, Feb 4, 2009 at 1:31 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> >> AFAICS this patch still has a race between a thread reading its
> >> mems_allowed, and another thread updating it. The current architecture
> >> of having task->mems_allowed be only updatable by current was PaulJ's
> >> code originally, and I'm a bit loathe to touch it. But if we're going
> >> to, we'll need at the minimum to add a lock for any code that touches
> >> current->mems_allowed.
> >
> > Agree! But mems_allowed is touched in the module of memory management
> > in general, adding a lock to protect mems_allowed may lead to performance
> > regression.
>
> I've asked Andrew to remove this from -mm until we can figure out:
>
> - whether it's needed
> - how to do it safely.

Is it a problem if mems_allowed can get sampled in an unsafe way?
It will happen only quite rarely. This code seems to be far simpler
and more robust than the current fragile scheme, so it would be
nice to use it.

