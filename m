Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbYKKGz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbYKKGz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYKKGzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:55:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50085 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbYKKGzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:55:18 -0500
Date: Tue, 11 Nov 2008 15:54:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: rc4-mmotm1110 - Another build error
Message-Id: <20081111155438.a46bdac1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081110194353.1a1f616e.akpm@linux-foundation.org>
References: <38231.1226373633@turing-police.cc.vt.edu>
	<20081110194353.1a1f616e.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 19:43:53 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 10 Nov 2008 22:20:33 -0500 Valdis.Kletnieks@vt.edu wrote:
> 
> > gcc --version says:
> > gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)
> > 
> > ka-blam number 2:
> > 
> >   CC      kernel/audit.o
> > In file included from include/net/dst.h:15,
> >                  from include/net/sock.h:57,
> >                  from kernel/audit.c:54:
> > include/net/neighbour.h:114: error: braced-group within expression allowed only inside a function
> > make[1]: *** [kernel/audit.o] Error 1
> > 
> > I'm placing bets on patches/align-avoid-evaluating-its-argument-twice.patch
> > 
> > Yep, revert that patch, and audit.o compiles again.
> > 
> 
> I hadn't got around to testing that one yet.
> 
> So ug.  ALIGN() is used in array sizing and hence has to be a
> compile-time thing.  But ALIGN(foo, bar()) will call bar() twice.
> 
> Now how do we fix that?

How about provoding
  - ALIGN()  - args can be evaluated twice.
 and
  - static inline unsigned long align()

messy ?

Thanks,
-Kame



