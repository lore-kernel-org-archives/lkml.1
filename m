Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbZI1Qli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbZI1Qli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbZI1Qli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:41:38 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:63125 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZI1Qlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oohRpfCrk4K9wr+gnHJZF6XnvxBCIlPgBzeFO+vNDJ4FEltVb0NiDeWSyoavladQDp
         ny9zqbHd/zi45UmSvVtPCGoW0EcnOMEW2kJXf2aGMYG2O/Cks7wTcbBEgrd9RXmj+Nb9
         7KRgQ7/+Zgl3HSjInD+p9TTq3XZGMtiZVXY6Q=
Date: Mon, 28 Sep 2009 20:41:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31: booting on a PIII Celeron?
Message-ID: <20090928164137.GG5264@lenovo>
References: <4AC0D59F.8000502@msgid.tls.msk.ru> <4AC0D651.7030009@msgid.tls.msk.ru> <20090928163617.GA25503@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928163617.GA25503@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pavel Machek - Mon, Sep 28, 2009 at 06:36:17PM +0200]
| > Michael Tokarev wrote:
| > >Hello.
| > >I've a problem here with 2.6.31.  kernel is
| > >compiled for PIII:
| > >
| > > CONFIG_MPENTIUMIII=y
| > > CONFIG_X86_GENERIC=y
| > >
| > >This kernel works on real PIII machine - like this:
| > >
| > >vendor_id    : GenuineIntel
| > >cpu family    : 6
| > >model        : 8
| > >model name    : Pentium III (Coppermine)
| > >stepping    : 10
| > >cpu MHz        : 997.580
| > >
| > >But it fails on a Celeron:
| > >
| > >vendor_id    : GenuineIntel
| > >cpu family    : 6
| > >model        : 8
| > >model name    : Celeron (Coppermine)
| > >stepping    : 6
| > >cpu MHz        : 797.481
| > >
| > 
| > There's one more difference between the two:
| > 
| > PIII, working:
| > flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pse36 
| > mmx fxsr sse up
| > Celeron, !working:
| > flags: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pse36 mmx 
| > fxsr sse up
| > 
| > So the celeron machine lacks "apic" flag.  And in my
| > kernel config, apic is enabled:
| >  CONFIG_X86_LOCAL_APIC=y
| >  CONFIG_X86_IO_APIC=y
| > (but not on the command line like apic=force)
| try 'noapic nolapic' to see if it helps?
| 

yeah good point Pavel, at moment the code checks for cpu family/stepping
but if the "nolapic" option will help -- definitely sonething screwed :(
Michael, please give it a try.

| -- 
| (english) http://www.livejournal.com/~pavelmachek
| (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
| 
	-- Cyrill
