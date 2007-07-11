Return-Path: <linux-kernel-owner+w=401wt.eu-S934667AbXGKWpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667AbXGKWpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762113AbXGKWpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:45:13 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:21961 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759683AbXGKWpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:45:10 -0400
Message-ID: <46955D45.8010606@emc.com>
Date: Wed, 11 Jul 2007 18:44:21 -0400
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Tejun Heo <htejun@gmail.com>, david@lang.hm,
       Stefan Bader <Stefan.Bader@de.ibm.com>, Phillip Susi <psusi@cfl.rr.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528094358.GM25091@agk.fab.redhat.com> <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com> <20070529220500.GA6513@agk.fab.redhat.com> <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com> <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com> <465F9197.7060002@gmail.com> <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm> <465FC7B1.3060309@gmail.com>            <4693D26D.2060004@emc.com> <4758.1184110800@turing-police.cc.vt.edu>
In-Reply-To: <4758.1184110800@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.7.6.21134
X-PerlMx-Spam: Gauge=, SPAM=1%, Reasons='EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Valdis.Kletnieks@vt.edu wrote:
> On Tue, 10 Jul 2007 14:39:41 EDT, Ric Wheeler said:
> 
>> All of the high end arrays have non-volatile cache (read, on power loss, it is a 
>> promise that it will get all of your data out to permanent storage). You don't 
>> need to ask this kind of array to drain the cache. In fact, it might just ignore 
>> you if you send it that kind of request ;-)
> 
> OK, I'll bite - how does the kernel know whether the other end of that
> fiberchannel cable is attached to a DMX-3 or to some no-name product that
> may not have the same assurances?  Is there a "I'm a high-end array" bit
> in the sense data that I'm unaware of?
> 

There are ways to query devices (think of hdparm -I in S-ATA/P-ATA drives, SCSI 
has similar queries) to see what kind of device you are talking to. I am not 
sure it is worth the trouble to do any automatic detection/handling of this.

In this specific case, it is more a case of when you attach a high end (or 
mid-tier) device to a server, you should configure it without barriers for its 
exported LUNs.

ric
