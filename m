Return-Path: <linux-kernel-owner+w=401wt.eu-S971217AbXILRn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971217AbXILRn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968397AbXILRmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:42:55 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:33560 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1765640AbXILRmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:42:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LNxyEdeCi+SWj84FSQs8dNe5Xtm28W9cb4NwwmAX/+kvC1bAGy9O6rFwEQ7hHWPE3IkqmB26l9D9vU7ok0rkrkV5uRT7wYoWIHevfEJPfpHEv39JnX3Y3fF+nKLBTDEtlrUC3kzqTVtHrWbtyr9l26iNWJL0FP9OowgOdFJVYno=  ;
X-YMail-OSG: rDfRISEVM1klpJNUrxKYjtqIcv0yJ6WOYXqX1ezFReV92jmTQtszaHlw7ywKgkBOPApAFA5ePA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Greg KH <greg@kroah.com>
Subject: Re: SYSFS: need a noncaching read
Date: Wed, 12 Sep 2007 05:19:39 +1000
User-Agent: KMail/1.9.5
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, Heiko Schocher <hs@denx.de>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Detlev Zundel <dzu@denx.de>
References: <1189503798.6674.46.camel@Zeus.EmbLux> <20070912053207.GH23573@pengutronix.de> <20070912100123.GA23182@kroah.com>
In-Reply-To: <20070912100123.GA23182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709120519.39960.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 20:01, Greg KH wrote:
> On Wed, Sep 12, 2007 at 07:32:07AM +0200, Robert Schwebel wrote:
> > On Tue, Sep 11, 2007 at 11:43:17AM +0200, Heiko Schocher wrote:
> > > I have developed a device driver and use the sysFS to export some
> > > registers to userspace.
> >
> > Uuuh, uggly. Don't do that. Device drivers are there to abstract things,
> > not to play around with registers from userspace.
> >
> > > I opened the sysFS File for one register and did some reads from this
> > > File, but I alwas becoming the same value from the register, whats not
> > > OK, because they are changing. So I found out that the sysFS caches
> > > the reads ... :-(
> >
> > Yes, it does. What you can do is close()ing the file handle between
> > accesses, which makes it work but is slow.
>
> Do an lseek back to 0 and then re-read, you will get called in your
> driver again.

Can you do a pread with offset 0 to avoid the two syscalls? (which some
people seem to be concerned about)
