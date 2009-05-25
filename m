Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbZEYKSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbZEYKSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZEYKSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:18:30 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:5013 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751649AbZEYKS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:18:29 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Date: Mon, 25 May 2009 12:18:18 +0200
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <pierre@ossman.eu>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200905250243.46984.david-b@pacbell.net>
In-Reply-To: <200905250243.46984.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905251218.18262.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Am Montag, 25. Mai 2009 schrieb David Brownell:
> It can't.  But when the card controller knows that for example
> certain logical blocks are not holding data, it can use that
> for wear leveling ... it's got more physical blocks to use to
> even out the writes, as well as having any records it kept on
> writes, reads, and erasures.

OK. So the block layer is issuing erase commands for all sectors which get 
unused, to let the mmc/sd card controller know that these areas are unused.

Are these erase commands requests (as reads and writes)? I suppose...

So if this code gets integrated, we can do:

if (command is erase)
	accept erase response codes
else
	treat erase response codes as transmission errors

Should be no problem...

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
