Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYHTUaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYHTUaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbYHTU3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:29:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58322 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYHTU3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:29:50 -0400
Subject: Re: [RFC v2][PATCH 8/9] Remove some BUG_ON()s that need some
	proper error handling instead.
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: arnd@arndb.de
Cc: jeremy@goop.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080820192607.91E0AFF2@nimitz>
References: <20080820192557.98788FAB@nimitz>
	 <20080820192607.91E0AFF2@nimitz>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 13:29:46 -0700
Message-Id: <1219264186.8960.53.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 12:26 -0700, Dave Hansen wrote:

> diff -puN checkpoint/checkpoint.c~0002-Remove-some-BUG_ON-s-that-need-some-proper-error-ha checkpoint/checkpoint.c
> --- oren-cr.git/checkpoint/checkpoint.c~0002-Remove-some-BUG_ON-s-that-need-some-proper-error-ha        2008-08-20 12:12:51.000000000 -0700
> +++ oren-cr.git-dave/checkpoint/checkpoint.c    2008-08-20 12:12:51.000000000 -0700
> @@ -125,7 +125,8 @@ static int cr_write_tail(struct cr_ctx *
>         h.id = 0;
> 
>         hh->magic = CR_HEADER_MAGIC;
> -       hh->cksum[0] = hh->cksum[1] = 1;        /* TBD ... */
> +       hh->cksum[0] = 1;
> +               hh->cksum[1] = 1;       /* TBD ... */
> 
>         ret = cr_write_obj(ctx, &h, hh);
>         kfree(hh);

Whoops, that's a bad hunk that belongs in the next patch.  Sorry.

-- Dave

