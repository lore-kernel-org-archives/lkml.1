Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYFCGQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYFCGQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYFCGQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:16:47 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:45044 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750866AbYFCGQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:16:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=At50Eq9S6tL+Vor27be5851Hk9Jp19fTT6TecxqpwKqvqX2Wbu1Yl0+lQCyGm2PE9tL4U/3A3kkl2GBTTZC8Ikn+lmuOLHROjlk6FcJCRszHV5WO3+IRR/4vkbbmdN1rx/DF7qoRJOKiZGcRikqZOv/bnjNI/i7D+CiwAFcfByI=  ;
X-YMail-OSG: TMMBTN8VM1mkE04bdJcyEBDMj2hGW9cT6XKglRTzlMuoPtBtiTEB.QMMqOvS7cnD_bi2g5JlFxP6QEEq70CZoSAnOiXKSTEbQyi5nsWr79fG1_duTDAbS3wq4r7rNQ8mc4U-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Stephen Hemminger <stephen.hemminger@vyatta.com>
Subject: Re: [PATCH 2/5] sky2: don't warn if page allocation fails
Date: Tue, 3 Jun 2008 16:16:32 +1000
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jgarzik@pobox.com>, Stephen Hemminger <shemminger@vyatta.com>,
       netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080515000412.984337700@vyatta.com> <48354398.9070307@pobox.com> <20080527114723.4b2b94f9@speedy>
In-Reply-To: <20080527114723.4b2b94f9@speedy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031616.33251.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2008 04:47, Stephen Hemminger wrote:
> On Thu, 22 May 2008 05:57:44 -0400
>
> Jeff Garzik <jgarzik@pobox.com> wrote:
> > >  	for (i = 0; i < sky2->rx_nfrags; i++) {
> > > -		struct page *page = alloc_page(GFP_ATOMIC);
> > > +		struct page *page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> > >
> > >  		if (!page)
> > >  			goto free_partial;
> >
> > IMO it's inappropriate to add these warnings to net drivers that
> > properly check all return values.
> >
> > This approach is too maintenance intensive, and winds up fixing the same
> > problem over and over again -- a hint that the fix is in the wrong place.
> >
> > 	Jeff
>
> So the __GFP_NOWARN should go away and get replaced by GFP_WARN?

We actually still want to see the messages, regardless of what is causing
them, because they can indicate problems in the VM.

The best way is not to add __GFP_NOWARN at all, and just improve the
throttling/thresholding/reporting of the page allocation failure warnings.
