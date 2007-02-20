Return-Path: <linux-kernel-owner+w=401wt.eu-S965031AbXBTPQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031AbXBTPQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964979AbXBTPQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:16:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40533 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965031AbXBTPQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:16:04 -0500
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
From: David Woodhouse <dwmw2@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070220145503.GC3170@thunk.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
	 <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron>
	 <20070220145503.GC3170@thunk.org>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 15:15:55 +0000
Message-Id: <1171984555.3518.5.camel@hades.cambridge.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 09:55 -0500, Theodore Tso wrote:
> It appears that the reason why you are doing this is because you think
> you need the (packed) attribute.  Not needed; Linux assumes all over
> the place 16, 32, and 64 types are packed.  If Linux is ever compiled
> on an architecture where this isn't true, the compiler will probably
> need to be fixed so these assumptions are true, since all manner of
> things will break.

No, the packedness is irrelevant -- the reason is just to catch all the
places where you might otherwise forget to use byte-swapping accesses.

> It would be much better to use __be32 and __be64, so you get better
> type checking, and you will catch bugs caused by forgetting to use
> be32_to_cpu, et. al. 

The technique Artem uses is derived from what I do in JFFS2. It predates
the use of sparse to catch such errors, and works in gcc for _everyone_
without having to do anything special (like run sparse).

-- 
dwmw2

