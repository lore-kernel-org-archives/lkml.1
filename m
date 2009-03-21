Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZCUXEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZCUXEV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 19:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZCUXEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 19:04:05 -0400
Received: from brm-mailgate-2.brocade.com ([144.49.197.3]:7679 "EHLO
	brm-mailgate-2.brocade.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753808AbZCUXEE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 19:04:04 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/5] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Sat, 21 Mar 2009 16:03:03 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E02B4B4A2@HQ-EXCH-5.corp.brocade.com>
In-Reply-To: <49C27E95.4050401@cs.wisc.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/5] bfa: Brocade BFA FC SCSI driver (bfad)
Thread-Index: AcmottsK/7XWU7o8RzqF3m+w8ET0hABuvs1w
References: <200903142003.n2EK39r4031547@blc-10-6.brocade.com> <49C27E95.4050401@cs.wisc.edu>
From: "Jing Huang" <huangj@Brocade.COM>
To: "Mike Christie" <michaelc@cs.wisc.edu>
Cc: <James.Bottomley@HansenPartnership.com>,
       "Krishna Gudipati" <kgudipat@Brocade.COM>,
       <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
       "Ramkumar Vadivelu" <rvadivel@Brocade.COM>,
       "Vinodh Ravindran" <vravindr@Brocade.COM>
X-OriginalArrivalTime: 21 Mar 2009 23:04:00.0826 (UTC) FILETIME=[5279F9A0:01C9AA79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> some quick general comments:
> 
> - Patch needs to be run through checkpatch.pl again.
> - If you are not implementing a callout like issue_lip then you do not
> need to implement a function that does nothing.
> - Remove the OS compat stuff that just calls right into the linux
> function. For example kill bfad_os_pci_probe.
> 

We will fix all he checkpatch issues and make necessary cleanups and
resubmit soon.

> > +
> > +	im_port->shost->hostdata[0] = (unsigned long)im_port;
> 
> 
> 
> I think I asked about this before. Why do you just not allocate the
bfad
> or im_port in the hostdata? What is the struct hierarchy? Do you have
> one bfad for the entire HBA/pci_device then have a im_port for each
port
> on the hba?
> 

Thanks for review the code again. Yes, we have one bfad for each HBA
port/pci device, and one im_port (im stands for initiator mode) for each
scsi_host/vport. We can certainly allocate im_port in scsi_host_alloc()
as you suggest, but currently we allocate all possible fc4 port
(initiator/tgt/ipfc) in one function, and it is just more convenient to
do it in one place.

Thanks

Jing
 


