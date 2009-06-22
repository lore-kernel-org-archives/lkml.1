Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZFVWvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZFVWvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZFVWvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:51:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:59689 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbZFVWvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:51:08 -0400
Subject: Re: Regression: ppc powerstation boot hang caused by slab
 initialisation code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1245710457.17035.9.camel@mulgrave.site>
References: <1245708635.17035.6.camel@mulgrave.site>
	 <1245709633.20062.13.camel@pasglop>
	 <1245710457.17035.9.camel@mulgrave.site>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 08:51:02 +1000
Message-Id: <1245711062.4017.1.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 17:40 -0500, James Bottomley wrote: 
> On Tue, 2009-06-23 at 08:27 +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2009-06-22 at 17:10 -0500, James Bottomley wrote:
> > > I'm getting a boot hang on my powerstation with recent kernels.  It
> > > hangs in the early prom init code:
> > 
> > It probably goes much further but doesn't get a chance to tell you :-)
> 
> Well, I did wonder about that ... but it's using the open firmware
> serial console 

"returning from prom_init" is the point where it returns from the Open
Firmware -> Linux "trampoline" at which point the OF console isn't
available anymore on powerpc. On the maple, you won't get anything from
there until you map the serial port (unless there's an RTAS console, I
don't remember but even if there is, won't help unless we initialize
it).

We do have some .config-enabled hacks to turn on early consoles for
those things that will help, but don't waste your time, I'll track that
one down, I've been tracking and fixing a bunch of those fallover from
the allocators being moved.

> > I'll dig. Just in case, can you send me your .config ?
> 
> Sure, attached.

Ah, I notice you use SLAB, that's the second report of hangs with it due to
the changes. You can try SLUB while I'm looking, might help.

Cheers,
Ben.

