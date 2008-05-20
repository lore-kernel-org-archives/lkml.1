Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbYETOPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbYETOPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbYETOPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:15:01 -0400
Received: from mail.macqel.be ([194.78.208.39]:24003 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655AbYETOPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:15:00 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 10:14:59 EDT
Date: Tue, 20 May 2008 16:07:44 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: powerpc + i2c/rtc : where is the 11 min update ?
Message-ID: <20080520140744.GA6427@frolo.macqel>
References: <20080520105844.GA694@frolo.macqel> <18482.45473.866954.385654@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18482.45473.866954.385654@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing lkml

On Tue, May 20, 2008 at 09:10:25PM +1000, Paul Mackerras wrote:
> Philippe De Muyter writes:
> 
> > I have a ARCH=powerpc linux-2.6.25-rc6 linux running with an i2c rtc chip,
> > and synchronized to a ntp server.
> > 
> > I noticed that my rtc chip does not get updated by the kernel, just like
> > it would be on all other architectures (included ppc).
> 
> That is now supposed to be done by the code inside #ifdef
> CONFIG_GENERIC_CMOS_UPDATE in kernel/time/ntp.c.
> 
> Paul.

Thanks.  I agree that is a good place.

But, here CONFIG_GENERIC_CMOS_UPDATE is defined and an i2c clock also,
and my rtc clock is not updated.  I see kernel/time/ntp.c::sync_cmos_clock
calling arch/powerpc/kernel/time.c::update_persistent_clock, where
ppc_md.set_rtc_time is NULL.

Who is supposed to initialize ppc_md.set_rtc_time to use an i2c clock and
when in the boot process may that happen ?

Or alternatively, should update_persistent_clock not be part of the rtc
subsystem ?

Philippe
