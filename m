Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZESLsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZESLsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZESLsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:48:09 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:11785 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752060AbZESLsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:48:08 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Matt Fleming" <matt@console-pimps.org>
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Date: Tue, 19 May 2009 13:47:45 +0200
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <20090519112948.GB28564@console-pimps.org>
In-Reply-To: <20090519112948.GB28564@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905191347.46026.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

Am Dienstag, 19. Mai 2009 schrieb Matt Fleming:
> On Thu, May 14, 2009 at 12:24:27PM +0100, Wolfgang Mües wrote:
> > o This patch changes the reported error code for the responses
> >   to a command from EINVAL/EIO to EILSEQ

> Hmm, always returning -EILSEQ is devious. What happens if we sent an
> illegal command?
Isn't this a theoretical question?
Sending an illegal command will never work. Even the programmer of this piece 
of software will notice, and such a software will not find it's way into the 
kernel.

And IF it would, and really it's an illegal command, then it does no harm if 
it is retried several times. It will never work.

Matt, I do not like this patch either.

But given the fact that a response is NOT checksum-protected, there is NO WAY 
we can tell if the received response is a transmission error or a real error 
code from the SD/MMC card.

My first patch has not changed the error codes in mmc_spi, but only changed 
the actions in block.c.

But Pierre has objected against this: he stated that EINVAL is used by all 
(non-SPI) drivers only for true non-recoverable errors, and requested that 
another error code should be used by the mmc_spi driver. The apropriate code 
for transmission errors is EILSEQ.

Maybe a solution-in-the-middle is to use different error codes in the mmc_spi 
framework, which allows to differentiate between individual response codes, 
and treat them all as transmission errors in block.c. What error codes can we 
choose?

> IMHO always assuming that command errors are caused by transmission
> problems is not the right solution.

It's not your or my fault, it's the fault of the spi SD/MMC card protocol 
designer. You may send him to me, already prepared: naked and in chains ;-)

regards
 
i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
