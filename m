Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbZBWHYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbZBWHYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZBWHYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:24:22 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:35220 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZBWHYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:24:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sLSnpj/bz5P3Lh18TPSk8JnIaESWOO1EkXmb/ItaZIR0tLvPDMaFq98jhhPOWlZS+d
         EvkJ2E5aUSr00ZXB7+B27Jh9tlkDjul8lJv0r4p4s55LHiJYLYYVG7nlD/TrCaOTEtp7
         wj39bFeNDS/6Vy1PAO3Cu76gtwVKsWBDUAOZg=
MIME-Version: 1.0
In-Reply-To: <1235344649-18265-14-git-send-email-mel@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
	 <1235344649-18265-14-git-send-email-mel@csn.ul.ie>
Date: Mon, 23 Feb 2009 09:24:19 +0200
X-Google-Sender-Auth: 2156737da192ffe6
Message-ID: <84144f020902222324i38de9a63hd112b90742c2ca8c@mail.gmail.com>
Subject: Re: [PATCH 13/20] Inline buffered_rmqueue()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 1:17 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> buffered_rmqueue() is in the fast path so inline it. This incurs text
> bloat as there is now a copy in the fast and slow paths but the cost of
> the function call was noticeable in profiles of the fast path.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d8a6828..2383147 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1080,7 +1080,8 @@ void split_page(struct page *page, unsigned int order)
>  * we cheat by calling it from here, in the order > 0 path.  Saves a branch
>  * or two.
>  */
> -static struct page *buffered_rmqueue(struct zone *preferred_zone,
> +static inline
> +struct page *buffered_rmqueue(struct zone *preferred_zone,
>                        struct zone *zone, int order, gfp_t gfp_flags,
>                        int migratetype)
>  {

I'm not sure if this is changed now but at least in the past, you had
to use __always_inline to force GCC to do the inlining for all
configurations.
