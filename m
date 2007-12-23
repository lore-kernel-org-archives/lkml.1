Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbXLWFop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbXLWFop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 00:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbXLWFoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 00:44:37 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46928 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbXLWFog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 00:44:36 -0500
Message-ID: <476DF5BE.5030004@garzik.org>
Date: Sun, 23 Dec 2007 00:44:30 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Loic Prylli <loic@myri.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <476DF1A6.3060900@myri.com>
In-Reply-To: <476DF1A6.3060900@myri.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loic Prylli wrote:
> Supporting extended-conf-space is independant of the issue of using
> mmconf for legacy conf-space.

True.


> There is no real reason to use the same
> method to access both. I have seen several arguments used that were
> implying that, and they all seem really bogus to me. Not only are the
> two ranges (<= 256 and >= 256) structurally independant (you have
> totally independant capabilities lists that are independantly organized
> in each of them), even if they were not there is no consistency issue
> that cannot be dealt with a memory barrier, and the concern about taking
> an extra branch for each pci-conf-space access is also bogus once you
> look at the numbers.
> 
> By possibly using different implementations for the two ranges you avoid
> introducing a new API, you avoid taking risks with mmconf when you don't
> need it. That doesn't preclude using mmconf for everything either if the
> user requests it or based on enough knowledge of the system to be sure
> nothing will break.

Are you prepared to guarantee that freely mixing mmconfig and type1 
config accesses at runtime will always work, on all chipsets?  I'm 
talking about silicon here, not kernel software.

Furthermore, is it best for our users to find problems with mixed config 
accesses -- not at boot time, not at driver load time, but at some 
random time when some random driver does its first extended config space 
access?  IMO, no.  If you are going to fail, failing in a predictable, 
visible way is best.

Failures are more predictable and more consistent with an all-or-none 
scenario.  The all-or-none solutions are the least complex on the 
software side, and far more widely tested than any mixed config access 
scheme.

	Jeff


