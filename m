Return-Path: <linux-kernel-owner+w=401wt.eu-S1762487AbYGBDRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762487AbYGBDRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 23:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760939AbYGBDRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 23:17:10 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:29629 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760202AbYGBDRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 23:17:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Wtu837PGLFYxZJRj8QXBE4Tv2dCuQ8zLo5n5s5nLUXsyhrklPuyHtID7OzleYA3u8jZiUnsrvAkTehNvigxRiQ1A7IlPWYtcdNN3+pGYxP4ionjRoV2k6W0W5go4tIhvjSM06rrjegwVSWZtRA7NrGoQqH/ixIWG2I45cI/IJKY=  ;
X-YMail-OSG: LMQQPrcVM1mkNJmd1EkZDNnf.Rs0YxeWFByu0TqiWTdW.P9N5qMfknsszyXXPxLyrdLGSRYcBxxVPiBBUKeXqjuafn4chGX9MPk0G567afp7Q2D9EB4rR8xP2.iUHQ5ycE8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>,
       Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: Re: A minimally power-aware driver treats all messages as SUSPEND?
Date: Tue, 1 Jul 2008 19:57:24 -0700
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20080701072911.GA6564@digi.com> <20080701151415.GA17688@digi.com> <20080702010857.GA27031@srcf.ucam.org>
In-Reply-To: <20080702010857.GA27031@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807011957.24354.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2008, Matthew Garrett wrote:
> On Tue, Jul 01, 2008 at 05:14:15PM +0200, Uwe Kleine-König wrote:
> 
> > With that I might have to do less on SUSPEND because some state might be
> > preserved after the machine comes up again.
> 
> The only hardware state guaranteed by ACPI is the contents of RAM. It's 
> valid for the platform to cut the power rails to everything else, so 
> from a driver point of view it's almost always equivalent to 
> hibernation.

Right.  And moreover ... the way many drivers support suspend-to-RAM
in that "minimally power-aware" sense is kind of brain-dead:  they
resume by resetting and re-initializing everything!!  Which trashes
any state that the hardware may have been preserving.

So, there's no no real difference between SUSPEND and HIBERNATE modes
unless drivers do more than that bare minimum.

The more intelligent drivers will leverage hardware low power states,
and be able to use one of potentially many "retention" modes.  Those
are the drivers which may well support wakeup events; issuing wakeups
requiress the device to stay at least partially functional.

- Dave

