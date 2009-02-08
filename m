Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZBHU1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZBHU1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 15:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZBHU1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 15:27:08 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:39647 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752915AbZBHU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 15:27:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=s6cx5kIYh0pJf7bjUpI+cw3xvAjoqzcgsp2WMQEx1XyOsbBoQxGM49uqvKUyu0zbpkypoM/hlQwHogmDP6eKYLjckmrBlLmKT3Afa0pPATc8p7KtFnNTL2RCQTiluvpb8m1WkK69RDDEzT8zYXcV+zAHt3+Da6Sf7KxeOD96bs8=  ;
X-YMail-OSG: 8qKbAO8VM1nFv_I0qxOvrweG4K.OiBBLznn3lu.XRifqvv_bo0RK5Tg2lC6G3IN7N71gzAoH3O8tpY3AdtMlTdkhJIDWNWpbevBKv8BKRNsEgFGbCpE2Mg3yfhHOQ_vvjov4T0qoN9BYduDJzquHbXih
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH] OMAP: MMC: recover from transfer failures - Resend
Date: Sun, 8 Feb 2009 12:27:03 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, Jean Pihet <jpihet@mvista.com>,
       tony@atomide.com, ext-adrian.hunter@nokia.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       jarkko.lavinen@nokia.com, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
References: <20081207213617.10456.43951.stgit@localhost> <20090205121045.4022c319.akpm@linux-foundation.org> <alpine.DEB.2.00.0902051323090.8131@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.0902051323090.8131@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902081227.03526.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009, Paul Walmsley wrote:
> 
> > > +   while (OMAP_HSMMC_READ(host->base,
> > > +                   SYSCTL) & SRD)
> > > +           ;
> > 
> > Is a __raw_readl() sufficient to prevent the cpu from burning up here,
> > or should we add cpu_relax()?
> 
> The __raw_readl() should be sufficient.  The MMC controller is located on 
> the L4 CORE interconnect, so the round trip latency for the read from MMC 
> is at least 90 ns, while the CPU cycle time is only about 1 to 2 ns.

It's still good policy to have a cpu_relax() in
such loops.  Not that it'll do much on most ARMs,
but empty statements are in general worth avoiding.


