Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbZKBNBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbZKBNBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZKBNBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:01:09 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:36096 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbZKBNBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:01:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pK4BCgXg4fDQaq9/qa+kX6JcoNUxjDNj7JlVtvtV9MGdznwFRkObgNlHkS+ZdS6EB3
         xX2rfa5gspJESWyd9dpnO7ARHP98RGE7dPiKMvCGD2u7VltUAqqK6SJnBPXjrFTqCWUA
         mGv+xfzXzxwylSzBg9uAUnqLf2Tk6t8/u9kGk=
MIME-Version: 1.0
In-Reply-To: <4AEEBDD8.5080808@gmail.com>
References: <4AEEBDD8.5080808@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 2 Nov 2009 08:00:53 -0500
Message-ID: <8bd0f97a0911020500r793d7414mb55c2ec8c62250f4@mail.gmail.com>
Subject: Re: [PATCH] Blackfin arch: ensure index is positive
To: Roel Kluin <roel.kluin@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 2, 2009 at 06:09, Roel Kluin wrote:
> The indices are signed, it's not negative before we read an
> array element.
>
> Found by code analysis, is this required?
>
> --- a/arch/blackfin/kernel/gptimers.c
> +++ b/arch/blackfin/kernel/gptimers.c
> @@ -139,7 +139,7 @@ static uint32_t const timil_mask[MAX_BLACKFIN_GPTIMERS] =
>
>  void set_gptimer_pwidth(int timer_id, uint32_t value)
>  {
> -       tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
> +       tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);

the gptimer API is supposed to use symbolic defines only (TIMER#_id),
but that doesnt mean people couldnt pass in negative numbers
themselves.  but rather than fix it this way, i'll change the API to
use unsigned ints.
-mike
