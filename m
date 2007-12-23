Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbXLWVN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbXLWVN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 16:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXLWVNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 16:13:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:49253 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXLWVNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 16:13:50 -0500
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
	driver opt-in issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Loic Prylli <loic@myri.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <476DF5BE.5030004@garzik.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
	 <476D1D16.5090703@garzik.org>
	 <20071222064719.73fdd9a4@laptopd505.fenrus.org>
	 <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
	 <476DB95F.3090801@garzik.org>
	 <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
	 <476DDFEE.3010009@garzik.org>
	 <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org>
	 <476DE98F.2010009@garzik.org> <476DF1A6.3060900@myri.com>
	 <476DF5BE.5030004@garzik.org>
Content-Type: text/plain
Date: Mon, 24 Dec 2007 08:13:07 +1100
Message-Id: <1198444387.6686.20.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Are you prepared to guarantee that freely mixing mmconfig and type1 
> config accesses at runtime will always work, on all chipsets?  I'm 
> talking about silicon here, not kernel software.

We spinlock config space accesses. So the silicon will never see
simultaneous accesses, which is what I strongly suspect would be broken
in chipsets (asking for livelocks here).

Now there is the question of whether the silicon implements MMCONFIG
writes in some asynchronous way, in which case, there might be an issue
if you go bang the port right away but I very much doubt it.

Ben.


