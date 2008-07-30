Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYG3FX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYG3FX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 01:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYG3FXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 01:23:20 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:43597 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751559AbYG3FXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 01:23:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ANwecH6al5LfYWKLHRYX2VG6ObKDCWBFUL3iNhXeSe7edLBe3JfFK792Lnj9im2NHiyjHvjl/0GAkdKedFTx+cqwRiG4MVrjlsF+mjFPYKiLmiRze6G1HzStKR9reEr9lUoWbqa89FO0oyq5CVmoCaeUDhOW7d20cofweZXEiPQ=  ;
X-YMail-OSG: i6Sap8QVM1nKvBkzGrQYSwb18leZ8vBEzUgrS4RTojYjnbFi4GmChYTCMHsMJi1rS9G0CaGfw57li21zt5WTDcK_JTvEeDVIxbC_.VbWsj.LnpiG2mpchr0USjerO9rDXaw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
Date: Wed, 30 Jul 2008 15:23:03 +1000
User-Agent: KMail/1.9.5
Cc: lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org
References: <200807301438.55941.rusty@rustcorp.com.au>
In-Reply-To: <200807301438.55941.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301523.03225.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 14:38, Rusty Russell wrote:
> After all, it was made for lguest wasn't it?

Right, I'd been using direct-IO to iron out all the bugs before
I consider it fit for use by lguest. Given that it doesn't
appear to have corrupted any disks yet, and no longer oopses...

Acked-by: Nick Piggin <npiggin@suse.de>


> Still think it should be 
> called get_current_pages() though.

We have to have some comical way to solve these disagreements,
preferably with the loser being publically humiliated. Hmm...


> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  arch/x86/mm/gup.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff -r cb465381f6d5 arch/x86/mm/gup.c
> --- a/arch/x86/mm/gup.c	Wed Jul 30 10:18:44 2008 +1000
> +++ b/arch/x86/mm/gup.c	Wed Jul 30 14:22:53 2008 +1000
> @@ -8,6 +8,7 @@
>  #include <linux/mm.h>
>  #include <linux/vmstat.h>
>  #include <linux/highmem.h>
> +#include <linux/module.h>
>
>  #include <asm/pgtable.h>
>
> @@ -296,3 +303,4 @@ slow_irqon:
>  		return ret;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(get_user_pages_fast);
