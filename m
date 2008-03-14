Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYCNBzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYCNBzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYCNByx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:54:53 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:34242 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752116AbYCNByw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:54:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HTbCYYW4S+USNJf9MbTyklT36hFcwTrnPKoCIRaj/R5McOcs3v+RnZ6OKKNNfdf6JpGpMJnRnn4UmUkIi2Omo5R1rMLb1mjxPSlBBXOe1eirgmy1xG4sIpfAI+tBteE2+AIaSYw4rVlFH9pMSUAsSERSfq2lZIRor8YBmvQQIMM=  ;
X-YMail-OSG: 86ItXSMVM1lEdK7mQUzJCdNsH0GfgOvye8urITGD9brd6QAkq7IcGOFFHBGISkjZLFAWjDV_Pg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.25-rc5 1/2] gpiolib:  dynamic gpio number allocation
Date: Thu, 13 Mar 2008 17:54:44 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, avorontsov@ru.mvista.com
References: <200803131549.54632.david-b@pacbell.net> <200803131618.58516.david-b@pacbell.net> <20080313162803.ab8bfd4c.akpm@linux-foundation.org>
In-Reply-To: <20080313162803.ab8bfd4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131854.45035.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, Andrew Morton wrote:

> > > Shouldn't ARCH_NR_GPIOS be CONFIG_NR_GPIOS?
> > 
> > No more than NR_IRQS is settable via Kconfig.  And for
> > rather similar reasons.  :)
> 
> What are those reasons?

Keeping a lid on the amount of space wasted by unused
table entries is one factor; it's an implementation
tradeoff.  In normal usage the number of IRQs (or GPIOs)
is defined by the board (or system) design, and there's
no real point to allowing more.

That said, NR_IRQS is kind of inflexible.  It's not easy
to provide board-specific overrides for cases like having
a few FPGAs or other external IRQ (or GPIO!) controllers
which chain IRQs and plug into those tables...

Both could use a way to extend a platform-defined minimum
to support a configurable number of external controllers.
Lacking that, both have somewhat ad-hoc solutions to make
sure board variants can be set up with the same kernel.
It basically boils down to making sure there are some extra
entries at end-of-table, and policies to allocate them.

- Dave


