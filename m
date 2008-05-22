Return-Path: <linux-kernel-owner+w=401wt.eu-S1765708AbYEVDjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765708AbYEVDjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 23:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757927AbYEVDi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 23:38:29 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:36103 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757107AbYEVDi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 23:38:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Jb8rdPo9cXW50Zrk61bwgfZQrpm0qhjlhxxDbsuG6InIR3nCOAsLoPY6bUoRHO6KgEMbqerv5ig2DMdOKJZC2y54d7vBGArXbJ1LIj9KMdZgE6y/KLx3O7j6Un/Xtl/zBPicDxsV0stvqebEGqqgcvtm08ZIVzTk3PDdOjqZL1A=  ;
X-YMail-OSG: .kegTlYVM1lJMIANp3UgSgU8gM0mL2D_BxfMoeZu7ss3cKLv.5rtHrQxHzhsEziPvvGD.YzM3xnf1tfDRlsC73e12T1okHklmQomOF.hQrOT_EX5u5OPPz3IxAUuHGSU0YA-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: mgross@linux.intel.com
Subject: Re: Accelerometer, Gyros and ADC's etc within the kernel.
Date: Wed, 21 May 2008 17:53:38 -0700
User-Agent: KMail/1.9.9
Cc: spi-devel-general@lists.sourceforge.net,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>
References: <4832A211.4040206@gmail.com> <20080520175041.GA30909@linux.intel.com>
In-Reply-To: <20080520175041.GA30909@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805211753.39133.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2008, mark gross wrote:
> > ST Micro LIS3L02DQ 3D accelerometer.  ...
> 
> FWIW: I have this device talking to a PIC-18 and pushing the results
> over the serial port.

Jonathan neglected to mention that he's already sent a driver
for this to the SPI list.  ;)

Which is part of the reason for asking this question.  Right
now that driver sits in drivers/spi/lis3l02dq.c but that is
probably not its best long-term domicile.


> WRT linux support, I can't think of a generalized way to create a driver
> that would be able to be used with this device in Linux.  You need to
> know witch IRQ line the DR line is connected too, and if you are
> bit-banging the SPI data off the thing, then you need to know which
> GPIO's of the host CPU you'll be using.  If you have SPI hardware then
> you need to know where to pull the data from.  The problem doesn't seem to
> generalize well.

I guess I don't follow.  The SPI framework handles all that
stuff already, even if you're bitbanging.  Though to be
sure, if you're bitbanging SPI you want your platform to
be able to inline those GPIO calls so those inner loops
only take a few instructions per bit ... also solved!  :)


> Also, If you are playing with accelerometer data, you likely need some
> real time support or at lest a reliable time stamping of the data to do
> anything interesting.

True.  I imagine a few other such issues will appear once
more folk than Jonathan are using these sorts of sensors
on Linux.  I'd expect the sample stream to have internal
timestamps for truly critical systems, unless variability
in when the host makes timestamps is not really an issue.
 

> Another problem area is around SPI itself.  There are variations of
> device implementations around chip select polarity, clock biasing
> (rising,falling, or midpoint) sampling from one SPI part to the next.

Midpoint?  That's not one I've come across before.  All four
standard SPI clock/sample/shift modes are already supported
in the SPI framework though.  Ditto active-high chipselects
(vs normal active-low) etc.

- Dave
