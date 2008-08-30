Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbYH3URy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbYH3URy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYH3URq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:17:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbYH3URp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:17:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] Re: Linux 2.6.27-rc5
Date: Sat, 30 Aug 2008 22:21:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Grant Grundler <grundler@parisc-linux.org>,
       linux-parisc@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <g9b7oa$g8l$1@ger.gmane.org>
In-Reply-To: <g9b7oa$g8l$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808302221.43237.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs]

On Saturday, 30 of August 2008, Helge Deller wrote:
> commit da574983de9f9283ba35662c8723627096e160de
> Author: Al Viro <viro@zeniv.linux.org.uk>
> [PATCH] fix hpux_getdents() - Missing checks for -EFAULT, broken handling of
> overflow.
> 
> introduced a build breakage:
>   CC      arch/parisc/hpux/fs.o
> arch/parisc/hpux/fs.c: In function `filldir':
> arch/parisc/hpux/fs.c:107: error: `buffer' undeclared (first use in this
> function)
> make[1]: *** [arch/parisc/hpux/fs.o] Error 1
> 
> 
> This patch fixes it.
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> 
> 
> diff --git a/arch/parisc/hpux/fs.c b/arch/parisc/hpux/fs.c
> index 69ff671..12c04c5 100644
> --- a/arch/parisc/hpux/fs.c
> +++ b/arch/parisc/hpux/fs.c
> @@ -104,7 +104,7 @@ static int filldir(void * __buf, const char * name, int
> namlen, loff_t offset,
>         buf->count -= reclen;
>         return 0;
>  Efault:
> -       buffer->error = -EFAULT;
> +       buf->error = -EFAULT;
>         return -EFAULT;
>  }
>  
> 
> 
