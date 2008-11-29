Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbYK2NDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbYK2NDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 08:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYK2NDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 08:03:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:63304 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYK2NDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 08:03:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NOPrVmjMcUdfCaaH6C3L57efThfKblfOeJLQhCci3D+QM99LrLGetO30BKTe/l7u8A
         kXoJO68k+n4lPFGmAniml5vK2fmMfP3B+Fs/gkX2gTdOE13CsdByWVLWtRej+yNaK7wJ
         pKKfGoRL+V4wkhfkpJnq0OTQxnARvcsxuFhhw=
Message-ID: <2375c9f90811290503s1b4cb9aelaecccc680c6e37d0@mail.gmail.com>
Date: Sat, 29 Nov 2008 13:03:42 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: balbir@linux.vnet.ibm.com, jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH][UML] Boot broken due to buffer overrun
In-Reply-To: <20081129100830.GA24128@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081129100830.GA24128@balbir.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 10:08 AM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
>
> mconsole_init() passed 256 bytes as length in os_create_unix_socket, while
> the sizeof UNIX_PATH_MAX is 108. This patch fixes that problem and avoids
> a big overrun bug reported on UML bootup.
>
> Reported-by: Vikas K Managutte <vikki.km@gmail.com>
> Reported-by: Sarvesh Kumar Lal Das <skldas@gmail.com>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
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


Aha, good spot!

Please also correct the length of mconsole_socket_name.

Anyway,

Reviewed-by: WANG Cong <wangcong@zeuux.org>
