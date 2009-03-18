Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbZCRRfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbZCRRfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbZCRRfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:35:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbZCRRfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:35:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com
Subject: Re: [patch] eventfd - remove fput() call from possible IRQ context (3rd rev)
References: <49B89B22.7080303@cosmosbay.com>
	<20090311224712.fb8db075.akpm@linux-foundation.org>
	<49B8A75E.6040409@cosmosbay.com>
	<20090311233903.f036027a.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com>
	<1236986902.7265.73.camel@heimdal.trondhjem.org>
	<alpine.DEB.1.10.0903131732300.13254@makko.or.mcafeemobile.com>
	<1237003328.7265.98.camel@heimdal.trondhjem.org>
	<alpine.DEB.1.10.0903140729060.26556@makko.or.mcafeemobile.com>
	<alpine.DEB.1.10.0903141826120.3888@makko.or.mcafeemobile.com>
	<20090315174445.GD18305@kvack.org>
	<alpine.DEB.1.10.0903151303490.16762@makko.or.mcafeemobile.com>
	<x49wsamhpvg.fsf@segfault.boston.devel.redhat.com>
	<alpine.DEB.1.10.0903181018530.13607@makko.or.mcafeemobile.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 18 Mar 2009 13:34:21 -0400
In-Reply-To: <alpine.DEB.1.10.0903181018530.13607@makko.or.mcafeemobile.com>
	(Davide Libenzi's message of "Wed, 18 Mar 2009 10:25:10 -0700 (PDT)")
Message-ID: <x493adahh0i.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi <davidel@xmailserver.org> writes:

> The following patch remove a possible source of fput() call from inside 
> IRQ context. Myself, like Eric, wasn't able to reproduce an fput() call 
> from IRQ context, but Jeff said he was able to, with the attached test 
> program. Independently from this, the bug is conceptually there, so we 
> might be better off fixing it.
> This patch adds an optimization similar to the one we already do on 
> ->ki_filp, on ->ki_eventfd. Playing with ->f_count directly is not pretty 
> in general, but the alternative here would be to add a brand new delayed 
> fput() infrastructure, that I'm not sure is worth it.
>
>
> On Sun, 15 Mar 2009, Benjamin LaHaise wrote:
>
>> This looks reasonably sane, the only concern I have with it is that I think 
>> it logically makes more sense to use the same convention for fi_filp and 
>> ki_eventfd, as the different in IS_ERR vs checking for NULL is a bit 
>> confusing.  Aside from that, it looks like it should fix the problem 
>> correctly.
>
> Makes sense.
>
>
>
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
