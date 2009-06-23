Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbZFWX4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbZFWX4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbZFWX4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:56:36 -0400
Received: from fed1rmmtao106.cox.net ([68.230.241.40]:62559 "EHLO
	fed1rmmtao106.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbZFWX4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:56:35 -0400
X-VR-Score: -120.00
X-Authority-Analysis: v=1.0 c=1 a=F_o4wktclTQA:10 a=pGLkceISAAAA:8
 a=RugydN6MN-EL_xpUAtIA:9 a=CnmhoajxNzVp6HneV7RAqSx8cH8A:4 a=MSl-tDqOz04A:10
X-CM-Score: 0.00
To: =?utf-8?Q?Ren=C3=A9?= Scharfe <rene.scharfe@lsrfire.ath.cx>
Cc: roel kluin <roel.kluin@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       git@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Junio C Hamano <gitster@pobox.com>
Subject: Re: [PATCH] fread does not return negative on error
References: <4A3FB09D.9050903@gmail.com> <20090622153431.GA18466@elte.hu>
	<25e057c00906220847t15425f38maf486c291d1d2468@mail.gmail.com>
	<4A3FB479.2090902@lsrfire.ath.cx>
From: Junio C Hamano <gitster@pobox.com>
Date: Tue, 23 Jun 2009 16:56:32 -0700
In-Reply-To: <4A3FB479.2090902@lsrfire.ath.cx> (=?utf-8?Q?=22Ren=C3=A9?=
 Scharfe"'s message of "Mon\, 22 Jun 2009 18\:42\:33 +0200")
Message-ID: <7vhby64i8f.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

René Scharfe <rene.scharfe@lsrfire.ath.cx> writes:

> the following patch is for git.  I just removed the unneeded check for
> res == 0 from your version.  Does it look OK?

The patch looks good, and both of our in-tree users do error out when the
returned value is 0 (imap-send.c checks with "<= 0" which looks a tad
amateurish, though) correctly.

Funny, there is no caller of this function in the original context this
bug originally found, which I think is linux-2.6/tools/perf ;-).

Thanks.

> From: Roel Kluin <roel.kluin@gmail.com>
>
> size_t res cannot be less than 0. fread returns 0 on error.
>
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  strbuf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/strbuf.c b/strbuf.c
> index a884960..f03d117 100644
> --- a/strbuf.c
> +++ b/strbuf.c
> @@ -260,7 +260,7 @@ size_t strbuf_fread(struct strbuf *sb, size_t size, FILE *f)
>  	res = fread(sb->buf + sb->len, 1, size, f);
>  	if (res > 0)
>  		strbuf_setlen(sb, sb->len + res);
> -	else if (res < 0 && oldalloc == 0)
> +	else if (oldalloc == 0)
>  		strbuf_release(sb);
>  	return res;
>  }
