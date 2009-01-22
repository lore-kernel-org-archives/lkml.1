Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZAVXZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZAVXZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbZAVXZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:25:34 -0500
Received: from tservice.ru ([195.178.208.66]:54892 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381AbZAVXZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:25:33 -0500
Date: Fri, 23 Jan 2009 02:25:32 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090122232532.GA5656@ioremap.net>
References: <alpine.DEB.2.00.0901220156310.1738@chino.kir.corp.google.com> <20090122101424.GA12317@ioremap.net> <alpine.DEB.2.00.0901220218120.2851@chino.kir.corp.google.com> <20090122132133.GA17524@ioremap.net> <alpine.DEB.2.00.0901221216330.2085@chino.kir.corp.google.com> <20090122210613.GA10158@ioremap.net> <alpine.DEB.2.00.0901221314010.6145@chino.kir.corp.google.com> <20090122220446.GA1651@ioremap.net> <alpine.DEB.2.00.0901221415050.10427@chino.kir.corp.google.com> <20090122225304.GA3551@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122225304.GA3551@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 01:53:04AM +0300, Evgeniy Polyakov (zbr@ioremap.net) wrote:
> > I'm quite certain you've spent more time writing emails to me than merging 
> > the patch and testing its possibilities, given your lack of understanding 
> > of its very basic concepts.
> 
> How cute :)
> Any other technical arguments of the same strength?

Its my turn now for the professional statements, let's start with this
technical side: you wanted to send a signal for the process to be killed,
but this will need
1. to allocate a signal, which will deadlock
2. no need to do this for sigill, but it will not work if process is in
unkillable state, while oom-killer clears iirc

Now to the oom-handler: if it will want to free some memory, it will
have to call a syscall with some pointer, which in turn may be in the
swapped area, so handler will be locked.

-- 
	Evgeniy Polyakov
