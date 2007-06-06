Return-Path: <linux-kernel-owner+w=401wt.eu-S965661AbXFFX3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661AbXFFX3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935394AbXFFX3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:29:16 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4989 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbXFFX3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:29:15 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 6 Jun 2007 16:29:13 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070607001932.35c9591c@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706061619560.10383@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
 <20070607001932.35c9591c@the-village.bc.nu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Alan Cox wrote:

> > > 	prctl(PR_SPARSEFD, 1);
> > > 
> > > to turn on sparse fd allocation for a process ?
> > 
> > There was a little discussion where I tried to whisper something similar, 
> > but Linus and Uli shot me :) - with good reasons IMO.
> > You may link to runtimes that are not non-sequentialfd aware, and will 
> > break them.
> 
> Linking to the correct version of a libary and getting the library
> versioning right is not rocket science and isn't a sane excuse. Its no
> different to the stdio to large fd migration issues with many Unixen and
> they all coped just fine.

I don't think it's a matter of versioning. Many userspace libraries 
expects their fds to be compact (for many reasons - they use select, they 
use them to index 0-based arrays, etc...), and if the kernel suddendly 
starts returning values in the 1<<28 up arena, they sure won't be happy.
So I believe that the correct way is that the caller specifically selects 
the feature, leaving the legacy fd allocation as default.



- Davide


