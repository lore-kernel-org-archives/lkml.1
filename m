Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbXK1SWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbXK1SWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXK1SWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:22:14 -0500
Received: from pmx2.sophos.com ([213.31.172.17]:45287 "EHLO pmx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbXK1SWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:22:13 -0500
In-Reply-To: <20071128093956.6625584b@freepuppy.rosehill>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.5 November 30, 2005
Message-ID: <OF74C1FF25.986585E9-ON802573A1.006239BF-802573A1.0064DE96@sophos.com>
From: tvrtko.ursulin@sophos.com
Date: Wed, 28 Nov 2007 18:22:00 +0000
X-MIMETrack: Serialize by Router on Mercury/Servers/Sophos(Release 7.0.2FP1|January 10, 2007) at
 28/11/2007 18:22:02,
	Serialize complete at 28/11/2007 18:22:02
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-kernel-owner@vger.kernel.org wrote on 28/11/2007 17:39:56:

> On Wed, 28 Nov 2007 16:46:13 +0000
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Wed, Nov 28, 2007 at 08:38:43AM -0800, Casey Schaufler wrote:
> > > Would you like to expound on that, or do you feel your claws
> > > are sharp enough already?
> > 
> > Just take a look at code.
> > 
> 
> The module in question hooks to the syscall table which is not
> acceptable.  Including dumpster diving through symbol table to
> find the syscall table since it is no longer exported.

That is not completely true.

As I said in the second part of my original email (that part Christoph 
deleted so please read it whole) I would prefer not to discuss all the 
ugly things some parts of our code do because they are irrelevant to the 
LSM discussion. But I still feel some extra explanation might be needed.

Talpa is modular itself being composed of a set of kernel modules of which 
not all are loaded simultaneously. Where possible LSM can be used and _no_ 
messing with syscall table will take place. Unfortunately where another 
LSM user is present that won't work and another solution had to be found. 
Also that drags history from 2.4 where that was the only solution.

So as there is no question the current code does some ugly things it is 
even more true that we would be even more happy to use an official API. 
LSM was that and we were happily using it which we won't be able to do if 
it abruptly goes away. Yes it is not a perfect match but until it is 
modified to be better, or until something appropriate is designed and 
implemented, it would be very nice if it could stay.

-- 
Tvrtko August Ursulin
Senior Software Engineer, Sophos

Tel: 01235 559933
Web: www.sophos.com
Protecting business against viruses, spyware, spam and policy abuse


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

