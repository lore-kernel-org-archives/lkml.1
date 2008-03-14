Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbYCNFxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbYCNFxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYCNFxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:53:01 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:22207 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751585AbYCNFxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:53:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3XN1JdIGevTjrRi4chAO6wTy+F0b6ouG8omsV69m29Pe7o3wguoFFSYs8T1h8Xa6MDZs7z2ZdlTMc4IdzM13Fo72tm7aHD2W9/VYXEbrQb+N8wq36DDsOUmCIl/60M2kmUgV1ZnpPtF2RysrzIIjGSXTVQ+mwx0YrS1p4I/AptA=  ;
X-YMail-OSG: GTkcbVUVM1n7EP2FAg2T_OZtvaMkgau7G8dgvyCOjToC.tO70H_LIZjwBCWjRMzCCt41nqTLbecpGyVkSo7h9q.txvPseGHanr_UptZ6VO53v9ycNw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.25-rc5 1/2] gpiolib:  dynamic gpio number allocation
Date: Thu, 13 Mar 2008 21:52:57 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, avorontsov@ru.mvista.com
References: <200803131549.54632.david-b@pacbell.net> <200803131753.58733.david-b@pacbell.net> <20080313191747.dede60c3.akpm@linux-foundation.org>
In-Reply-To: <20080313191747.dede60c3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803132252.58101.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, Andrew Morton wrote:
> > > > Actually, I tried IDRs for a while and they broke platforms
> > > > which needed to initialize and use GPIOs early: before kmalloc
> > > > would work.  A real PITA that was -- and slow too.
> > > 
> > > If IDRs were slow, that linear search will be glacial.
> > 
> > The slowness of IDRs was needing to use them for the
> > routine lookups ... versus the current array index,
> > which costs a fraction of an instruction cycle and
> > doesn't need separate locks.
> > 
> > Or were you implying they should be used for something
> > other than mapping GPIO numbers to controllers/state?
> 
> For dynamic allocation.  There should be no need for lookups outside
> register/unregister.

So -- a secondary data structure used only for allocation?
With the primary one as it is now? 

If allocation were a hotspot something like that might be
worth considering ... though such duplication is usually
error prone.  But it's not; such allocation is a rarity.


> Where did the CONFIG_NR_GPIOS discussion disappear to?
 
http://marc.info/?l=linux-kernel&m=120545979527097&w=2

I could maybe see a CONFIG_NR_EXTRA_GPIOS.
