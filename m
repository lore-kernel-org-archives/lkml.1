Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbYGTPfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbYGTPfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 11:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbYGTPfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 11:35:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:41130 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbYGTPfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 11:35:38 -0400
Date: Sun, 20 Jul 2008 08:35:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>,
       Andy Grover <andrew.grover@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [patch 1/3] fastboot: Create a "asynchronous" initlevel
Message-ID: <20080720083530.1bc60ead@infradead.org>
In-Reply-To: <48834996.9060804@keyaccess.nl>
References: <20080718151524.5ef9e29b@infradead.org>
	<20080718151608.46dc17c0@infradead.org>
	<48819D92.8050904@keyaccess.nl>
	<4881A161.7050902@keyaccess.nl>
	<20080719084448.7859afd0@infradead.org>
	<4882E7F3.8060605@keyaccess.nl>
	<20080720041039.275c57f9@infradead.org>
	<48834996.9060804@keyaccess.nl>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2008 16:20:06 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 20-07-08 13:10, Arjan van de Ven wrote:
> 
> > On Sun, 20 Jul 2008 09:23:31 +0200
> > Rene Herman <rene.herman@keyaccess.nl> wrote:
> > 
> >> Yes, I see. Unfortunately, WITH your patches, driver_probe_done()
> >> would also no longer be safe when run from a late_initcall() it
> >> would appear.
> > 
> > true for now (but see below)
> > 
> >> I have the sneaking suspicion that this is a bit of a fundamental
> >> issue. Turning some of the driver level (6) async basicaly removes
> >> the ordering between drivers and late_initcall (level 7).
> > 
> > I was hoping to not need this ordering. 
> 
> May have found an issue with 3/3 for this same reason. 


> > Thankfully it doesn't destroy it, the reason for this is that level
> > 6 itself tends to take long enough to get benefits. It's just that
> > if we can get both 6 and 7 it's nicer. But if we end up needing to
> > sync, so be it.
> 
> I worry...

ok you convinced me... I'll post a followon patch that will have this
shortly once it finishes compiling/booting.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
