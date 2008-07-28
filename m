Return-Path: <linux-kernel-owner+w=401wt.eu-S1761928AbYG1VTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761928AbYG1VTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761184AbYG1VNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:13:46 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:32697 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761488AbYG1VNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:13:45 -0400
X-Trace: 53514423/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/81.1.72.79
X-SBRS: None
X-RemoteIP: 81.1.72.79
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEALTTjUhRAUhP/2dsb2JhbACBW68S
X-IronPort-AV: E=Sophos;i="4.31,267,1215385200"; 
   d="scan'208";a="53514423"
Subject: Re: drivers/sh/maple/maple.c compile error
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080728210121.GA27971@linux-sh.org>
References: <20080728202012.GD7713@cs181140183.pp.htv.fi>
	 <20080728204438.GC20019@linux-sh.org>
	 <1217278308.6875.3.camel@localhost.localdomain>
	 <20080728210121.GA27971@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Jul 2008 22:13:15 +0100
Message-Id: <1217279595.6875.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 06:01 +0900, Paul Mundt wrote:
> On Mon, Jul 28, 2008 at 09:51:48PM +0100, Adrian McMenamin wrote:
> > On Tue, 2008-07-29 at 05:44 +0900, Paul Mundt wrote:
> > > On Mon, Jul 28, 2008 at 11:20:12PM +0300, Adrian Bunk wrote:
> > > > Commit 306cfd630a4d121cf4e08b894d8b4c4cf106e57e
> > > > (maple: tidy maple_driver code by removing redundant connect/disconnect)
> > > > causes the following compile error:
> > > > 
> > > > <--  snip  -->
> > > > 
> > > > ...
> > > >   CC      drivers/sh/maple/maple.o
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c: In function 'attach_matching_maple_driver':
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c:259: error: 'struct maple_driver' has no member named 'connect'
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c: In function 'maple_detach_driver':
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c:272: error: 'struct maple_driver' has no member named 'disconnect'
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c:273: error: 'struct maple_driver' has no member named 'disconnect'
> > > > make[4]: *** [drivers/sh/maple/maple.o] Error 1
> > > > 
> > > > <--  snip  -->
> > > > 
> > > Adrian was supposed to send follow-up patches for this, which never
> > > happened. I thought I had dropped this already, but in this case I'll
> > > just revert it.
> > 
> > Actually I wasn't asked about this, but to submit a fix/replacement for
> > a patch that didn't apply.
> > 
> > I will submit a patch for the whole thing then - as I cannot actually
> > match the commit Adrian has quoted to anything.
> > 
> > I think the problem is that I am trying to get a change in the bus and
> > in the drivers (which have different maintainers) to go in together and
> > that has never quite worked. The code runs fine on my box and has done
> > for months now.
> > 
> This seems to point to a serious problem in your working environment, as
> you are neither able to view commits that are referenced or realize there
> is a problem when patches fail to apply anywhere outside of your home
> directory.
> 

I searched in Linus's tree on kernel.org after I couldn't find it in
mine. I can see the commit (﻿306cfd630a4d121cf4e08b894d8b4c4cf106e57e)
referred to in both trees but it doesn't include any changes to the
maple stuff.


> The problem is that the change you made to maple.c is incomplete, it
> basically should have followed 2 other patches, one removing the logic
> entirely from maple.c, and one removing it from the input driver, before
> killing off the function pointers completely.  You were asked to fix up
> and resend the input patch (which seems not to have happened due to a
> problem in your work environment), but I'm unable to find anything
> bordering on a maple patch that actually cleans up
> attach_matching_maple_driver() and maple_detach_driver()
> connect/disconnect references?
> 

http://lkml.org/lkml/2008/6/15/121 - removes the references from
keyboard
http://lkml.org/lkml/2008/6/15/122 - removes the references from the
headers

> In any event, I'm going to revert this. Once you get your environment
> fixed and are able to send a coherent series, we can revisit this. Dmitry
> has already indicated that taking the input bits through my tree is fine,
> so any process problems there are the least of the problem.

I don't think there is anything wrong with my environment. But I am
happy to submit a new set of patches

