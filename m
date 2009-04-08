Return-Path: <linux-kernel-owner+w=401wt.eu-S933420AbZDHMA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420AbZDHMA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932148AbZDHLjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:39:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:39344 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764887AbZDHLjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vTJdUItsLUP9NGJj/hYHq7Gqsgq7g+033zVcOo+TpZDLuF6VTVxvmIBjt9daaqkIOi
         2lDMomEpswrWJ/W2FyHsXCGnV6+cSQdKxK8soQX/b9DCMnLfWDGfd4WAAPRdhWn6SmMH
         wEoe39VVn1LKR6Zd/yrMaQGtWyn/NhnuY7zcQ=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 13:39:18 +0200
Message-ID: <36ca99e90904080439u7098d2feka5dd39f8ab6a470c@mail.gmail.com>
Subject: Re: [PATCH 20/56] inflate: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 13:21, Jack Stone <jwjstone@fastmail.fm> wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  lib/inflate.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/lib/inflate.c b/lib/inflate.c
> index 1a8e8a9..4b672f9 100644
> --- a/lib/inflate.c
> +++ b/lib/inflate.c
> @@ -249,7 +249,7 @@ static void *malloc(int size)
>
>        malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
>
> -       p = (void *)malloc_ptr;
> +       p = malloc_ptr;
>        malloc_ptr += size;
>
>        if (free_mem_end_ptr && malloc_ptr >= free_mem_end_ptr)
> @@ -481,7 +481,7 @@ DEBG1("3 ");
>         z = 1 << j;             /* table entries for j-bit table */
>
>         /* allocate and link in new table */
> -        if ((q = (struct huft *)malloc((z + 1)*sizeof(struct huft))) ==
> +        if ((q = malloc((z + 1)*sizeof(struct huft))) ==
>             (struct huft *)NULL)
Thats an unneeded cast too. (After that, the NULL can move up one line.)

Bert
>         {
>           if (h)
