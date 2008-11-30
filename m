Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYK3DF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYK3DF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 22:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYK3DFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 22:05:20 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:55403 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYK3DFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 22:05:19 -0500
Date: Sun, 30 Nov 2008 08:31:28 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Am?rico Wang <xiyou.wangcong@gmail.com>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH][UML] Boot broken due to buffer overrun
Message-ID: <20081130030128.GA8948@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Am?rico Wang <xiyou.wangcong@gmail.com>,
	jdike@addtoit.com, linux-kernel@vger.kernel.org,
	user-mode-linux-devel@lists.sourceforge.net
References: <20081129100830.GA24128@balbir.in.ibm.com> <2375c9f90811290503s1b4cb9aelaecccc680c6e37d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <2375c9f90811290503s1b4cb9aelaecccc680c6e37d0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* WANG Cong <xiyou.wangcong@gmail.com> [2008-11-29 13:03:42]:

> On Sat, Nov 29, 2008 at 10:08 AM, Balbir Singh
> <balbir@linux.vnet.ibm.com> wrote:
> >
> > mconsole_init() passed 256 bytes as length in os_create_unix_socket, while
> > the sizeof UNIX_PATH_MAX is 108. This patch fixes that problem and avoids
> > a big overrun bug reported on UML bootup.
> >
> > Reported-by: Vikas K Managutte <vikki.km@gmail.com>
> > Reported-by: Sarvesh Kumar Lal Das <skldas@gmail.com>
> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > ---
> >
> >  arch/um/drivers/mconsole_kern.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff -puN arch/um/drivers/mconsole_kern.c~fix-uml-buggy-socket-creation arch/um/drivers/mconsole_kern.c
> > --- linux-2.6.28-rc6/arch/um/drivers/mconsole_kern.c~fix-uml-buggy-socket-creation      2008-11-29 15:29:04.000000000 +0530
> > +++ linux-2.6.28-rc6-balbir/arch/um/drivers/mconsole_kern.c     2008-11-29 15:32:23.000000000 +0530
> > @@ -16,6 +16,8 @@
> >  #include <linux/slab.h>
> >  #include <linux/syscalls.h>
> >  #include <linux/utsname.h>
> > +#include <linux/socket.h>
> > +#include <linux/un.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/mutex.h>
> >  #include <asm/uaccess.h>
> > @@ -785,7 +787,7 @@ static int __init mconsole_init(void)
> >        /* long to avoid size mismatch warnings from gcc */
> >        long sock;
> >        int err;
> > -       char file[256];
> > +       char file[UNIX_PATH_MAX];
> >
> 
> 
> Aha, good spot!
> 
> Please also correct the length of mconsole_socket_name.
>

I did not fix that with UNIX_PATH_MAX since, mconsole_user.c already includes
sys/un.h and sys/socket.h and I did not want to include kernel headers
linux/socket.h and linux/un.h there. I could have hard-coded those
values to 108, but I just let it be for now. If you feel strongly
about it, it can be done.
 
> Anyway,
> 
> Reviewed-by: WANG Cong <wangcong@zeuux.org>

Thanks!

-- 
	Balbir
