Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbXFYWtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbXFYWtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXFYWtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:49:33 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2514 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbXFYWtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:49:33 -0400
Date: Tue, 26 Jun 2007 00:49:47 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
In-Reply-To: <9a8748490706251520g24ff7a9dk716d73e7dbfd9ec3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706260032230.1817@scrub.home>
References: <20070625200601.GA18980@elte.hu>  <200706252309.47467.zippel@linux-m68k.org>
  <9a8748490706251417v10b3f24bwdf7ebd44093eaddf@mail.gmail.com> 
 <Pine.LNX.4.64.0706252356400.1817@scrub.home>
 <9a8748490706251520g24ff7a9dk716d73e7dbfd9ec3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 26 Jun 2007, Jesper Juhl wrote:

> Even if it is not faster, what would make it slower?  Have you spotted
> something I have not?

There are other ways to read the clock and would require similiar 
synchronization hooks.
Some archs can implement sys_time() in userspace, so there this change 
would be useless.
I don't know what clock was used in the test, so maybe it can be replaced 
with a faster clock.

AFAICT OLTP is not really a common application for most users, so there 
may be other ways to optimize this special case. Just reading the patch 
isn't enough here, you have to look at the whole picture and some pieces 
are still missing...

bye, Roman
