Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZHMREP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZHMREP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbZHMREP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:04:15 -0400
Received: from relais.videotron.ca ([24.201.245.36]:54189 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZHMREO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:04:14 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 13 Aug 2009 13:03:56 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>, Pierre Ossman <pierre@ossman.eu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "nicolas.ferre@rfo.atmel.com" <nicolas.ferre@rfo.atmel.com>,
       "hskinnemoen@atmel.com" <hskinnemoen@atmel.com>,
       "tony@atomide.com" <tony@atomide.com>,
       "david-b@pacbell.net" <david-b@pacbell.net>,
       "manuel.lauss@gmail.com" <manuel.lauss@gmail.com>,
       "mirq-linux@rere.qmqm.pl" <mirq-linux@rere.qmqm.pl>,
       "ppisa@pikron.com" <ppisa@pikron.com>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "ben@fluff.org" <ben@fluff.org>,
       "saschasommer@freenet.de" <saschasommer@freenet.de>,
       "avorontsov@ru.mvista.com" <avorontsov@ru.mvista.com>,
       "oakad@yahoo.com" <oakad@yahoo.com>,
       "ian@mnementh.co.uk" <ian@mnementh.co.uk>,
       "HaraldWelte@viatech.com" <HaraldWelte@viatech.com>,
       "JosephChan@via.com.tw" <JosephChan@via.com.tw>
Subject: Re: New MMC maintainer needed
In-reply-to: <4A83BA65.1080608@nokia.com>
Message-id: <alpine.LFD.2.00.0908131249340.10633@xanadu.home>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
 <20090722151744.fffd7bf5.akpm@linux-foundation.org>
 <20090728222334.0c543c47@mjolnir.ossman.eu>
 <20090731122623.254fd0f1@mjolnir.ossman.eu>
 <20090731105407.GA31900@console-pimps.org>
 <20090803123429.390a636f@mjolnir.ossman.eu> <4A76C658.6050002@nokia.com>
 <20090811140223.GA4278@console-pimps.org> <4A83BA65.1080608@nokia.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Adrian Hunter wrote:

> Results in microseconds:
> 
> 	before		after
> eMMC	194145		193641
> uSD	4143		2129
> 
> However, that excludes powering up.  For example the pbias setting
> on omap_hsmmc for MMC1 (uSD for us) has a 100ms delay.
> 
> So the difference is negligible.

I therefore tend to agree with Pierre and Andrew.  This doesn't make 
enough of a difference to increase the complexity and maintenance cost 
of the code for such a trivial improvement.

> Although, the notion of unnecessarily sending SDIO commands
> to an uSD, and SDIO and SD commands to an eMMC, seems wrong.
> Especially when trying to debug very-hard-to-reproduce errors.

Simply commenting out the SD/SDIO or MMC probe call in the code is 
very simple when you're debugging.  Then if you actually come to the 
conclusion that some real bugs are due to this cross probe and can prove 
it then we might reconsider.

Currently, generic host drivers are sometimes used in the context of a 
uSD slot, sometimes in the context of a SD/SDIO/MMC slot, sometimes with 
a hardwired SDIO based chip soldered on the board, and they don't need 
any special flags to distinguish between those use cases.  This greatly 
helps maintainability, and that should prevail over slight latency 
improvements to non timing critical events such as card insertion.


Nicolas
