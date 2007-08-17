Return-Path: <linux-kernel-owner+w=401wt.eu-S1765111AbXHQShS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765111AbXHQShS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 14:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758142AbXHQShE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 14:37:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52722 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbXHQShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 14:37:02 -0400
Date: Fri, 17 Aug 2007 20:37:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Satyam Sharma <satyam@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: kfree(0) - ok?
In-Reply-To: <20070817112253.e6a7cb33.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708172036151.30502@fbirervta.pbzchgretzou.qr>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
 <20070817112253.e6a7cb33.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 17 2007 11:22, Andrew Morton wrote:

>Which is getting pretty idiotic:
>
>akpm:/usr/src/25> grep ZERO_OR_NULL_PTR */*.c
>mm/slab.c:              BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
>mm/slab.c:      if (unlikely(ZERO_OR_NULL_PTR(cachep)))
>mm/slab.c:      if (unlikely(ZERO_OR_NULL_PTR(cachep)))
>mm/slab.c:      if (unlikely(ZERO_OR_NULL_PTR(objp)))
>mm/slab.c:      if (unlikely(ZERO_OR_NULL_PTR(objp)))
>mm/slob.c:      if (unlikely(ZERO_OR_NULL_PTR(block)))
>mm/slob.c:      if (unlikely(ZERO_OR_NULL_PTR(block)))
>mm/slob.c:      if (unlikely(ZERO_OR_NULL_PTR(block)))
>mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(s)))
>mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(s)))
>mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(object)))
>mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(x)))
>mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(s)))
>mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(s)))
>
>are we seeing a pattern here?  We could stick the unlikely inside
>ZERO_OR_NULL_PTR() itself.

Yeah,

	BUG_ON(unlikely(ZERO_OR_NULL_PTR(..)))

that will really help the bug - "hm, it's Friday, let's BUG" ;-)



	Jan
-- 
