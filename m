Return-Path: <linux-kernel-owner+w=401wt.eu-S1764909AbXHNPty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764909AbXHNPty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbXHNPtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:49:46 -0400
Received: from smtp122.sbc.mail.re3.yahoo.com ([66.196.96.95]:40046 "HELO
	smtp122.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751517AbXHNPtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:49:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=WzfK5YvXZLLrsZxZ0cmrTXPjOEALikJ+MenT1qigZLxeqZ7I6DPdd1ILRcx8173pcxLvV0uleENB/XLGdHdzFs5xhW2yChzrA0wrFFyegnvaAP3l3hwylohG4/hMdyqfRMSOHWCzrLEaFVayzoFYZ8lMdAM/2GcwXEvodOyJ1tU=  ;
X-YMail-OSG: WbXJkYAVM1mjk11K4pOZzJqOaZD2YxOlk4_coqiUoJFMn9cYzarJRSAah4FSLh26vuquxJDAVRjUyZyxZgqqOvG9rx2H80B9Dzt2Z_t8XevrmukgHmXpux0U3mma6eNXaWQYQ1Smo3zC.SA-
Date: Tue, 14 Aug 2007 08:49:42 -0700
From: David Brownell <david-b@pacbell.net>
To: webmaster@dragonslave.de, Stuart_Hayes@Dell.com
Subject: Re: EHCI Regression in 2.6.23-rc2
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jikos@jikos.cz, greg@kroah.com
References: <200708101045.57166.dex@dragonslave.de>
 <200708140843.42196.webmaster@dragonslave.de>
 <200708140101.19651.david-b@pacbell.net>
 <200708141146.43215.webmaster@dragonslave.de>
 <DFEF91B22ED07447AB6AA4B237F913F9B18E53@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <DFEF91B22ED07447AB6AA4B237F913F9B18E53@ausx3mpc125.aus.amer.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070814154942.A544A2350CA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm... I've got a 0.95.  I'll try to get a Via EHCI 1.00 controller and
> make sure it's the same problem.

Yeah, for some reason way too many of the add-on PCI cards with
VIA chips use that pretty-broken VT6202 chip.  Ones with VT6212
are also available, and work a lot better.


> > Regarding the option to blacklist VIA in the module:
> > I would prefer blacklisting VIA by default but giving the module some
> > parameter like "honours inactive bit" to override this. 
> > 
> > Perhaps there are newer VIA Chips out there, that indeed do this and
> > some users trigger happy enough to test this. :) 
>
> That kernel parameter sounds like a reasonable idea to me.

Yes, IFF we know that the bug shows up in EHCI 1.00 chips rather than
just the already-known-to-be-buggy VT6202 chips.  (I think part of the
deal was that until the parts went through some conformance testing,
nobody could use the "1.0" label.  There were also a few small feature
updates and spec clarifications.  If anyone else shipped silicon in
volume that was as buggy as a VT6202, I didn't see any.)

I'd be happy to see a warning come out whenever a VT6202 is found,
since its problems are NOT limited to this I-bit bug.


>	The problem
> that the patch is trying to work around is that, while the CPUs are
> changing frequency, the EHCI controller gets delayed trying to read main
> memory (because CPU cache snoops have to wait until the CPU is
> finished)... if this happens in the middle of a split transaction to a
> low/full speed device, the transaction won't complete in time, and you
> get an error and possible data loss.
>
> If the EHCI controller caches ahead enough, it shouldn't need to read
> main memory to be able to complete the split transaction... but, while
> the controller does say how much ahead it may cache, it isn't clear to
> me that it will always be able to cache that much, so I thought it would
> be safe to go ahead and inactivate split transactions during CPU
> frequency transitions regardless.

Right.
