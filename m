Return-Path: <linux-kernel-owner+w=401wt.eu-S935778AbXHNVy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935778AbXHNVy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765739AbXHNVdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:33:45 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:56990 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765205AbXHNVdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:33:43 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=Zw7mBCx3l2gqnUQ7l/RoX4QsV8qxg8jWTL29WMIMKUTbzM4SUfD/UdguTT6y+3ogByZn8jtX0moF8EN5Cqgx9qstE1mOQIOfEZXWsL0GKWahgb1j30qESxIHZmaUbeik;
X-IronPort-AV: E=Sophos;i="4.19,261,1183352400"; 
   d="scan'208";a="340727517"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: EHCI Regression in 2.6.23-rc2
Date: Tue, 14 Aug 2007 16:33:15 -0500
Message-ID: <DFEF91B22ED07447AB6AA4B237F913F9B18E7F@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <20070814154942.A544A2350CA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: EHCI Regression in 2.6.23-rc2
Thread-Index: Acfeir7yhr2kq0PoSiaU2EBYlqjmxwALv1hQ
References: <200708101045.57166.dex@dragonslave.de> <200708140843.42196.webmaster@dragonslave.de> <200708140101.19651.david-b@pacbell.net> <200708141146.43215.webmaster@dragonslave.de> <DFEF91B22ED07447AB6AA4B237F913F9B18E53@ausx3mpc125.aus.amer.dell.com> <20070814154942.A544A2350CA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
From: <Stuart_Hayes@Dell.com>
To: <david-b@pacbell.net>, <webmaster@dragonslave.de>
Cc: <linux-usb-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <jikos@jikos.cz>, <greg@kroah.com>
X-OriginalArrivalTime: 14 Aug 2007 21:33:28.0471 (UTC) FILETIME=[C0E2A270:01C7DEBA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
>> Hm... I've got a 0.95.  I'll try to get a Via EHCI 1.00 controller
>> and make sure it's the same problem.
> 
> Yeah, for some reason way too many of the add-on PCI cards with VIA
> chips use that pretty-broken VT6202 chip.  Ones with VT6212 are also
> available, and work a lot better.  
> 
> 
>>> Regarding the option to blacklist VIA in the module:
>>> I would prefer blacklisting VIA by default but giving the module
>>> some parameter like "honours inactive bit" to override this.
>>> 
>>> Perhaps there are newer VIA Chips out there, that indeed do this and
>>> some users trigger happy enough to test this. :)
>> 
>> That kernel parameter sounds like a reasonable idea to me.
> 
> Yes, IFF we know that the bug shows up in EHCI 1.00 chips rather than
> just the already-known-to-be-buggy VT6202 chips.  (I think part of
> the deal was that until the parts went through some conformance
> testing, nobody could use the "1.0" label.  There were also a few
> small feature updates and spec clarifications.  If anyone else
> shipped silicon in volume that was as buggy as a VT6202, I didn't see
> any.)      
> 
> I'd be happy to see a warning come out whenever a VT6202 is found,
> since its problems are NOT limited to this I-bit bug. 
> 

OK, I've got a VIA VT6212, and it's definitely not the same as the
6202--it's locking up my system, too, with my patch, and it is
definitely not just ignoring the inactivate bit.  I'm still trying to
figure out what's going on.

The NEC controller (EHCI 1.00) seems to work fine, though.


