Return-Path: <linux-kernel-owner+w=401wt.eu-S1758323AbYHZSyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbYHZSyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbYHZSxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:53:50 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:54187 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702AbYHZSxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:53:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=NY+jZq44Alhmf3CGUULeLkty7bz6uWcEg4fDUpc7krfLYaYv/SolQhJk+4TUNEW0LZ
         GWjB27VmItavNV3GqprKKDOf+MNyccihxbpFyTBfipyfWuyWt1CygkQFNZRHFRV7QvYo
         VumswMJ+5BcYlCv3TbNRoHeBV492BaclJ0Bgc=
Message-ID: <f158dc670808261153l218dca95t9e68cabbd85ac68@mail.gmail.com>
Date: Tue, 26 Aug 2008 12:53:48 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Abhishek Kulkarni" <kulkarni@lanl.gov>
Subject: Re: [V9fs-developer] [PATCH] 9p bug fix: return non-zero error value in p9_put_data
Cc: v9fs-developer@lists.sourceforge.net, ericvh@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1219771831.16125.12.camel@blender>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219771831.16125.12.camel@blender>
X-Google-Sender-Auth: 1247290aea140a10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Latchesar Ionkov <lucho@ionkov.net>

On Tue, Aug 26, 2008 at 11:30 AM, Abhishek Kulkarni <kulkarni@lanl.gov> wrote:
> p9_put_data is called by p9_create_twrite which expects it to return a
> non-zero value on error. This was the reason why every p9_client_write
> was failing. This patch also adds a check for buffer overflow in
> p9_put_data.
>
> Signed-off-by: Abhishek Kulkarni <kulkarni@lanl.gov>
> ---
>  net/9p/conv.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> diff --git a/net/9p/conv.c b/net/9p/conv.c
> index 4454720..7f6db15 100644
> --- a/net/9p/conv.c
> +++ b/net/9p/conv.c
> @@ -451,8 +451,11 @@ p9_put_data(struct cbuf *bufp, const char *data,
> int count,
>                   unsigned char **pdata)
>  {
>        *pdata = buf_alloc(bufp, count);
> +       if (buf_check_overflow(bufp))
> +               return -EIO;
> +
>        memmove(*pdata, data, count);
> -       return count;
> +       return 0;
>  }
>
>  static int
>
>
> Thanks,
>  -- Abhishek
>
>
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> V9fs-developer mailing list
> V9fs-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/v9fs-developer
>
