Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbXKIUom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbXKIUom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 15:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXKIUob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 15:44:31 -0500
Received: from mail0.lsil.com ([147.145.40.20]:65332 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbXKIUoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 15:44:30 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: PATCH [2/8] scsi: megaraid_sas - add module param fast_load
Date: Fri, 9 Nov 2007 13:43:56 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501CA22B8@NAMAIL1.ad.lsil.com>
In-Reply-To: <20071107173939.GD25560@infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: PATCH [2/8] scsi: megaraid_sas - add module param fast_load
Thread-Index: AcghZS/9usHzjygjSeSNkMZluAkeugBqG/5A
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: <James.Bottomley@SteelEye.com>
Cc: <linux-scsi@vger.kernel.org>, <akpm@osdl.org>,
       <linux-kernel@vger.kernel.org>, "Christoph Hellwig" <hch@infradead.org>
X-OriginalArrivalTime: 09 Nov 2007 20:43:59.0740 (UTC) FILETIME=[41527BC0:01C82311]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James,

We are re-submitting those patches with the two patches (patch [2/8]--
"add module param fast_load" and patch [3/8] -- "add module param
max_sectors, cmd_per_lun" ) droped for now.  Later on we may implement
the module params as suggested by the community members.

Regards.

Bo Yang   


-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Wednesday, November 07, 2007 12:40 PM
To: Yang, Bo
Cc: Christoph Hellwig; linux-scsi@vger.kernel.org;
James.Bottomley@SteelEye.com; akpm@osdl.org;
linux-kernel@vger.kernel.org
Subject: Re: PATCH [2/8] scsi: megaraid_sas - add module param fast_load

On Tue, Nov 06, 2007 at 12:04:31PM -0700, Yang, Bo wrote:
> I see that scsi_scan_host_selected is in scsi_priv.h and currently is 
> not used by any other driver. The scsi_priv.h is not part of the 
> include dir (/include/scsi). One of the major Linux distro's don't 
> even include this file in /usr/src/kernels. Also it looks like at this

> time this function may not be available (not exported?) for driver
modules to use.
> Even if I include scsi_priv.h I get "unknown symbol" for this function

> while loading.

Yes, it would have to be exported and moved to a public header.

> May be in the long run we can solve all these issues to call 
> scsi_scan_host_selected. However, the current implementation works 
> fine and has been tested by LSI and others. This implementation 
> doesn't break any protocol nor does it adversely affect any driver
functionality.

Your implementation adds state to scanning that could easily break and
makes the driver complex for things that don't belong into a driver, so
there's a clear NACK for this from me.
