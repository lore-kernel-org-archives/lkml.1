Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYGXM2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYGXM2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYGXM2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:28:36 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:59723 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYGXM2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:28:35 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48887576.1040901@cam.ac.uk>
Date: Thu, 24 Jul 2008 13:28:38 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Hans J. Koch" <hjk@linutronix.de>, mgross@linux.intel.com, hmh@hmh.eng.br,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
 accelerometers etc)
References: <488763AD.4050400@gmail.com>	<20080723191918.GC26938@trinity.fluff.org>	<20080724074124.GB2254@local> <20080724101957.75bf03e0@lxorguk.ukuu.org.uk>
In-Reply-To: <20080724101957.75bf03e0@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> hwmon is designed for slow I/O. It won't handle an ADC that does a few
>> megasamples/sec.
> 
> At that rate I would assume you want a memory mapped ring buffer or
> similar not a sysfs style interface ?
Agreed, this isn't going to do megsamps per second either (at least not
without a fair bit faster processor  / memory than available in embedded
architectures).  If you want to go at those rates you'll need something
with a hardware ring buffer or an intermediate chip to provide said
buffering whilst not trying to run a general purpose os at the same time.

I am considering adding a 'burst' mode which would use up any available
i2c / spi hardware buffers to get somewhere nearer to those sort of speeds.

One of the most important elements of this subsystem is indeed a ring
buffer architecture, currently not mmapped. I'm still trying to work out
how to make that work without blocking the ring filling on interrupts.
Currently I can only seem to get around this by doing copies of ring
to mmapped locations and having some dirty bit type marking of regions
that don't contain valid data.  I guess suitable userspace libraries
could hide this mess though.

For the few ksps range the current chrdev interface is adequate if not
ideal.

The ring achitecture is one of the areas that probably needs most work.

Thanks,
--
Jonathan Cameron
