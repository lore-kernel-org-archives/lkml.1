Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbYK2KVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbYK2KVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYK2KVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:21:48 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:65197 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbYK2KVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:21:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GuIsrtDiaUcdN13H7S1kp6Ug1bLaTGIKhty85wTRK6MwKLpEnJreOYLz6RevUrYTsd
         wVje9HmSr0U0tnTPkdr0bItd6swGx2MDupEsUzxrS8FCFl1pbceW/nuM+glXHddodTzG
         QbSYMZJwGTyAFmzFQ3xGabf8t/6+hfOiVasGs=
Message-ID: <84144f020811290221g947f836n4fe3435676425ee@mail.gmail.com>
Date: Sat, 29 Nov 2008 12:21:46 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: balbir@linux.vnet.ibm.com, jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH][UML] Boot broken due to buffer overrun
In-Reply-To: <20081129100830.GA24128@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081129100830.GA24128@balbir.in.ibm.com>
X-Google-Sender-Auth: 74c203c5a337657f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

On Sat, Nov 29, 2008 at 12:08 PM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
> mconsole_init() passed 256 bytes as length in os_create_unix_socket, while
> the sizeof UNIX_PATH_MAX is 108. This patch fixes that problem and avoids
> a big overrun bug reported on UML bootup.

Maybe mention that ->sun_path in struct sockaddr_un is UNIX_PATH_MAX
long which causes the problem?

> Reported-by: Vikas K Managutte <vikki.km@gmail.com>
> Reported-by: Sarvesh Kumar Lal Das <skldas@gmail.com>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>
>  arch/um/drivers/mconsole_kern.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff -puN arch/um/drivers/mconsole_kern.c~fix-uml-buggy-socket-creation arch/um/drivers/mconsole_kern.c
> --- linux-2.6.28-rc6/arch/um/drivers/mconsole_kern.c~fix-uml-buggy-socket-creation      2008-11-29 15:29:04.000000000 +0530
> +++ linux-2.6.28-rc6-balbir/arch/um/drivers/mconsole_kern.c     2008-11-29 15:32:23.000000000 +0530
> @@ -16,6 +16,8 @@
>  #include <linux/slab.h>
>  #include <linux/syscalls.h>
>  #include <linux/utsname.h>
> +#include <linux/socket.h>
> +#include <linux/un.h>
>  #include <linux/workqueue.h>
>  #include <linux/mutex.h>
>  #include <asm/uaccess.h>
> @@ -785,7 +787,7 @@ static int __init mconsole_init(void)
>        /* long to avoid size mismatch warnings from gcc */
>        long sock;
>        int err;
> -       char file[256];
> +       char file[UNIX_PATH_MAX];
>
>        if (umid_file_name("mconsole", file, sizeof(file)))
>                return -1;
> _
>
> --
>        Balbir
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
