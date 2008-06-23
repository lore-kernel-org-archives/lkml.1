Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYFWPSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYFWPSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbYFWPSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:18:18 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:12294 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbYFWPSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E1mg4XQsLDl7KK78Io9ac7YwqOTnU01sOyXT1MbDTaMKtdk2Lgx1zhZIKyUWmkUjEi
         /n/Z5jsIeymDq88UzxTi3ZZ4rJVmQMUNfRygJI6gQAaNksEWMMscEESsjIGNOWTLo+e1
         Ul+26dKtdwr7MbblEJhRgN15adyboh0efjkMc=
Message-ID: <b6a2187b0806230818g28f6731cua588c8db711d10f2@mail.gmail.com>
Date: Mon, 23 Jun 2008 23:18:09 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.26-rc7
Cc: ecollins@vmware.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       support@vmware.com
In-Reply-To: <alpine.LFD.1.10.0806220926150.2926@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0806201626140.3167@woody.linux-foundation.org>
	 <b6a2187b0806220012t118d85ffp671abf715c14ea94@mail.gmail.com>
	 <alpine.LFD.1.10.0806220926150.2926@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 12:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> Hmm. Can you see which part of it broke? Was it the "fix XIP" part ot the
> ZERO_PAGE part? The easiest way to test is to apply this patch, and see
> (it just disables the XIP part of fix)

This one doesn't fix it.

Thanks,
Jeff.

> ---
>  mm/memory.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 9aefaae..9056132 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1023,8 +1023,12 @@ out:
>        return page;
>
>  bad_page:
> +#if 0
>        pte_unmap_unlock(ptep, ptl);
>        return ERR_PTR(-EFAULT);
> +#else
> +       return NULL;
> +#endif
>
>  no_page:
>        pte_unmap_unlock(ptep, ptl);
>
