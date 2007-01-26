Return-Path: <linux-kernel-owner+w=401wt.eu-S1161135AbXAZSOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161135AbXAZSOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161149AbXAZSOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:14:46 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60595 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161135AbXAZSOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:14:43 -0500
Date: Fri, 26 Jan 2007 12:14:37 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       serue@us.ibm.com, clg@fr.ibm.com, herbert@13thfloor.at, oleg@tv-sign.ru,
       daniel@hozac.com
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Message-ID: <20070126181437.GA28927@sergelap.austin.ibm.com>
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> <45BA3A8C.5020802@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA3A8C.5020802@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michal Piotrowski (michal.k.k.piotrowski@gmail.com):
> akpm@osdl.org napisa?(a):
> > The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> > 
> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> 
> kernel/exit.c: In function 'do_exit':
> kernel/exit.c:941: warning: implicit declaration of function 'preexit_task_namespaces'
> kernel/exit.c:941: warning: assignment makes pointer from integer without a cast
> kernel/exit.c:943: error: too many arguments to function 'exit_task_namespaces'
> make[1]: *** [kernel/exit.o] Error 1
> make: *** [kernel] Error 2
> 
> Regards,
> Michal
> 
> --
> Michal K. K. Piotrowski
> LTG - Linux Testers Group
> (http://www.stardust.webpages.pl/ltg/)
> 
> Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> 
> --- linux-work-clean/include/linux/nsproxy.h	2007-01-26 17:40:29.000000000 +0100
> +++ linux-work/include/linux/nsproxy.h	2007-01-26 18:23:19.000000000 +0100
> @@ -51,6 +51,6 @@ static inline void put_and_finalize_nspr
>  	finalize_put_nsproxy(put_nsproxy(ns));
>  }
> 
> -extern void exit_task_namespaces(struct task_struct *p);
> +extern void exit_task_namespaces(struct task_struct *p, struct nsproxy *ns);
> 
>  #endif

Can you send me your series file for broken-out-2007-01-26-00-36.tar.gz,
and I'll try to iron these out?  This is due to an older patch of
Cedric's being applied at the same time as the preexit_task_namespaces
one, and I just need to properly integrate them.

thanks,
-serge
