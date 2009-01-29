Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbZA2Snt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbZA2Snt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZA2Snk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:43:40 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:51253 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZA2Snk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:43:40 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 29 Jan 2009 10:43:38 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: Re: [patch 1/2] epoll fix own poll()
In-Reply-To: <20090129103715.2d3a8274.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901291039360.15448@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901271251310.20262@alien.or.mcafeemobile.com> <20090129000120.da7d249d.akpm@linux-foundation.org> <alpine.DEB.1.10.0901290956530.15448@alien.or.mcafeemobile.com> <20090129102726.5f4a0040.akpm@linux-foundation.org>
 <alpine.DEB.1.10.0901291030390.15448@alien.or.mcafeemobile.com> <20090129103715.2d3a8274.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Andrew Morton wrote:

> On Thu, 29 Jan 2009 10:32:38 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > On Thu, 29 Jan 2009, Andrew Morton wrote:
> > 
> > > But which kernel version are you looking to get this merged into?
> > 
> > The limit reworking one, ASAP. The epoll poll fix, dunno.
> > I'd like to see it staged in your tree for a bit. How much timeframe 
> > difference are we looking at, from .29 to .30?
> 
> The usual - 2.5 months(ish)
> 
> What is the impact of the bug which this patch fixes?

I think we can move the poll-fix (and definitely the debug-nuke-fix) to .30.
The bug happens when you add an epoll fd inside another wait container 
(epoll, poll, select). You may get a wakeup, to only find out later that 
epoll_wait() has no event for you. The bug has been there since day-1, and 
it has only recently been noticed.
Since it is quite some coe change, I'd like it to stage in your toxic tree 
for a while :)


- Davide


