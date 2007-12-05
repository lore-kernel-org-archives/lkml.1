Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbXLENdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbXLENdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 08:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXLENdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 08:33:25 -0500
Received: from thunk.org ([69.25.196.29]:42519 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbXLENdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 08:33:24 -0500
Date: Wed, 5 Dec 2007 08:33:20 -0500
From: Theodore Tso <tytso@mit.edu>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071205133320.GI7259@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	linux-kernel@vger.kernel.org
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <20071205122912.GC24685@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205122912.GC24685@torres.zugschlus.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 01:29:12PM +0100, Marc Haber wrote:
> On Tue, Dec 04, 2007 at 05:18:11PM +0100, Adrian Bunk wrote:
> > On Tue, Dec 04, 2007 at 12:41:25PM +0100, Marc Haber wrote:
> > > While debugging Exim4's GnuTLS interface, I recently found out that
> > > reading from /dev/urandom depletes entropy as much as reading from
> > > /dev/random would. This has somehow surprised me since I have always
> > > believed that /dev/urandom has lower quality entropy than /dev/random,
> > > but lots of it.
> > 
> > man 4 random
> 
> Thanks for this pointer, I was not aware of the documentation. After
> reading this thread and the docs, I am now convinced that GnuTLS
> should seed a PRNG from /dev/(u)random instead of using the entropy
> directly. I will go filing a bug against GnuTLS.

BTW, note that it would be a polite thing for GnuTLS when it is
encrpyting data, which represents information which might not be
available to an adversary, and SHA1 hash it (out of paranoia) and feed
it to /dev/random.  

This won't give any "credits" to the random entropy counter, but to
the extent that is information that isn't available to the adversary,
it adds additional uncertainty to the random pool.

   		   	       	      	     - Ted
