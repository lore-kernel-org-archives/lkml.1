Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZFWDZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZFWDZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 23:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZFWDZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 23:25:23 -0400
Received: from ozlabs.org ([203.10.76.45]:43568 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZFWDZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 23:25:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier race conditions
Date: Tue, 23 Jun 2009 12:55:16 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Gregory Haskins <ghaskins@novell.com>, mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231255.17015.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 09:24:20 am Davide Libenzi wrote:
> I actually ended up exposing the eventfd context anyway, since IMO is a
> better option instead of holding references to the eventfd file (that
> makes VFS people uneasy).

lguest is a special case since we don't let them close the fds, except by 
closing /dev/lguest.

Lguest change seems fine, but:

> Index: linux-2.6.mod/drivers/lguest/lg.h
> ===================================================================
> --- linux-2.6.mod.orig/drivers/lguest/lg.h	2009-06-21 15:55:17.000000000
> -0700 +++ linux-2.6.mod/drivers/lguest/lg.h	2009-06-21 15:56:00.000000000
> -0700 @@ -80,9 +80,11 @@ struct lg_cpu {
>  	struct lg_cpu_arch arch;
>  };
>
> +struct eventfd_ctx;
> +
>  struct lg_eventfd {
>  	unsigned long addr;
> -	struct file *event;
> +	struct eventfd_ctx *event;
>  };

The first 'struct eventfd_ctx;' line is not required.

Thanks,
Rusty.
