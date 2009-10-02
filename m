Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbZJBGs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbZJBGs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 02:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbZJBGs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 02:48:58 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:46570 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbZJBGs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 02:48:57 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2009 02:48:57 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e7O0iVP5jRd0u8WsQZqU2oRS5Lk4idqF/7PhIW83nRzkRrtpLWUW8rKee1TcfbWxZF
         1B2Do0jehoj24nWyR5mmAZYLSJyCYsYZ7V8Pm7tOaHtFUP0d/FAwdlcaMSx4YQ7v5vEu
         4/EeHcdNgHWCR1nkSEXvcDmOSHuCdNYQIbNLY=
MIME-Version: 1.0
In-Reply-To: <200909261428.06802.bart.vanassche@gmail.com>
References: <200909261428.06802.bart.vanassche@gmail.com>
Date: Fri, 2 Oct 2009 08:41:55 +0200
Message-ID: <e2e108260910012341v5eab14c5o29da95ec52e75183@mail.gmail.com>
Subject: Re: [PATCH 2.6.31.1] include/linux/kmemcheck.h: fix a sparse warning
From: Bart Van Assche <bart.vanassche@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vegard Nossum <vegardno@ifi.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 2:28 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
>
> Checking a 2.6.31.1 kernel configured with allyesconfig/allmodconfig
> with sparse (make C=2) triggers a sparse warning on code that uses the
> kmemcheck_annotate_bitfield() macro. An example of such a warning:
>
> include/net/inet_sock.h:208:17: warning: do-while statement is not a compound statement
>
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> Cc: Vegard Nossum <vegardno@ifi.uio.no>
> Cc: Andrew Morton <akpm@linux-foundation.org>
>
> --- linux-2.6.31.1/include/linux/kmemcheck-orig.h       2009-09-26 13:53:44.000000000 +0200
> +++ linux-2.6.31.1/include/linux/kmemcheck.h    2009-09-26 13:53:56.000000000 +0200
> @@ -137,13 +137,13 @@ static inline void kmemcheck_mark_initia
>        int name##_end[0];
>
>  #define kmemcheck_annotate_bitfield(ptr, name)                         \
> -       do if (ptr) {                                                   \
> +       do { if (ptr) {                                                 \
>                int _n = (long) &((ptr)->name##_end)                    \
>                        - (long) &((ptr)->name##_begin);                \
>                BUILD_BUG_ON(_n < 0);                                   \
>                                                                        \
>                kmemcheck_mark_initialized(&((ptr)->name##_begin), _n); \
> -       } while (0)
> +       } } while (0)
>
>  #define kmemcheck_annotate_variable(var)                               \
>        do {                                                            \

(ping)

Did anyone already have the time to review the patch above ?

Bart.
