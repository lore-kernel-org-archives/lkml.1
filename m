Return-Path: <linux-kernel-owner+w=401wt.eu-S965066AbXHOXiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066AbXHOXiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964834AbXHOXij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:38:39 -0400
Received: from mail0.lsil.com ([147.145.40.20]:53425 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964798AbXHOXii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:38:38 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 2/4] scsi: expose AN support to user space
Date: Wed, 15 Aug 2007 17:37:45 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70916A58@NAMAIL4.ad.lsil.com>
In-Reply-To: <1187186509.3327.7.camel@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 2/4] scsi: expose AN support to user space
Thread-Index: AcffReV0PKvS9s5LT8m7uReuyGfQ9AATYTqQ
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: "James Bottomley" <James.Bottomley@SteelEye.com>,
       "Jeff Garzik" <jeff@garzik.org>
Cc: "Kristen Carlson Accardi" <kristen.c.accardi@intel.com>,
       <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       <venkatr@promise.com>, <vimal.nakum@promise.com>
X-OriginalArrivalTime: 15 Aug 2007 23:37:46.0455 (UTC) FILETIME=[489A6E70:01C7DF95]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 15, 2007 8:02 AM, James Bottomley wrote: 
> Actually, we just got a second potential consumer ... although I'll
> reprod to have the reporter send it to the list.  It's a device that
> needs notice of report luns data changing.  The proposed 
> mechanism looks
> a bit narrow now (too tied to media change).  I'll see if I 
> can propose
> a more generic update.
> 

I believe James is referring to my Promise issue. That is -  the
customers mutipath enclosure our SAS controller.  They have alternating
luns mapped to each path.  The odd luns mapped to a single path, and the
even luns to the other.  When a cable is pulled, a check condition is
generated (0x6, 0x3F, 0xE),  means report_luns data has changed.  What
the enclosure does it move the luns over to the alternate path.    Our
driver is not reporting the new luns because no event is generated to
mpt fusion driver from controller firmware (firmware only reports when a
target has been added/removed, not lun).     The mpt fusion driver
reports to the sas transport layer, the libata layer is not involved.
Shouldn't someone above sscsi lld be snooping that sence, and then
sending REPORT_LUNS to find out what changed.       

I've added some Promise contacts,  I hope they include the interested
partied to this discussion.

Eric
