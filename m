Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbXJCK2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbXJCK2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbXJCK2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:28:42 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:24490 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752958AbXJCK2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:28:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mTpeK5gvRCy3Dj6p6GSEalLYYA0lMNVIXLiwCipw7XF00eEFl4h6Jl5EePlIGh2lSQ98EkT9EyZbI4Wb5bmoUZrwq5SkVeaPyE9YbnOEGnz0WOAESWxxxBL+aCQoGkFsldiyBDra3N+bEwJsFEQGGL1b5qSahmDuZyhWdC9UsSk=  ;
X-YMail-OSG: 8GzR.roVM1krN5_8LyWb_DGYFFpR7boD0IdfDuJ8riZI1GZM19frlrb2m5GwHQHkr6sCAnRI_A--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Torvalds, Linus" <torvalds@linux-foundation.org>, linux-mm@kvack.org
Subject: remove zero_page (was Re: -mm merge plans for 2.6.24)
Date: Wed, 3 Oct 2007 03:45:09 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
In-Reply-To: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710030345.10026.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007 07:22, Andrew Morton wrote:

> remove-zero_page.patch
>
>   Linus dislikes it.  Probably drop it.

I don't know if Linus actually disliked the patch itself, or disliked
my (maybe confusingly worded) rationale?

To clarify: it is not zero_page that fundamentally causes a problem,
but it is a problem that was exposed when I rationalised the page
refcounting in the kernel (and mapcounting in the mm).

I see about 4 things we can do:
1. Nothing
2. Remove zero_page
3. Reintroduce some refcount special-casing for the zero page
4. zero_page per-node or per-cpu or whatever

1 and 2 kind of imply that nothing much sane should use the zero_page
much (the former also implies that we don't care much about those who
do, but in that case, why not go for code removal?).

3 and 4 are if we think there are valid heavy users of zero page, or we
are worried about hurting badly written apps by removing it. If the former,
I'd love to hear about them; if the latter, then it definitely is a valid
concern and I have a patch to avoid refcounting (but if this is the case
then I do hope that one day we can eventually remove it).


> mm-use-pagevec-to-rotate-reclaimable-page.patch
> mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
> mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch
> mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch
> mm-use-pagevec-to-rotate-reclaimable-page-fix-bug-at-include-linux-mmh220.p
>atch
> mm-use-pagevec-to-rotate-reclaimable-page-kill-redundancy-in-rotate_reclaim
>able_page.patch
> mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drai
>n.patch
>
>   I guess I'll merge this.  Would be nice to have wider perfromance testing
>   but I guess it'll be easy enough to undo.

Care to give it one more round through -mm? Is it easy enough to
keep? I haven't had a chance to review it, which I'd like to do at some
point (and I don't think it would hurt to have a bit more testing).
