Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbXEPB4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbXEPB4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 21:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXEPB4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 21:56:38 -0400
Received: from 203-97-71-235.dsl.clear.net.nz ([203.97.71.235]:3542 "EHLO
	gazelle.ad.endace.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754287AbXEPB4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 21:56:37 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
Date: Wed, 16 May 2007 13:56:35 +1200
Message-ID: <659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
In-Reply-To: <17994.19043.771733.453896@notabene.brown>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Software raid0 will crash the file-system, when each disk is 5TB
Thread-Index: AceXTcFW+KmsvQXxRgmH+yvfHOe65QAD6oaQ
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com><6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com> <17994.19043.771733.453896@notabene.brown>
From: "Jeff Zheng" <Jeff.Zheng@endace.com>
To: "Neil Brown" <neilb@suse.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-raid@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the information of the created raid0. Hope it is enough.

Jeff

The crashing one:
md: bind<sdd>
md: bind<sde>
md: raid0 personality registered for level 0
md0: setting max_sectors to 4096, segment boundary to 1048575
raid0: looking at sde
raid0:   comparing sde(5859284992) with sde(5859284992)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sdd
raid0:   comparing sdd(5859284992) with sde(5859284992)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 11718569984 blocks.
raid0 : conf->hash_spacing is 11718569984 blocks.
raid0 : nb_zone is 2.
raid0 : Allocating 8 bytes for hash.
JFS: nTxBlock = 8192, nTxLock = 65536

The working one:
md: bind<sde>
md: bind<sdf>
md: bind<sdg>
md: bind<sdd>
md0: setting max_sectors to 4096, segment boundary to 1048575
raid0: looking at sdd
raid0:   comparing sdd(2929641472) with sdd(2929641472)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sdg
raid0:   comparing sdg(2929641472) with sdd(2929641472)
raid0:   EQUAL
raid0: looking at sdf
raid0:   comparing sdf(2929641472) with sdd(2929641472)
raid0:   EQUAL
raid0: looking at sde
raid0:   comparing sde(2929641472) with sdd(2929641472)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 11718565888 blocks.
raid0 : conf->hash_spacing is 11718565888 blocks.
raid0 : nb_zone is 2.
raid0 : Allocating 8 bytes for hash.
JFS: nTxBlock = 8192, nTxLock = 65536

-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Wednesday, 16 May 2007 12:04 p.m.
To: Michal Piotrowski
Cc: Jeff Zheng; Ingo Molnar; linux-raid@vger.kernel.org;
linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org
Subject: Re: Software raid0 will crash the file-system, when each disk
is 5TB

On Wednesday May 16, michal.k.k.piotrowski@gmail.com wrote:
> >
> > Anybody have a clue?
> >

No...
When a raid0 array is assemble, quite a lot of message get printed
about number of zones and hash_spacing etc.  Can you collect and post
those.  Both for the failing case (2*5.5T) and the working case
(4*2.55T) is possible.

NeilBrown
