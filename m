Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYBPS7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYBPS7I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbYBPS64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:58:56 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:34594 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755002AbYBPS6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:58:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wlXz01bQl0kJpJEvIFHFuolI8o6knI4u2XbPo+aoGEec4h3lyodSVoZIqAmvlfesaUZxGI5VJIbZ2YauAeDJhCfkMqT4Xs1M5fk3APm0hzkQedY22Ms/viQBEfT63ulhOGs+h3xue7v9bxwdKh3vvfddg4RXCxMISg9QJgY7DYE=  ;
X-YMail-OSG: pW40RLMVM1n26GTfAVjzDqdwImynsFyhnc83Enkts7bKy0s6pGI3rvyTMtSceRI0YF.MSkT0KA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: spi transfer with zero length
Date: Sat, 16 Feb 2008 10:58:48 -0800
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20080216.230232.25478328.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080216.230232.25478328.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802161058.49473.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2008, Atsushi Nemoto wrote:
> Hi.  Is it legal to use zero for 'len' field of struct spi_transfer?
> I mean, len=0, tx_buf=rx_buf=NULL, delay_usecs!=0.

Yes that should work ... it's uncommon, but not illegal.  Some
controller drivers may even handle that right!

If the delay were zero and cs_change didn't indicate a need to
briefly deselect the chip, it might make sense to reject such
a NOP transfer.  But that's not the case you identify.


> Some SPI devices need slightly long delay before first CLK edge after
> CS assertion.

For future reference ... could you identify a few such devices,
and say what "long" is relative to the clock period?

Some folk have just slowed down the clock in such cases, but
that's rather sub-optimal.


> To achieve this, I think inserting using a zero length 
> transfer before real transfers.  But it seems some drivers do not
> handle this case properly.

Feel free to submit patches fixing those bugs.


> Is this driver's bug, or we need additional delay field in struct
> spi_device for such case?

I'd like to avoid new parameters to cover case that can already
be expressed in the programming interface.  Cases that can't be
expressed ... different issue.  I suspect any patches updating
timing parameters should use nanoseconds not microseconds, fwiw.

- Dave
