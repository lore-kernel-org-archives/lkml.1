Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZCFUBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZCFUBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbZCFUB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:01:26 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:16708 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbZCFUBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:01:25 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>,
       "coldwell@redhat.com" <coldwell@redhat.com>,
       "mikem@beardog.cca.cpqcorp.net" <mikem@beardog.cca.cpqcorp.net>
Date: Fri, 6 Mar 2009 20:00:30 +0000
Subject: RE: [PATCH 1/2] resubmit cciss: kernel thread to detect changes on
	MSA2012
Thread-Topic: [PATCH 1/2] resubmit cciss: kernel thread to detect changes on
	MSA2012
Thread-Index: AcmeiMuVR842YVC9R0uMusGipAuTjQADTnJw
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77885CA68ED159@GVW0547EXC.americas.hpqcorp.net>
References: <20090306181603.GA30801@roadking.ldev.net>
 <1236363867.12019.2.camel@localhost.localdomain>
In-Reply-To: <1236363867.12019.2.camel@localhost.localdomain>
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

 

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
> Sent: Friday, March 06, 2009 12:24 PM
> To: Miller, Mike (OS Dev)
> Cc: Andrew Morton; Jens Axboe; LKML; LKML-scsi; 
> coldwell@redhat.com; mikem@beardog.cca.cpqcorp.net
> Subject: Re: [PATCH 1/2] resubmit cciss: kernel thread to 
> detect changes on MSA2012
> 
> On Fri, 2009-03-06 at 12:16 -0600, Mike Miller wrote:
> > Patch 1 of 2
> > 
> > This is a resubmission of yesterdays patch to detect 
> changes on the MSA2012.
> > I hope I've addressed all concerns. This patch rearranges 
> some of the 
> > code so we also have coverage in the sg and the ioctl paths 
> as well as 
> > the main data path.
> > 
> > The MSA2012 cannot inform the driver of configuration changes since 
> > all management is out of band. This is a departure from any 
> storage we 
> > have supported in the past. We need some way to detect 
> changes on the 
> > topology so we implement this kernel thread. In some 
> instances there's 
> > nothing we can do from the driver (like LUN failure) so 
> just print out 
> > a message. In the case where logical volumes are added or 
> deleted we 
> > call rebuild_lun_table to refreash the driver's view of the world.
> > 
> > Please consider this for inclusion.
> 
> I still don't quite see how the thread stops on module 
> removal ... there needs to be an explicit kthread_stop() 
> somewhere in the clean up path.
> 
I thought that was probably needed, duh. Is there anything else I should address at the same time?

-- mikem