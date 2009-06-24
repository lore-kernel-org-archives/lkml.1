Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbZFXSpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbZFXSpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZFXSow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:44:52 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41097 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbZFXSov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ooaW16fWVGo9oiFt7IQOw5vHjj5wfE3L21efo04T+OUtNktFqtbsraWqoHv3opewJr
         yLEdnDoqc0ew28b0nFk2I8cbVukPW1SfIWXOPDbDHcljboMO1TQn+BaS363ja+Hn1uek
         T3xrkkUtWdbIGZR/Njukbj8SEyd0Gy0EGhawk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain>
References: <20090624080753.4f677847@infradead.org>
	 <20090624094622.d0b0fd82.akpm@linux-foundation.org>
	 <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>
	 <20090624105517.904f93da.akpm@linux-foundation.org>
	 <4A426825.80905@cs.helsinki.fi>
	 <20090624113037.7d72ed59.akpm@linux-foundation.org>
	 <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain>
Date: Wed, 24 Jun 2009 21:44:53 +0300
X-Google-Sender-Auth: 0c3af4044a632502
Message-ID: <84144f020906241144of2c85c7xc5f258a7837896c9@mail.gmail.com>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, arjan@infradead.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, npiggin@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, 24 Jun 2009, Andrew Morton wrote:
>>
>> hm, I didn't know that slub could fall back to lower-order allocations
>> like that.  Neat.

On Wed, Jun 24, 2009 at 9:42 PM, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
> Slab doesn't do it, though. So we still need to get rid of the "order-1"
> warning, at least (slab_break_gfp_order).
>
>> What's the expected value of s->min in allocate_slab()?  In what
>> situations would it be >0?
>
> For slub, s->min has an order of just "get_order(size)" (ie the minimum
> order to fit an object).
>
> For slab, the logic is different, but if I read the code correctly it
> boils down to the minimum order, except that order-1 is accepted instead
> of order-0 (strictly speaking, that only happens if you have more than
> 64MB of RAM). With no fallback.
>
> And it's quite reasonable to expect to be able to do small kmalloc's
> without failing.
>
> So I'd suggest just doing this..

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

That said, I do think we ought to fix SLUB not to use __GFP_FAIL for
the higher order allocation regardless of this patch.

                                Pekka
