Return-Path: <linux-kernel-owner+w=401wt.eu-S935318AbYBCI0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935318AbYBCI0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 03:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbYBCI0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 03:26:09 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:24209 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753558AbYBCI0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 03:26:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rupsgSZ580YOM7ftshtnwI6wXOCFW7kJmxSP1VaRAzuzKkfKbX+F7oR3V8y/2xnDsJPqR/DZpDRWRbnFHmqe052iP5/YZG3E9f1/hfTOwNV4CX80v5O9RyjpUUuYT6ICO9Azvzv7KqtMHBW/1EJ0blc8MmvwrUR6DibUn3dhgDg=  ;
X-YMail-OSG: vWtTVL8VM1kLYgefmP_AVqFwmBZNhLxPu96chtIpCOQNMtGuxuvSalcpdAcV8nC3KDnTFMQRog--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [linux-pm] sleepy linux self-test
Date: Sun, 3 Feb 2008 00:26:02 -0800
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <20080130131748.GA3796@elf.ucw.cz> <200802022318.03597.david-b@pacbell.net> <20080203075111.GB19981@uranus.ravnborg.org>
In-Reply-To: <20080203075111.GB19981@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802030026.03249.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008, Sam Ravnborg wrote:
> > --- g26.orig/drivers/char/Kconfig
> > +++ g26/drivers/char/Kconfig
> > @@ -715,9 +715,12 @@ config NVRAM
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called nvram.
> >  
> > +comment "You are using the RTC framework, not the legacy CMOS RTC driver"
> > +	depends on RTC_DRV_CMOS
> > +
> >  config RTC
> >  	tristate "Enhanced Real Time Clock Support"
> > -	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390
> > +	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390 && !RTC_DRV_CMOS
> 
> This looks like a prime candidate for a HAVE_RTC config variable

In drivers/rtc/Kconfig there's *currently* a list of about
three dozen (!) different RTC drivers ... some of which support
quite a few different variants.

I'd be glad to see someone clean up the config mess with respect
to systems using MC146818 compatible chips, but that shouldn't
begin by assuming the numerous non-MC146818 chips are somehow
not real RTCs.  ;)

- Dave




