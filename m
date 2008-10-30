Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbYJ3A5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbYJ3A5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYJ3A4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:56:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051AbYJ3A4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:56:54 -0400
Date: Wed, 29 Oct 2008 17:56:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Parag Warudkar" <parag.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: Stale NFS File Handle but !NFS
Message-Id: <20081029175643.ad0f1dca.akpm@linux-foundation.org>
In-Reply-To: <f7848160810231458tea58cf7x362ad03743b564ed@mail.gmail.com>
References: <f7848160810231458tea58cf7x362ad03743b564ed@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 17:58:34 -0400
"Parag Warudkar" <parag.lkml@gmail.com> wrote:

> Anyone got an idea why I am getting the below error with today's git
> while compiling the kernel?
> 
>   LD      arch/x86/vdso/built-in.o
> scripts/Makefile.build:373: net/netfilter/.xt_mac.o.cmd: Stale NFS file handle
> make[2]: stat: net/netfilter/.xt_mac.o.cmd: Stale NFS file handle
> make[2]: *** No rule to make target `net/netfilter/.xt_mac.o.cmd'.  Stop.
> make[1]: *** [net/netfilter] Error 2
> make: *** [net] Error 2
> parag@parag-desktop:~/kernel-dev/linux-2.6-wk$ rm net/netfilter/.xt_mac.o.cmd
> rm: cannot remove `net/netfilter/.xt_mac.o.cmd': Stale NFS file handle
> parag@parag-desktop:~/kernel-dev/linux-2.6-wk$ sudo rm
> net/netfilter/.xt_mac.o.cmd
> 
> Even trying 'sudo rm -f' on that file gives the same error.
> 
> I am not using NFS at all which makes this one sound weird!
> 

Is this still happening?

If so, I'd be looking at that new `return ERR_PTR(-ESTALE)' in
d_obtain_alias().

