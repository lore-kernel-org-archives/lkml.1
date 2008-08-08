Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbYHHEZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbYHHEZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 00:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbYHHEZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 00:25:40 -0400
Received: from smtp.knology.net ([24.214.63.101]:42790 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYHHEZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 00:25:40 -0400
Subject: Re: [GIT PULL]: firmware patches for building firmware into kernel
From: David Dillow <dave@thedillows.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1218166760.2540.18.camel@jaswinder.satnam>
References: <1218128219.14483.7.camel@jaswinder.satnam>
	 <1218130222.18118.7.camel@lap75545.ornl.gov>
	 <1218130475.14483.16.camel@jaswinder.satnam>
	 <1218133288.18118.20.camel@lap75545.ornl.gov>
	 <1218159490.2553.13.camel@jaswinder.satnam>
	 <1218164391.17642.14.camel@obelisk.thedillows.org>
	 <1218166760.2540.18.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 00:25:37 -0400
Message-Id: <1218169537.17642.40.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 09:09 +0530, Jaswinder Singh wrote:
> On Thu, 2008-08-07 at 22:59 -0400, David Dillow wrote:
> > I don't like releasing the firmware before the pci_unregister_driver()
> > call. I worry about ordering issues during cleanup, though I'll admit I
> > have not yet researched if it will be a problem. In any event, if you're
> > going to request it once per adapter in typhoon_init_one(), then it
> > should be in the per-device struct, and released in
> > typhoon_remove_one().
>
> Here is updated patch :

You've fixed one part of the issues I described, but I think you've left
open the possibility of dangling pointers when one card in a multi NIC
system fails to come up. Again, I need to track down the code to see if
I'm all wet or not.

> > Drop the typhoon patches, and once you fix the problems in the core,
> > I'll respin the patch in a style I'm comfortable with. It will also need
> > to be tested before it goes upstream.
> 
> I can understand you are very worried about typhoon.
> But this is only first version of patches. This will goto David
> WoodHouse tree and he will again revise it.
> 
> And driver is yours you can change it as per your comfort, No one can
> stop you or typhoon ;)

I'd rather not have to undo the breakage when I fix it to my comfort --
best to get it right the first time if it is possible, and it is in this
instance. I'm not just worried about typhoon, I'm worried about the core
code and the other drivers you've converted. A brief skim over your tg3
and acenic patches suggests you took to heart the need to keep the
firmware around while the device is up, but the basic locking issues in
the core code suggest there are more lessons to be absorbed.

There's no way to get experience except by doing, and I applaud your
efforts to learn the code, but please drop the typhoon part and
concentrate on getting the core right. I've already committed to fixing
typhoon once you do.

Dave

