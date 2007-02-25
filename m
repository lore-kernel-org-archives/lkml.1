Return-Path: <linux-kernel-owner+w=401wt.eu-S964807AbXBYLzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbXBYLzp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 06:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964820AbXBYLzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 06:55:44 -0500
Received: from thunk.org ([69.25.196.29]:44471 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964807AbXBYLzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 06:55:43 -0500
Date: Sun, 25 Feb 2007 06:55:34 -0500
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
Message-ID: <20070225115534.GA7989@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165449.5845.18238.sendpatchset@localhost.localdomain> <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron> <20070225055011.GA8616@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225055011.GA8616@infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 05:50:11AM +0000, Christoph Hellwig wrote:
> global variables are very bad for code maintainability and understanadbility.
> So we usually try to avoid them if possible and make them static to a
> single file and provide proper accessors for allowed actions on them.

Another reason why mincing up code files into little-tiny itsy-bitsy
"units" to satisfy some vague abstraction fetish learned in CS101 is a
bad idea.  :-)

Seriously, abstractions have to be at the right layer in order for
them to add value, and too many abstractions (such as the time I
looked at a C++ toolkit with dozens of abstractions layers and
hundreds of itsy-bitsy files all adding a tiny amount of functionality
on top of each other) can be actively harmful.  If you group related
files together in a single C file, then it's possible to use static
per-file variables instead of global ones much more often.

In addition, another problem with global variables is that they by
destroy the ability to have multiple instances of the code referencing
running in different processors at the same time (unless they are
properly locked, adding a contention bottleneck).  So before ever
adding a global variable it is always important to ask how is this
protected from a locking point of view, and could it be linked off
some structure instead?

						- Ted
