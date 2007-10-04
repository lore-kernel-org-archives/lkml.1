Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbXJDIxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbXJDIxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 04:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXJDIxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 04:53:06 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:50011 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbXJDIxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 04:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qI7g5Ye6cCWiRDf0mVhxuWPIiH4kFL9SS1C693QrTYNAzL+gvuIvyderA8z6REHnHRv4k2reR28TUyHiTtDgNeVAPfvbzm48fKclYl5HLoeY78WyMC0a9XEZ21Ni0/lSEDe9WO2UPTEPbX2ulEu9XiMfmf59UEYira+ymr5a0fM=
Message-ID: <b681c62b0710040153w5b4779fat1ccc7fa3e5775c2c@mail.gmail.com>
Date: Thu, 4 Oct 2007 14:23:03 +0530
From: "yogeshwar sonawane" <yogyas@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Accessing 64-bit BARs
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

For accessing memory-mapped 64bit-BAR regions of a PCI card, the
respective BAR regions has to be made accessible to the kernel using
ioremap() function. Then readl()/writel() can be used on the address
returned by ioremap().

I am doing the similar steps to access the BARs of a card.
I observed some change in the behaviour in two different kernels.

Start physical addr of BAR is allocated by BIOS.
In linux-2.6.9, whether BAR start phys addr is below OR above 4GB,
i.e. whether 32-bit BAR phys addr(all higher bits 0) OR 64-bit phys
addr(some higher bits non-zero), I am able to access the BAR region
using ioremap() & then readl()/writel().

For linux-2.6.22-8, if BAR start phys addr is below 4GB, things are
working fine here also.

But, for linux-2.6.22-8, when BAR start phys addr is above 4GB, I am
not able to read/write on the BAR region. ioremap() is not failing.
But read data is all 1's instead of actual data.

Any ideas on where to look for?
Is there any change in the way of accessing 64-bit BAR?
OR
i am missing any step ?

For info - I am using 64-bit OS on x86_64 arch.

-Yogeshwar
