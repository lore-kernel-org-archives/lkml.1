Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYBVQfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYBVQfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbYBVQfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:35:36 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34043 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756547AbYBVQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:35:34 -0500
Subject: RE: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDB
	cmds with sense info
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>,
       "Kolli, Neela" <Neela.Kolli@lsi.com>
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501F6979B@NAMAIL1.ad.lsil.com>
References: <9738BCBE884FDB42801FAD8A7769C26501F6979B@NAMAIL1.ad.lsil.com>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 10:35:31 -0600
Message-Id: <1203698131.6206.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-22 at 09:17 -0700, Yang, Bo wrote:
> James,
> 
> What is the status for this patch?  We need to submit more patches based
> on the acceptance of this patch.

OK, read the thread; Matthew is right.  What you propose would pretty
much destroy compat ioctl handling within the driver.  You need a compat
handler for MEGASAS_IOC_FW.

With your current patch you'd get a failure both from a 64 bit binary
running on x86-64 and if someone ran the x86 binary on ia64.

The driver already uses the compat infrastructure, it shouldn't be too
hard to add this in the correct manner.

James


