Return-Path: <linux-kernel-owner+w=401wt.eu-S1762167AbYFETnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762167AbYFETnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYFETnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:43:06 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:34612 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751402AbYFETnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:43:04 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 15:43:04 EDT
X-YMail-OSG: BSbE9BIVM1mlWl9Epl_9kzwGk3E1vkhldLSLzbopTn5dnJQeqn6H2BTPoacQd83v5GT5uB7i232k9y3Ljcse3FQ89UO.2GoyXnz1F1icju2PPvusJ6brhBsnA8Fwu88zDUQ-
X-Yahoo-Newman-Property: ymail-3
Subject: RE: Vpools and v3.0-UPSTREAM LIO
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Ross S. W. Walker" <rwalker@medallion.com>
Cc: Jerome Martin <tramjoe.merin@gmail.com>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <E2BB8074E5500C42984D980D4BD78EF9022A7243@MFG-NYC-EXCH2.mfg.prv>
References: <48458C69.9080102@aol.com> <4845A090.4090207@openfiler.com>
	 <E2BB8074E5500C42984D980D4BD78EF9022A7230@MFG-NYC-EXCH2.mfg.prv>
	 <4845D124.7060806@openfiler.com>
	 <1212641917.2194.12.camel@haakon2.linux-iscsi.org>
	 <1212644790.2194.28.camel@haakon2.linux-iscsi.org>
	 <E2BB8074E5500C42984D980D4BD78EF9022A723F@MFG-NYC-EXCH2.mfg.prv>
	 <1212684587.2194.41.camel@haakon2.linux-iscsi.org>
	 <1b89d2180806050959sd2eeb98i1d4441cca81e2842@mail.gmail.com>
	 <E2BB8074E5500C42984D980D4BD78EF9022A7242@MFG-NYC-EXCH2.mfg.prv>
	 <1b89d2180806051101v52cec4c7lf3a4c665833fe62a@mail.gmail.com>
	 <E2BB8074E5500C42984D980D4BD78EF9022A7243@MFG-NYC-EXCH2.mfg.prv>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 12:36:20 -0700
Message-Id: <1212694580.2194.63.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 14:28 -0400, Ross S. W. Walker wrote:
> Jerome Martin wrote:
> 
> > On Thu, Jun 5, 2008 at 5:39 PM, Ross S. W. Walker 
> > <rwalker@medallion.com> wrote:
> > 
> > 
> > 	How about something like "ipool"?
> > 	
> > 	Maybe if I had a better picture of what it is your trying to
> > 	achieve I can throw some better suggestions out too?
> > 	
> > 
> > 
> > Well, basically the idea is to have a cluster of machines 
> > driven by heartbeatv2 (pacemaker)  implementing "storage" and 
> > "vhost" roles for arbitrary nodes. The storage part is based 
> > on lvm + drbd + lio-target  + open/iSCSI + ext3 (ocfs2 
> > planned for v2). The vhost part is based on linux-vservers, 
> > with plans to add vmware server in v2 and then maybe 
> > xen/openVZ depending on contribs. The term "pool" relates to 
> > the fact that the vservers are "pooled" by storage chunks, 
> > and the "v" stands for vservers. The effect is "Vserver POOLS".
> 
> How about a "stateless" storage pool where each node knows
> nothing about any other node in the storage pool.
> 
> You have central servers that then organize each node in
> the pool by available storage, performance of that storage,
> etc.

Having central servers (and having to worry about the redundancy of said
servers) would increase the complexity a great deal I would think.  

>  The storage is then mapped out based on these 
> characteristics, redundancy and striping is handled in
> the mapping, also based on performance characteristics
> and served up to servers that need it.
> 

Hmmm, so what are the advantages what we have working so far..?  

> > An other property of that cluster scheme is that it is 
> > designed to work at N+M redundancy (N active, M spares per 
> > resource). That could be used for devising a name too.
> > 
> > I'm currently trying to find some acronym based on the 
> > software stack used :
> > - DRBD
> > - iSCSI (LIO-target, no other target being able to fullfill 
> > the project requirements, and either open/iSCSI or core iscsi)
> > - virtual servers (to stay implementation-agnostic)
> > - linux-ha / pacemaker (the actual heartbeat part is 
> > non-essential, will be replaced by openAIS in v2 I think)
> > 
> > So maybe something like funny combinations like "DIVHA, 
> > software that sings" or  "PAID, free software" or anything 
> > along those lines would work :-) To be honest, I liked 
> > "vpools", and don't really have a good idea yet. 
> 
> How about DIVA?
> 
> This product can be added on to already existing iSCSI
> infrastructures and provides integrated high-level
> storage management services that would otherwise
> require separate products.
> 

Hmm, not bad.  I usually have to go for a walk or two to come up with
good project names.. :-)

--nab

> -Ross
> 
> ______________________________________________________________________
> This e-mail, and any attachments thereto, is intended only for use by
> the addressee(s) named herein and may contain legally privileged
> and/or confidential information. If you are not the intended recipient
> of this e-mail, you are hereby notified that any dissemination,
> distribution or copying of this e-mail, and any attachments thereto,
> is strictly prohibited. If you have received this e-mail in error,
> please immediately notify the sender and permanently delete the
> original and any copy or printout thereof.
> 
> 

