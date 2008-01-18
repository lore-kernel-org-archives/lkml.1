Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbYARO6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbYARO6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbYARO6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:58:44 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47418 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753609AbYARO6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:58:42 -0500
Subject: Re: [PATCH] SCSI: fix isa/pcmcia compile problem
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, fischer@norbit.de,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Samuel Ortiz <samuel@sortiz.org>
In-Reply-To: <47905348.1000709@gmail.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	 <478F7F2B.9000801@linux.vnet.ibm.com>
	 <20080117111104.3baa878e.akpm@linux-foundation.org>
	 <47904927.1040000@linux.vnet.ibm.com>  <47905348.1000709@gmail.com>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 08:58:35 -0600
Message-Id: <1200668315.3111.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 16:20 +0900, Tejun Heo wrote:
> aha152x.c and fdomain are built twice - once for the isa driver and
> once for the PCMCIA one.  Through #ifdefs, the compiled codes are
> slightly different; thus, global symbols need to be given different
> names depending on which flavor is being built.  This patch adds
> GLOBAL() macro to aha152x.h and fdomain.h which change the symbol
> depending on PCMCIA.
> 
> This bug has always existed but has been masked by the fact the
> drivers/scsi/pcmcia used subdir-(y|m) instead of obj-(y|m) which made
> drivers/scsi/pcmcia/built_in.o not linked into the kernel and thus
> avoided the duplicate symbols during compilation.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> Ah... missed that one.  Here's the updated version.

Actually, isn't the better fix just to return to the original behaviour?

As you pointed out, using the subdir instead of obj meant that although
the modules were built, the drivers were never linked into the main
kernel.  According to the records, this has been the default forever, so
there can be no-one anywhere relying on these drivers being built in.
Actually, as old style pcmcia drivers, I'm not sure there's much value
building them into the kernel anyway.

So just modify scsi/pcmcia/Kconfig to make them all depend on m.

James


