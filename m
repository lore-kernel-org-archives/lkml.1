Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZFHRqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZFHRqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbZFHRpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:45:52 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:45965 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZFHRpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KmiaCplrWdNLIpaOWwxYALkPaBUThxOUiYM5iaEE9/74HOGnpdLRLdkztAkkZoNyKx
         /9qWsOGaHAdP3MP7FlULMjWfw1BxvBlND3Yb3wj4TV6VhQx9Ptb+2T7G92RKXqlOKDQi
         OoKozaOkUbL7WTtzYPGitAn6r340ZrtYlDXkA=
MIME-Version: 1.0
In-Reply-To: <1244480790.2716.7.camel@ht.satnam>
References: <200906061959.55592.chris2553@googlemail.com>
	 <1244413881.18742.31.camel@ht.satnam>
	 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>
	 <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
	 <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>
	 <1244460875.12644.2.camel@ht.satnam>
	 <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
	 <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain>
	 <1244479879.4079.284.camel@mulgrave.site>
	 <1244480790.2716.7.camel@ht.satnam>
Date: Mon, 8 Jun 2009 18:45:51 +0100
Message-ID: <c6b1100b0906081045t47c77b94ubc89d450c3a75147@mail.gmail.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
From: Chris Clayton <chris2553@googlemail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/8 Jaswinder Singh Rajput <jaswinder@kernel.org>:

> But reverting your patch Or if we return like this also fix chris
> problem :
>
> diff --git a/kernel/async.c b/kernel/async.c
> index 94dd36f..3b492cb 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -96,15 +96,13 @@ static async_cookie_t  __lowest_in_progress(struct list_head *running)
>        if (!list_empty(running)) {
>                entry = list_first_entry(running,
>                        struct async_entry, list);
> -               ret = entry->cookie;
> +               return entry->cookie;
>        }
>
>        if (!list_empty(&async_pending)) {
>                list_for_each_entry(entry, &async_pending, list)
> -                       if (entry->running == running) {
> -                               ret = entry->cookie;
> -                               break;
> -                       }
> +                       if (entry->running == running)
> +                               return entry->cookie;
>        }
>
>        return ret;
>
>
>

I can confirm that a kernel built with Jaswinder's patch applied
survived 200 boots without a panic.

Chris

-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
