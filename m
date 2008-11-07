Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbYKGOKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbYKGOKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYKGOKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:10:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYKGOKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:10:43 -0500
Subject: Re: bdi: register sysfs bdi device only once per queue
From: Peter Zijlstra <peterz@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kay.sievers@vrfy.org,
       folkert@vanheusden.com, jacmet@sunsite.dk, linux-kernel@vger.kernel.org
In-Reply-To: <1225923040.3882.0.camel@macbook.infradead.org>
References: <1225727635.6009.9.camel@linux>
	 <1225728530.7803.1630.camel@twins>
	 <20081105121015.75f497d1.akpm@linux-foundation.org>
	 <1225923040.3882.0.camel@macbook.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Nov 2008 15:11:18 +0100
Message-Id: <1226067078.2697.36.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 23:10 +0100, David Woodhouse wrote:
> On Wed, 2008-11-05 at 12:10 -0800, Andrew Morton wrote:
> > > > Devices which share the same queue, like floppies and mtd devices,
> > > > get registered multiple times in the bdi interface, but bdi accounts
> > > > only the last registered device of the devices sharing one queue.
> > > 
> > > David, is there any reason the mtd devices do this?
> > 
> > [tap tap - is this thing turned on?]
> 
> No particular reason. It's been done that way since the dawn of time,
> when it was perfectly normal. Nobody's yet bothered to change that, when
> changing the rules.

It looks to be the consequence of using one queue for a bunch of devices
(which seems odd), and its all tied into this translation layer which
starts a thread per queue.

Do you want me to rip this up and make it do one queue/thread per
device? - seems invasive...
