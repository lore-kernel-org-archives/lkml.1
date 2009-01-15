Return-Path: <linux-kernel-owner+w=401wt.eu-S1761068AbZAOInk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068AbZAOInk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757723AbZAOInc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:43:32 -0500
Received: from corega.com.ru ([195.178.208.66]:41081 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbZAOInb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:43:31 -0500
Date: Thu, 15 Jan 2009 11:43:28 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Bodo Eggert <7eggert@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
Message-ID: <20090115084328.GA29586@ioremap.net>
References: <bTx3z-8bU-23@gated-at.bofh.it> <bTxdg-8sZ-23@gated-at.bofh.it> <bTxdg-8sZ-21@gated-at.bofh.it> <bTxmW-hf-1@gated-at.bofh.it> <bTRYr-2up-21@gated-at.bofh.it> <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org> <20090114192216.GA18123@ioremap.net> <alpine.DEB.2.00.0901141651540.22699@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901141651540.22699@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 04:54:09PM -0800, David Rientjes (rientjes@google.com) wrote:
> > This does not work if processes are short-living and are spawned by the
> > parent on demand. If processes have different priority in regards to oom
> > condition, this problem can not be solved with existing interfaces
> > without changing the application. So effectively there is no solution.
> > 
> 
> Wrong, you can change how the application is forked.  Either immediately 
> adjust /proc/$!/oom_adj or use the adjustment inheritance property and 
> change /proc/$$/oom_adj to the desired value prior to forking.  Thanks.

You and Alan so like bash... Applications are not always forked from shell.

I already pointed multiple times where parent om_adj changes lead, and
that this does not work in a real world for some common cases. Existing
scheme only works if some daemon (or application itself) explicitely
changes oom_adj, but no dameon exists to monitor /proc and applications
do not change their own and child's oom_adj because it is way too
linuxish to add such hacks to deal with system's oom-killer, which can
not be properly configured otherwise.

-- 
	Evgeniy Polyakov
