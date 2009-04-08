Return-Path: <linux-kernel-owner+w=401wt.eu-S1763618AbZDHKP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763618AbZDHKP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbZDHKPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:15:16 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:33715 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758344AbZDHKPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TtekTfEq9GJROfBHd9OxOQdLnOtX0/9e/3Sy9DdddNcV1Uej7wA7H6IpEYkum/tqER
         4cInK5TQKA0K+BqCEF7K6jkALkSuQjJyWGn4iQP9pWQbCKJ9raBueP0iU19fJ6YeHDhS
         rH3xntKvIXiTgbaeh7VHbn0tSlCR2yByYc/b4=
MIME-Version: 1.0
In-Reply-To: <1237823287-12734-2-git-send-email-philipp.reisner@linbit.com>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-2-git-send-email-philipp.reisner@linbit.com>
Date: Wed, 8 Apr 2009 15:45:13 +0530
Message-ID: <807b3a220904080315r7277dd68t1abd08b6c5a830dd@mail.gmail.com>
Subject: Re: [PATCH 01/12] DRBD: lru_cache
From: Nikanth K <nikanth@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Nikanth Karthikesan <knikanth@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 9:17 PM, Philipp Reisner
<philipp.reisner@linbit.com> wrote:

> +/* this is developers aid only! */
> +#define PARANOIA_ENTRY() BUG_ON(test_and_set_bit(__LC_PARANOIA, &lc->flags))
> +#define PARANOIA_LEAVE() do { clear_bit(__LC_PARANOIA, &lc->flags); smp_mb__after_clear_bit(); } while (0)
> +#define RETURN(x...)     do { PARANOIA_LEAVE(); return x ; } while (0)
> +


The PARANOIA_LEAVE is used for void functions, so RETURN can be
changed to take a simple non-variadic argument. Or empty RETURN()
could be used everywhere instead of mixing PARANOIA_LEAVE() and
RETURN(). Just to make it consistent.

Also this could be made as nop based on some config debug option?

Thanks
Nikanth
