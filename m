Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbYBZA7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbYBZA7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758999AbYBZA64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:58:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:47072 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155AbYBZA6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:58:55 -0500
Subject: Re: [PATCH] libata: Add MMIO support to pata_sil680
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Tim Ellis <tim@ngndg.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <47C347C3.40404@garzik.org>
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
	 <1202850129.7410.22.camel@pasglop>
	 <Pine.LNX.4.64.0802151651340.27735@axis700.grange>
	 <20080215155332.2b89c429@core> <1203111956.22915.24.camel@pasglop>
	 <DD1DA785-AD9C-4EFA-94E2-FA7154EECA9F@ngndg.com>
	 <47C347C3.40404@garzik.org>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 11:58:22 +1100
Message-Id: <1203987502.15052.71.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes.
> 
> Alan loves to complain about lack of MMIO flush, but in practice this is 
> rarely the source of problems such as the one you describe.
> 
> But if its broken its broken, and we need to revert.  Any luck getting 
> benh access to the device?
> 

Especially since reverting it will break a whole bunch of cell blades,
which wouldn't be nice (those cannot do PIO and have that controller).

In the meantime, we might "workaround" with a hack to only enable MMIO
on those cell
blades, something like:

#ifdef CONFIG_PPC64
	if (machine_is(cell))
		mmio = 1;
#endif

That might get us out of the regression until we find the proper
solution ?

Cheers,
Ben.


