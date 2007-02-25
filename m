Return-Path: <linux-kernel-owner+w=401wt.eu-S933660AbXBYFns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660AbXBYFns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 00:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933659AbXBYFns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 00:43:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37419 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933660AbXBYFnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 00:43:47 -0500
Date: Sun, 25 Feb 2007 05:43:42 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
Message-ID: <20070225054342.GA7941@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Woodhouse <dwmw2@infradead.org>, Theodore Tso <tytso@mit.edu>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165449.5845.18238.sendpatchset@localhost.localdomain> <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron> <20070220145503.GC3170@thunk.org> <1171984555.3518.5.camel@hades.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171984555.3518.5.camel@hades.cambridge.redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 03:15:55PM +0000, David Woodhouse wrote:
> > It would be much better to use __be32 and __be64, so you get better
> > type checking, and you will catch bugs caused by forgetting to use
> > be32_to_cpu, et. al. 
> 
> The technique Artem uses is derived from what I do in JFFS2. It predates
> the use of sparse to catch such errors, and works in gcc for _everyone_
> without having to do anything special (like run sparse).

And makes the code clumsy and pointlessly different from all other code
we have.  While no one will force you to convert your legacy point at
this code, we really shouldn't add more non-standard code.  If you
really want warnings from gcc directly I doubt __attribute__((bitwise))
would be hard to implement for it.
