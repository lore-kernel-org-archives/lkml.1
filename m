Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZCORo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZCORo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 13:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZCORos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 13:44:48 -0400
Received: from kanga.kvack.org ([205.233.56.17]:37448 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZCORos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 13:44:48 -0400
Date: Sun, 15 Mar 2009 13:44:45 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com
Subject: Re: [patch] eventfd - remove fput() call from possible IRQ context
Message-ID: <20090315174445.GD18305@kvack.org>
References: <49B89B22.7080303@cosmosbay.com> <20090311224712.fb8db075.akpm@linux-foundation.org> <49B8A75E.6040409@cosmosbay.com> <20090311233903.f036027a.akpm@linux-foundation.org> <alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com> <1236986902.7265.73.camel@heimdal.trondhjem.org> <alpine.DEB.1.10.0903131732300.13254@makko.or.mcafeemobile.com> <1237003328.7265.98.camel@heimdal.trondhjem.org> <alpine.DEB.1.10.0903140729060.26556@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0903141826120.3888@makko.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903141826120.3888@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 06:36:34PM -0700, Davide Libenzi wrote:
> The following patch remove a possible source of fput() call from inside 
> IRQ context. Myself, like Eric, wasn't able to reproduce an fput() call 
> from IRQ context, but conceptually the bug is there.
> This patch adds an optimization similar to the one we already do on 
> ->ki_filp, on ->ki_eventfd. Playing with ->f_count directly is not pretty 
> in general, but the alternative here would be to add a brand new delayed 
> fput() infrastructure, that I'm not sure is worth it.

This looks reasonably sane, the only concern I have with it is that I think 
it logically makes more sense to use the same convention for fi_filp and 
ki_eventfd, as the different in IS_ERR vs checking for NULL is a bit 
confusing.  Aside from that, it looks like it should fix the problem 
correctly.

		-ben
