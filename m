Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab0APTaA (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 14:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809Ab0APT36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 14:29:58 -0500
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:31303 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751589Ab0APT35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 14:29:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aRGycOaB/WQJsFoZAJv27oVlk8i3MxeGtZjt2GxN8J2T2Ojm9JmGxqTKi2dlVvdc3tfv3yHQJ0lKzuC2+kA/C/Ajh+nQrxtu1WzooZkHxobdK4Ckn3qmnM+13Xg5mOC7ZekQe1IwRsAUs1hTPh2V48ToUJcETgXusBRPE8zbPtk=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: alt09IEVM1m3z_kZfqYG_QzaovNjySaj8J2yDvzTbXYnGek8sWaJLf62ae3dhCsrtPPtrvOAq7Mnmrj.XX8TKTo0MhcLP2lsB_1mageOQP8FiYB62N_N_3x3cMMUkfLTWaGvo46KjypJP_qIBRyQaJHequ_h51Qywm_S4KBTbVmHbZxybnW7w7VysAR6_2WJ1K9HdARCLVGaazuJdSyiWRWwLpiuycpYz5b2xullC_beJaun7xB35phBsBvfgTHVRTOjNVGb6W_tcUvNAtxJlYUlabso7LI3lNi2
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: flash_platform_data namespace collision
Date: Sat, 16 Jan 2010 11:23:15 -0800
User-Agent: KMail/1.9.10
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Mailing List <linux-kernel@vger.kernel.org>,
        "linux-embedded" <linux-embedded@vger.kernel.org>
References: <1263620475.29868.6280.camel@calx> <20100116110420.GB31282@flint.arm.linux.org.uk> <1263664079.29868.6289.camel@calx>
In-Reply-To: <1263664079.29868.6289.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001161123.15502.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 January 2010, Matt Mackall wrote:
> On Sat, 2010-01-16 at 11:04 +0000, Russell King wrote:
> > On Fri, Jan 15, 2010 at 11:41:15PM -0600, Matt Mackall wrote:
> > > I've got a board here with SPI, NOR, and NAND flash devices and I've
> > > just run into a namespace collision on flash_platform_data from
> > 
> > The one in arch/arm/include/asm/mach/flash.h is designed to have great
> > appeal and flexibility across different platforms, and indeed we have
> > at least 70 users across six different MTD NOR flash drivers and two
> > MTD NAND drivers.

Yet it doesn't do what's needed for SPI flash (identify the chip type,
when it can't probed); and for that application none of those methods
are useful (and their slots are just wasted/confusing space).


> > If anything, I believe that this header should move into linux/mtd/
> > and become a standard structure for platforms to communicate their
> > requirements to flash drivers.
> 
> Yeah, I think this is probably the way to go. Davids, any objections?

I had similar thoughts when I first happened across that structure.

But such a move wouldn't resolve $SUBJECT ... which is IMO best addressed
by the obvious rename of the one to spi_flash_platform_data.

- dave
