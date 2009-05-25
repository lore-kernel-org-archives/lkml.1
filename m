Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZEYJFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZEYJFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbZEYJFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:05:03 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:4810 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751117AbZEYJFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:05:01 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Date: Mon, 25 May 2009 11:04:47 +0200
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <pierre@ossman.eu>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200905201902.51377.david-b@pacbell.net>
In-Reply-To: <200905201902.51377.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905251104.47550.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Am Donnerstag, 21. Mai 2009 schrieb David Brownell:
> On Wednesday 20 May 2009, Pierre Ossman wrote:
> > >		 Remember that the
> > > firmware in the card can leverage "that's erased" knowledge for
> > > things like wear leveling.  SSDs and other storage devices would
> > > likewise benefit from such knowledge.  I'm quite certain there's
> > > been discussion about adding support for that in the block layer.
> >
> > It's already in AFAIK. I even had code for hooking it up to mmc_block.
> > But it didn't produce any measurable results so I never merged it.
>
> I'd expect the results would take time to show.  As in, they would
> facilitate wear leveling logic, which may be difficult to measure
> except by testing various cards to destruction ... even for vendors
> that *do* have decent wear leveling.  :)

Can someone please explain for me the purpose and the implementation of this 
wear level logic in block.c?

I can not see why a sector erase and the sector erase result codes of a MMC/SD 
card can be used to get any usefull information about wear leveling in the 
card. The mapping of physical to logical blocks is not reported by the card, 
and the number of erase cycles for each block is also not reported. SO how 
can the host be able to optimize the wear leveling?

As far as I can see, the best wear level handling for MMC/SD cards is to 
optimize the size of the chunks of data to write. I have posted a patch
(mmc_spi: speedup for slow cards, less wear-out), and it was accepted by 
Pierre at 11th of april.

best regards
 
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
