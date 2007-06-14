Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbXFNPDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbXFNPDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbXFNPD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:03:26 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:28910 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753376AbXFNPDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:03:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=G7kc/mMo2JjpD3UVtx7E0QA687IQUF1SuG4MHjPaZrBXBdKAeGrmoeYXWk6yhygTYk/qjdlleOUQ8XNX1rpztv7Vh76OQHHQRowgSngHSp3Xj6Kk9IRKRkuTad1oAKocZNuEIAD9Et5rLc3JCOf+pBgJbcLdLsEF6gLbv5N5CLw=  ;
X-YMail-OSG: qhZiEaIVM1n8A6d62z8MOE45K2YBdQ.wtwLHM5TWaB4Dz7iC_YstEP4.5TaOjGd87Fg55DRYSQ--
From: David Brownell <david-b@pacbell.net>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH -mm 4/7] PM: Remove suspend and resume support from struct device_type
Date: Thu, 14 Jun 2007 08:03:17 -0700
User-Agent: KMail/1.9.6
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Stern" <stern@rowland.harvard.edu>, "Greg KH" <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl> <200706140719.28829.david-b@pacbell.net> <d120d5000706140744w13f3ed50xc923f11bda7cb8e6@mail.gmail.com>
In-Reply-To: <d120d5000706140744w13f3ed50xc923f11bda7cb8e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706140803.18603.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007, Dmitry Torokhov wrote:
> On 6/14/07, David Brownell <david-b@pacbell.net> wrote:
> > On Wednesday 13 June 2007, Dmitry Torokhov wrote:
> > > On Wednesday 13 June 2007 18:20, Kay Sievers wrote:
> > > > Dmitry, you added this recently, is this used in any code you plan to
> > > > merge soon?
> > > >
> > >
> > > Yes, I will need it to implement input device resume (mainly to restore LED
> > > state and repeat rate for keyboards).
> >
> > Why wouldn't that use the class device suspend/resume mechanism?
> >
> 
> Because they are not class devices anymore.

Perhaps you mis-understood me:  the class level device suspend/resume
hooks don't rely on class_device.  I observe that /sys/class/input
still exists (2.6.22-rc4-git), so if all you mean is that it's no
longer using class_device, that's good.  One part of the reason to
stop using class_device is specifically to let framework code (like
input, network, or rtc) receive class level suspend/resume calls.

ISTR the RTC framework was the first to do that, but there's some
work afoot to teach the network stack to use that mechanism too.

Or are you referring to some input patches which I've not yet seen,
which cause /sys/class/input to vanish?

- Dave
