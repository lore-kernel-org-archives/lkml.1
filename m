Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbXJYEjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbXJYEjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbXJYEi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:38:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44094 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392AbXJYEi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:38:56 -0400
Date: Wed, 24 Oct 2007 21:35:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: davids@webmaster.com
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Is gcc thread-unsafe?
Message-ID: <20071024213533.12115ba0@laptopd505.fenrus.org>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKAEOKHLAC.davids@webmaster.com>
References: <200710251358.55185.nickpiggin@yahoo.com.au>
	<MDEHLPKNGKAHNMBLJOLKAEOKHLAC.davids@webmaster.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 21:29:56 -0700
"David Schwartz" <davids@webmaster.com> wrote:

> 
> > Well that's exactly right. For threaded programs (and maybe even
> > real-world non-threaded ones in general), you don't want to be
> > even _reading_ global variables if you don't need to. Cache misses
> > and cacheline bouncing could easily cause performance to completely
> > tank in some cases while only gaining a cycle or two in
> > microbenchmarks for doing these funny x86 predication things.
> 
> For some CPUs, replacing an conditional branch with a conditional
> move is a *huge* win because it cannot be mispredicted.

please name one...
Hint: It's not one made by either Intel or AMD in the last 4 years...


> In general,
> compilers should optimize for unshared data since that's much more
> common in typical code. Even for shared data, the usual case is that
> you are going to access the data few times, so pulling the cache line
> to the CPU is essentially free since it will happen eventually.

it's not about pulling it to the CPU, it's pulling it *out* of all the
other cpus AS WELL. (and writing it back to memory, taking away memory
bandwidth)


--
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
