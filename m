Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZCEO5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZCEO5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZCEO4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:56:53 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:36977 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZCEO4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:56:52 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "scameron@beardog.cca.cpqcorp.net" <scameron@beardog.cca.cpqcorp.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "coldwell@redhat.com" <coldwell@redhat.com>,
       "hare@novell.com" <hare@novell.com>,
       ISS StorageDev <iss_storagedev@hp.com>
Date: Thu, 5 Mar 2009 14:55:57 +0000
Subject: RE: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Thread-Topic: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Thread-Index: AcmdVoxLf169VTROSWyyjIaug4XHqgAS7VPQ
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77885CA68EC7EC@GVW0547EXC.americas.hpqcorp.net>
References: <20090302145650.GW15340@beardog.cca.cpqcorp.net>
	<20090303153402A.fujita.tomonori@lab.ntt.co.jp>
	<20090303162821.GB15340@beardog.cca.cpqcorp.net>
 <20090305144843N.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090305144843N.fujita.tomonori@lab.ntt.co.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> We have /sys/class/scsi_host/host*/sg_tablesize:
> 
> How about modifying this value on the fly?
> 
> fujita@clover:/sys/class/scsi_host/host3$ echo 1000 > sg_tablesize
> 
> 
> Well, this needs more changes (to both the block layer and 
> the scsi mid layer) but is it nice to change this value dynamically?
> 
> Anyway, I think that it's better to address this fancy 
> feature later on (after the mainline inclusion). Let's put 
> hpsa driver into mainline first.
> 
> 
> > > > Hmm, this doesn't seem all that complicated to me, and 
> this code 
> > > > snippet has been pretty stable for about 10 years. it's nearly 
> > > > identical to what's in cpqarray in the 2.2.13 kernel from 1999:
> > > > 
> > > >                 do {
> > > >                         i = 
> find_first_zero_bit(h->cmd_pool_bits, NR_CMDS);
> > > >                         if (i == NR_CMDS)
> > > >                                 return NULL;
> > > >                 } while(test_and_set_bit(i%32, 
> > > > h->cmd_pool_bits+(i/32)) != 0)
> > > > 
> > > > It's fast, works well, and has needed very little 
> maintenance over 
> > > > the years.  Without knowing what you have in mind 
> specifically, I 
> > > > don't see a big need to change this.
> > > 
> > > I see. Seems that some drivers want something similar. I 
> might come 
> > > back later on with a patch to replace this with library functions.
> > 
> > There was some other discussion about pushing this sort of thing to 
> > upper layers, using a tag generated in the scsi layer as a means of 
> > allocating driver command buffers, since, presumably 
> there's a one to 
> > one mapping.  (I didn't completely grok it all though.)
> 
> Oops, I meant that I might come back with a patch to convert 
> hpsa to use the the block layer tagging, which you and Mike 
> Christie are talking about (yeah, my first suggestion to use 
> lists was wrong. using the block layer tagging looks much better).
> 
> 
> By the way, have you guys started to work on the review 
> comments for the next submission? The driver has some minor 
> style issues that have not been mentioned yet. For example, 
> the comment style in the driver is not preferred:
> 
> /* If this device a non-zero lun of a multi-lun device */
> /* byte 4 of the 8-byte LUN addr will contain the logical */
> /* unit no, zero otherise. */
> 
> The preferred style is:
> 
> /*
>  * If this device a non-zero lun of a multi-lun device
>  * byte 4 of the 8-byte LUN addr will contain the logical
>  * unit no, zero otherise.
>  */
> 
> Another example, I think that the SCSI-ml preferred style is 
> (not documented in CodingStyle though):
> 
> 'if (!ptr)' rather than 'if (ptr == NULL)'
> 'if (!value)' rather than 'if (value == 0)'
> 'if (ptr)' rather than 'if (ptr != NULL)'
> 'if (value)' rather than 'if (value != 0)'
> 
> 
> If you are already addressing the review comments, I just 
> wait for the next submission, then I'll send such minor 
> patches. If you are not, I'll send patches to address the 
> review comments (including such minor patches).
> 

We're working on the review comments. Right we're trying to get caught up with our "day jobs."

-- mikem