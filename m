Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZAMRu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZAMRu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 12:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZAMRuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 12:50:17 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49389 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbZAMRuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 12:50:16 -0500
Subject: Re: [BUILD-FAILURE] next-20090113 - drivers/scsi/aha1542.c builds
	with CONFIG_PPC=y
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20090113120314.GC2364@linux.vnet.ibm.com>
References: <20090113175145.cdfa9c6a.sfr@canb.auug.org.au>
	 <20090113120314.GC2364@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 11:50:12 -0600
Message-Id: <1231869012.4519.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 17:33 +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> 	next-20090113 ranconfig build on powerpc builds in drivers/scsi/aha1542
> 
> In file included from drivers/scsi/aha1542.c:41:
> include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy - please move your driver to the new sysfs api"
> drivers/scsi/aha1542.c: In function 'BAD_SG_DMA':
> drivers/scsi/aha1542.c:61: error: implicit declaration of function 'isa_page_to_bus'
> drivers/scsi/aha1542.c: In function 'aha1542_intr_handle':
> drivers/scsi/aha1542.c:495: error: implicit declaration of function 'isa_virt_to_bus'

This looks like a powerpc bug:  that driver depends on ISA &&
ISA_DMA_API which is supposed to guarantee the presence of these
functions.

James


