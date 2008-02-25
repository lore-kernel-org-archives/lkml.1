Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYBYVa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYBYVa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYBYVar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:30:47 -0500
Received: from mail0.lsil.com ([147.145.40.20]:36823 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbYBYVaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:30:46 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDBcmds with sense info
Date: Mon, 25 Feb 2008 14:30:19 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501F69BBB@NAMAIL1.ad.lsil.com>
In-Reply-To: <1203698131.6206.22.camel@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDBcmds with sense info
Thread-Index: Ach1cPOlhX1dqRsRQdORruWeYwc+/wCg44Rg
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Matthew Wilcox" <matthew@wil.cx>, <linux-scsi@vger.kernel.org>,
       <akpm@osdl.org>, <linux-kernel@vger.kernel.org>,
       "Patro, Sumant" <Sumant.Patro@lsi.com>,
       "Kolli, Neela" <Neela.Kolli@lsi.com>
X-OriginalArrivalTime: 25 Feb 2008 21:30:22.0502 (UTC) FILETIME=[A0974460:01C877F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

Thanks for the reply.  We will resubmit the patch to rollback it to our
original implementation.

Regards.

Bo Yang

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Friday, February 22, 2008 11:36 AM
To: Yang, Bo
Cc: Matthew Wilcox; linux-scsi@vger.kernel.org; akpm@osdl.org;
linux-kernel@vger.kernel.org; Patro, Sumant; Kolli, Neela
Subject: RE: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of
DCDBcmds with sense info


On Fri, 2008-02-22 at 09:17 -0700, Yang, Bo wrote:
> James,
> 
> What is the status for this patch?  We need to submit more patches 
> based on the acceptance of this patch.

OK, read the thread; Matthew is right.  What you propose would pretty
much destroy compat ioctl handling within the driver.  You need a compat
handler for MEGASAS_IOC_FW.

With your current patch you'd get a failure both from a 64 bit binary
running on x86-64 and if someone ran the x86 binary on ia64.

The driver already uses the compat infrastructure, it shouldn't be too
hard to add this in the correct manner.

James


