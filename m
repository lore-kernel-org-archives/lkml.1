Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbYFJSSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbYFJSSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYFJSSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:18:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:18416 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbYFJSSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d9xxSlowrSwVawDvI7BjXuMeVlZgRFwagdg2/Nfr3GHX68WA5TU/5II/1A7LeCpQu4
         lXqqLkB9uPBs78SmsH7y8oCgiHE2okFCKN3AkOZFzSP5nZbKJM7RngBZd7OO4ffQIb8O
         unS/png1pIq7by+JgomzdxhouOneWiDy24gIs=
Message-ID: <19f34abd0806101118r5edbc065t8a19b69abf9aea5c@mail.gmail.com>
Date: Tue, 10 Jun 2008 20:18:20 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB, v2.
Cc: "Paul Mundt" <lethal@linux-sh.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "David Howells" <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       mpm@selenic.com
In-Reply-To: <Pine.LNX.4.64.0806101027220.17093@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080602072706.GB28268@linux-sh.org>
	 <Pine.LNX.4.64.0806101027220.17093@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/10/08, Christoph Lameter <clameter@sgi.com> wrote:
> On Mon, 2 Jun 2008, Paul Mundt wrote:
>
>  > +     page = virt_to_head_page(objp);
>  > +     if (!page)
>  > +             return 0;
>
>
> virt_to_head_page cannot return NULL. virt_to_page also does not return
>  NULL. pfn_valid() needs to be used to figure out if a page is valid.
>  Otherwise the page struct reference that was returned may have
>  PageReserved() set to indicate that it is not a valid page.
>

Are you sure it shouldn't be virt_addr_valid()? If yes, can you please
explain the difference? Thanks :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
