Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbXH2Obg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbXH2Obg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 10:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbXH2Ob2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 10:31:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52371 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbXH2Ob1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 10:31:27 -0400
Date: Wed, 29 Aug 2007 07:30:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Daniel Drake <ddrake@brontes3d.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: speeding up swapoff
Message-ID: <20070829073040.1ec35176@laptopd505.fenrus.org>
In-Reply-To: <1188394172.22156.67.camel@localhost>
References: <1188394172.22156.67.camel@localhost>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007 09:29:32 -0400
Daniel Drake <ddrake@brontes3d.com> wrote:


Hi,

> I've spent some time trying to understand why swapoff is such a slow
> operation.
> 
> My experiments show that when there is not much free physical memory,
> swapoff moves pages out of swap at a rate of approximately 5mb/sec.

sounds like about disk speed (at random-seek IO pattern)


> I'm happy to spend a few more hours looking into implementing this but
> would greatly appreciate any advice from those in-the-know on if my
> ideas are broken to start with...

before you go there... is this a "real life" problem? Or just a
mostly-artificial corner case? (the answer to that obviously is
relevant for the 'should we really care' question)

Another question, if this is during system shutdown, maybe that's a
valid case for flushing most of the pagecache first (from userspace)
since most of what's there won't be used again anyway. If that's enough
to make this go faster...

A third question, have you investigated what happens if a process gets
killed that has pages in swap; as long as we don't page those in but
just forget about them, that would solve the shutdown problem nicely
(since we kill stuff first anyway there)

