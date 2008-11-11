Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbYKKDoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbYKKDoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 22:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbYKKDn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 22:43:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbYKKDnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 22:43:55 -0500
Date: Mon, 10 Nov 2008 19:43:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: rc4-mmotm1110 - Another build error
Message-Id: <20081110194353.1a1f616e.akpm@linux-foundation.org>
In-Reply-To: <38231.1226373633@turing-police.cc.vt.edu>
References: <38231.1226373633@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 22:20:33 -0500 Valdis.Kletnieks@vt.edu wrote:

> gcc --version says:
> gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)
> 
> ka-blam number 2:
> 
>   CC      kernel/audit.o
> In file included from include/net/dst.h:15,
>                  from include/net/sock.h:57,
>                  from kernel/audit.c:54:
> include/net/neighbour.h:114: error: braced-group within expression allowed only inside a function
> make[1]: *** [kernel/audit.o] Error 1
> 
> I'm placing bets on patches/align-avoid-evaluating-its-argument-twice.patch
> 
> Yep, revert that patch, and audit.o compiles again.
> 

I hadn't got around to testing that one yet.

So ug.  ALIGN() is used in array sizing and hence has to be a
compile-time thing.  But ALIGN(foo, bar()) will call bar() twice.

Now how do we fix that?
