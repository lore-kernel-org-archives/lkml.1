Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZICGCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZICGCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 02:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZICGCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 02:02:09 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46216 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbZICGCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 02:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vhAlOnKOYJUw3wNIsPTGRIpWQnuC//tPLxsY/qZRwGqmWg66LZSi0FwW328eKL/4ow
         LnwdSp2DnZlNWmZiJx0cdjWLvkPJiVURxBIaqI6vEZbISncsNNtIUf6q2YWKBOTkWTl6
         ySakU5qZMqvwkuCl+3NxEVv4tyoTS4WsO+Pjc=
MIME-Version: 1.0
In-Reply-To: <1251942059-21448-2-git-send-email-lrodriguez@atheros.com>
References: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
	 <1251942059-21448-2-git-send-email-lrodriguez@atheros.com>
Date: Thu, 3 Sep 2009 09:02:09 +0300
X-Google-Sender-Auth: 4acde343625a807f
Message-ID: <84144f020909022302m2ac62f55j63e19ddac8bc511c@mail.gmail.com>
Subject: Re: [PATCH 1/5] kmemleak: use bool for true/false questions
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 4:40 AM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  mm/kmemleak.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 4872673..c6e71bb 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -264,17 +264,17 @@ static void kmemleak_disable(void);
>  * Newly created objects don't have any color assigned (object->count == -1)
>  * before the next memory scan when they become white.
>  */
> -static int color_white(const struct kmemleak_object *object)
> +static bool color_white(const struct kmemleak_object *object)
>  {
>        return object->count != -1 && object->count < object->min_count;
>  }
>
> -static int color_gray(const struct kmemleak_object *object)
> +static bool color_gray(const struct kmemleak_object *object)
>  {
>        return object->min_count != -1 && object->count >= object->min_count;
>  }
>
> -static int color_black(const struct kmemleak_object *object)
> +static bool color_black(const struct kmemleak_object *object)
>  {
>        return object->min_count == -1;
>  }
> @@ -284,7 +284,7 @@ static int color_black(const struct kmemleak_object *object)
>  * not be deleted and have a minimum age to avoid false positives caused by
>  * pointers temporarily stored in CPU registers.
>  */
> -static int unreferenced_object(struct kmemleak_object *object)
> +static bool unreferenced_object(struct kmemleak_object *object)
>  {
>        return (object->flags & OBJECT_ALLOCATED) && color_white(object) &&
>                time_before_eq(object->jiffies + jiffies_min_age,
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
