Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbXFGKs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbXFGKs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbXFGKsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:48:18 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:39052 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbXFGKsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:48:17 -0400
Date: Thu, 7 Jun 2007 12:45:05 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-Id: <20070607124505.2d829b9b.dada1@cosmosbay.com>
In-Reply-To: <20070607110623.53322dae@the-village.bc.nu>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	<20070606235906.72439d16@the-village.bc.nu>
	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
	<20070607001932.35c9591c@the-village.bc.nu>
	<Pine.LNX.4.64.0706061619560.10383@alien.or.mcafeemobile.com>
	<20070607110623.53322dae@the-village.bc.nu>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 11:06:23 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > I don't think it's a matter of versioning. Many userspace libraries 
> > expects their fds to be compact (for many reasons - they use select, they 
> > use them to index 0-based arrays, etc...), and if the kernel suddendly 
> > starts returning values in the 1<<28 up arena, they sure won't be happy.
> > So I believe that the correct way is that the caller specifically selects 
> > the feature, leaving the legacy fd allocation as default.
> 
> I don't understand the connection between this paragraph (with which I
> agree) and the urge to add a ton of ugly syscall hacks. "Caller
> specifically selects feature" - > prctl(). Libraries get unhappy ->
> linker issue.
> 

Alan, prctl() things are usually inherited at fork()/exec() time.

If you fork() from a new application , then exec an old one 
(eventually a statically linked program), we have a problem ?
