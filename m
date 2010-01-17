Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068Ab0AQXxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0AQXxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 18:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388Ab0AQXxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 18:53:46 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34871 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab0AQXxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 18:53:46 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Jan 2010 18:53:45 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O7XIuJBwHYAIUPqJRbvxbb+GttqddE/1xOzAuBRJb6/9zp7haI14g+p3sszFlCn8+K
         cr7bn514cPZ7F3Li0m3s7/sNj0MtktqlbHrV3gTJxdqsgeReGKOU5HCPM6qyy4hyjQR2
         iEM1XURTINPUpm9buoR3BcIk7ZJpWXs8rHtn0=
MIME-Version: 1.0
In-Reply-To: <30e5fd087ee6fbe992cde8f09d945ed160b0c117.1263675077.git.andre.goddard@gmail.com>
References: <cover.1263675077.git.andre.goddard@gmail.com>
	 <30e5fd087ee6fbe992cde8f09d945ed160b0c117.1263675077.git.andre.goddard@gmail.com>
Date: Mon, 18 Jan 2010 00:47:04 +0100
Message-ID: <81b0412b1001171547s57190f69p489278d1fdf78251@mail.gmail.com>
Subject: Re: [PATCH 2/2] string: teach strnstr() to not search past 
	NUL-terminator
From: Alex Riesen <raa.lkml@gmail.com>
To: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 21:57, André Goddard Rosa
<andre.goddard@gmail.com> wrote:
> diff --git a/lib/string.c b/lib/string.c
> index 0f86245..94bad34 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -689,11 +689,13 @@ EXPORT_SYMBOL(strstr);
>  */
>  char *strnstr(const char *s1, const char *s2, size_t len)
>  {
> -       size_t l1 = len, l2;
> +       size_t l1, l2;
>
>        l2 = strlen(s2);
>        if (!l2)
>                return (char *)s1;
> +       l1 = strlen(s1);
> +       l1 = (l1 <= len) ? l1 : len;

if (l1 > len)
       l1 = len;

Less code and easier to read.
