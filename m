Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbYGNEsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbYGNEsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 00:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYGNEsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 00:48:33 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:35855 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751661AbYGNEsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 00:48:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2tWr9PbOeWg8RyCJv8TmD2AfpWE/b5o1do1t2D86D6VkV02VKIkLXIhe4NORmrv2KVKQ2HZSRJtDtslwmBEAHDImjO1OViwi+Ah8iVgq4n6Y7b7fLbylmSMc8HL4w7vSQSm4xWDToHslIlTF8d20r44Xha68D4NMQ547HvTTs+0=  ;
X-YMail-OSG: tTVGGHwVM1m36v.BI54hT.oliUIB8LXBudTR5mfRvq7TUpjFg..XZXz_.trbwK7vR1ecnRJPGzxpw5Qs2apdbIi.EaV4_2rSyFUByKTaZkQ9bzbHFLOYQAeQrAJiOOPWauI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jon Tollefson <kniht@linux.vnet.ibm.com>
Subject: Re: SL*B: drop kmem cache argument from constructor
Date: Mon, 14 Jul 2008 14:48:21 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, penberg@cs.helsinki.fi,
       mpm@selenic.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org
References: <20080710011132.GA8327@martell.zuzino.mipt.ru> <20080711122228.eb40247f.akpm@linux-foundation.org> <4877D35E.8080209@linux.vnet.ibm.com>
In-Reply-To: <4877D35E.8080209@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807141448.22233.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 July 2008 07:40, Jon Tollefson wrote:
> Andrew Morton wrote:

> > btw, Nick, what's with that dopey
> >
> > 	huge_pgtable_cache(psize) = kmem_cache_create(...
> >
> > trick?  The result of a function call is not an lvalue, and writing a
> > macro which pretends to be a function and then using it in some manner
> > in which a function cannot be used is seven ways silly :(

I agree it isn't nice.


> That silliness came from me.
> It came from my simplistic translation of the existing code to handle
> multiple huge page sizes.  I would agree it would be easier to read and
> more straight forward to just have the indexed array directly on the
> left side instead of a macro.  I can send out a patch that makes that
> change if desired.
> Something such as
>
> +#define HUGE_PGTABLE_INDEX(psize) (HUGEPTE_CACHE_NUM + psize - 1)
>
> -huge_pgtable_cache(psize) = kmem_cache_create(...
> +pgtable_cache[HUGE_PGTABLE_INDEX(psize)] = kmem_cache_create(...
>
>
> or if there is a more accepted way of handling this situation I can
> amend it differently.

If it is a once off initialization (which it is), that's probably fine
like that. Otherwise, the convention is to have a set_huge_pgtable_cache
function as well. But whatever you prefer. Yes if you can send a patch,
that would be good, thanks.
