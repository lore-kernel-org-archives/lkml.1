Return-Path: <linux-kernel-owner+w=401wt.eu-S1763580AbXILDV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763580AbXILDV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 23:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbXILDVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 23:21:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40480 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984AbXILDVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 23:21:21 -0400
Date: Tue, 11 Sep 2007 20:20:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, support@moxa.com.tw,
       Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Moxa: Fix tiny compiler warning when building withoug
 CONFIG_PCI
Message-Id: <20070911202054.dad2ac0c.akpm@linux-foundation.org>
In-Reply-To: <200708170008.58649.jesper.juhl@gmail.com>
References: <200708170008.58649.jesper.juhl@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 00:08:58 +0200 Jesper Juhl <jesper.juhl@gmail.com> wrote:

> 
> Fix this tiny compiler warning in Moxa driver : 
>   drivers/char/mxser.c:386: warning: 'mxser_get_PCI_conf' declared 'static' but never defined
> when building without CONFIG_PCI.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  drivers/char/mxser.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
> index 2aee3fe..83b15b5 100644
> --- a/drivers/char/mxser.c
> +++ b/drivers/char/mxser.c
> @@ -383,7 +383,9 @@ static int mxser_init(void);
>  
>  /* static void   mxser_poll(unsigned long); */
>  static int mxser_get_ISA_conf(int, struct mxser_hwconf *);
> +#ifdef CONFIG_PCI
>  static int mxser_get_PCI_conf(int, int, int, struct mxser_hwconf *);
> +#endif
>  static void mxser_do_softint(struct work_struct *);
>  static int mxser_open(struct tty_struct *, struct file *);
>  static void mxser_close(struct tty_struct *, struct file *);
> 

mxser_get_PCI_conf() is defined before it is used anwyay.  So that
prototype is a stupid waste of space and just adds problems.

--- a/drivers/char/mxser.c~mxser-fix-compiler-warning-when-building-withoug-config_pci
+++ a/drivers/char/mxser.c
@@ -383,7 +383,6 @@ static int mxser_init(void);
 
 /* static void   mxser_poll(unsigned long); */
 static int mxser_get_ISA_conf(int, struct mxser_hwconf *);
-static int mxser_get_PCI_conf(int, int, int, struct mxser_hwconf *);
 static void mxser_do_softint(struct work_struct *);
 static int mxser_open(struct tty_struct *, struct file *);
 static void mxser_close(struct tty_struct *, struct file *);
_

