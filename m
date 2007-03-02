Return-Path: <linux-kernel-owner+w=401wt.eu-S2992738AbXCBXar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992738AbXCBXar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992741AbXCBXar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:30:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49784
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992738AbXCBXaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:30:46 -0500
Date: Fri, 02 Mar 2007 15:30:45 -0800 (PST)
Message-Id: <20070302.153045.71090285.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       andreas.friedrich@fujitsu-siemens.com, tglx@linutronix.de,
       dwalker@mvista.com
Subject: Re: [PATCH -mm][Take 2] clocksource init adjustments (fix bug
 #7426)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1172877840.5449.39.camel@localhost.localdomain>
References: <1172865491.5449.13.camel@localhost.localdomain>
	<20070302.123202.11628478.davem@davemloft.net>
	<1172877840.5449.39.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>
Date: Fri, 02 Mar 2007 15:24:00 -0800

> On Fri, 2007-03-02 at 12:32 -0800, David Miller wrote:
> > From: john stultz <johnstul@us.ibm.com>
> > Date: Fri, 02 Mar 2007 11:58:11 -0800
> > 
> > > Oh! Sorry! Yea, looking at it more the ioremap isn't actually necessary,
> > > as we can use hpet_readl() instead of re-calculating the hpet base
> > > address pointer.
> > > 
> > > I'll fix this up (and find an HPET enabled x86_64 box to test it on) and
> > > get a patch to you shortly.
> > 
> > Not to pressure you John but I'd really like to see this go
> > in soon, it does fix real bugs such as the Radeon FB issue
> > I pointed out the other week.
> 
> Here's my second try at this. This time I caught three bugs from the
> last patch (all in x86_64):
> 1) Calling ioremap too early in the HPET code (which is unnecessary)
> 2) hpet_period local variable aliasing
> 3) forgot to re-add call to init_tsc_clocksource()
> 
> I boot tested on two x86_64 boxes (one ACPI PM and the other HPET).
> However it probably should still go through a bit of testing in -mm to
> make sure all the quirks are shaken out.

Agreed and it looks good to me after going over it a few times.
