Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYDXMZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYDXMZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYDXMZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:25:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48609 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYDXMZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:25:30 -0400
Subject: Re: x86: 4kstacks default
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, T David Chinner <dgc@sgi.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080424095215.GA13088@infradead.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	 <20080418142934.38ce6bf4.akpm@linux-foundation.org>
	 <20080419142329.GA5339@elte.hu> <1208928421.9060.22.camel@pasglop>
	 <20080423233652.GT103491721@sgi.com>
	 <20080423174516.0982a325@laptopd505.fenrus.org>
	 <20080424095215.GA13088@infradead.org>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 14:25:19 +0200
Message-Id: <1209039919.7115.360.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-24 at 05:52 -0400, Christoph Hellwig wrote:

> > I wonder if the direct reclaim path should avoid direct reclaim if the stack has only X bytes left.
> > (where the value of X is... well we can figure that one out later)
> 
> Actually direct reclaim should be totally avoided for complex
> filesystems.  It's horrible for the stack and for the filesystem
> writeout policy and ondisk allocation strategies.

That's basically any reclaim, even kswapd will ruin policy and block
allocation smarts.

