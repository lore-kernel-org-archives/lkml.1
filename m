Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbXFVJWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbXFVJWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 05:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXFVJWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 05:22:31 -0400
Received: from bay0-omc2-s11.bay0.hotmail.com ([65.54.246.147]:2341 "EHLO
	bay0-omc2-s11.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbXFVJWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 05:22:30 -0400
Message-ID: <BAY103-DAV5C915E9475BFB6180B585B2170@phx.gbl>
X-Originating-IP: [85.36.106.198]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>, <linux-kernel@vger.kernel.org>,
       "David Chinner" <dgc@sgi.com>, <xfs@oss.sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV717DD455F57B3BB064E3CB2100@phx.gbl> <Pine.LNX.4.64.0706211121520.7711@schroedinger.engr.sgi.com>
Subject: Re: 2.6.21.3 Oops (was Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c. Caller 0xc01b00bd)
Date: Fri, 22 Jun 2007 11:22:09 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 22 Jun 2007 09:22:30.0396 (UTC) FILETIME=[DB8ABBC0:01C7B4AE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:

> On Thu, 21 Jun 2007, Marco Berizzi wrote:
>
> > > > Some RCU callback (that calls kmem_cache_free()) oopsed and
> > > > panic'ed his box. [ Marco had experienced fs issues lately, so
we
> > > could
> > > > suspect file_free_rcu() here, but I can't really tell from the
stack
> > > trace;
> > > > BTW whats with the rampant disease in the kernel to declare as
> > inline
> > > > even those functions exclusively meant to be dereferenced and
passed
> > > > as pointers to call_rcu()?! ]
>
>
> The BUG_ON that triggers this signals us that someone tried to perform
> a kfree or kmem_cache_free on an object that is not in a slab page.
>
>
> > Hello everybody.
> > Few minutes ago 2.6.22-rc5 has been
> > crashed with this error (see also the
> > bitmap at http://80.204.235.230/foto2.jpg).
> > Just for record: if I build linux
> > with 'Debug slab memory allocations'
> > the box doesn't crash.
>
> Hmmm.. That is strange and could point to some sort of race condition.
>
> 1. The object is freed. It is the last page on the slab. Thus slab
> decommissions the page and resets PageSlab.
>
> 2. Another process tries to free the object again. Now the page is no
> longer marked as being a SLAB page. Thus the BUG_ON is triggered.
>
> Can you try the same with SLUB? Boot with "slub_debug".

With the same kernel or should I compile with
some other options?

> If you cannot
> trigger the error anymore do limited debugging by booting with
> "slub_debug=F". Maybe that will be enough to trigger the race.



