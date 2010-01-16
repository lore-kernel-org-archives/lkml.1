Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0APLNL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197Ab0APLNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:13:08 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44954 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab0APLNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:13:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NZa18ne0bYnjgDzjFoRqXErvthEXPVJQ7rSP/s/vpc7zRJHAK+SR2jKk2TCC63zCHS
         Th+k+0p/8IDvkWqILA7+vumTOv/F7Q6FPaYT2LDXQxvDOBVjkuK76RFzsTaVnVcFAIR/
         0mXkWMxa/2opI1flxfUkRQs9uK4PbRAR7tNnU=
MIME-Version: 1.0
In-Reply-To: <4B4E8743.6030805@cn.fujitsu.com>
References: <4B4E86FB.40208@cn.fujitsu.com> <4B4E8743.6030805@cn.fujitsu.com>
Date: Sat, 16 Jan 2010 12:12:57 +0100
Message-ID: <81b0412b1001160312x3874bbddj28aac9e5a36bf98a@mail.gmail.com>
Subject: Re: [PATCH 4/7] lib: Introduce strnstr()
From: Alex Riesen <raa.lkml@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 03:53, Li Zefan <lizf@cn.fujitsu.com> wrote:
> @@ -667,7 +667,7 @@ EXPORT_SYMBOL(memscan);
>  */
>  char *strstr(const char *s1, const char *s2)
>  {
> -       int l1, l2;
> +       size_t l1, l2;
>

This chunk is not related, is it?

> @@ -684,6 +684,31 @@ char *strstr(const char *s1, const char *s2)
>  EXPORT_SYMBOL(strstr);
>  #endif
>
> +#ifndef __HAVE_ARCH_STRNSTR
> +/**
> + * strnstr - Find the first substring in a length-limited string
> + * @s1: The string to be searched
> + * @s2: The string to search for
> + * @len: the maximum number of characters to search
> + */
> +char *strnstr(const char *s1, const char *s2, size_t len)
> +{
> +       size_t l1 = len, l2;

Are you sure you want to search _past_ the NUL-terminator
of s1?

> +       l2 = strlen(s2);
> +       if (!l2)
> +               return (char *)s1;
> +       while (l1 >= l2) {
> +               l1--;
> +               if (!memcmp(s1, s2, l2))
> +                       return (char *)s1;
> +               s1++;
> +       }
> +       return NULL;
> +}
