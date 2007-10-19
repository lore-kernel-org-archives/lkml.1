Return-Path: <linux-kernel-owner+w=401wt.eu-S966071AbXJSC4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966071AbXJSC4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 22:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759396AbXJSC4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 22:56:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44206 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbXJSC4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 22:56:36 -0400
Message-ID: <47181CE1.4000802@garzik.org>
Date: Thu, 18 Oct 2007 22:56:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: peer chen <peerchen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Kuan Luo <kluo@nvidia.com>
Subject: Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
References: <200709251323031982245@gmail.com> <470FE47B.5060505@garzik.org> <cfaab6210710160108x1328086cse991f668e23e569e@mail.gmail.com>
In-Reply-To: <cfaab6210710160108x1328086cse991f668e23e569e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

peer chen wrote:
> I hope one of the following patches can be merged to 2.6.24.
> ==========================
> http://lkml.org/lkml/2007/10/8/93
> http://lkml.org/lkml/2007/9/25/20

Unfortunately I do not feel like this is the right course of action.

Experience from Intel platforms tells us that our users get very unhappy 
when their silicon supports AHCI mode, but they are forced into using a 
less-performant mode.  A popular example is an <unnamed> OEM whose BIOS 
had no method whatsoever for enabling AHCI -- didn't even program the 
PCI BAR -- even though tests showed the AHCI mode worked just fine when 
manually programmed.

AHCI is more likely to provide a /stable/ Serial ATA experience, because 
the silicon deals primarily with sending and receiving FIS's, and not 
much else.  In constrast, experience has shown the legacy IDE interface 
to be a less reliable method of SATA support.  And certainly AHCI is 
much, much faster with less per-command overhead.

Given that AHCI is both faster and more stable, I feel it is the best 
policy to enable AHCI when the hardware supports it, regardless of PCI 
class code (IDE, SATA, or RAID).


> Yes, I agree to set the 'swncq' as default for 2.6.24, after all, for
> our server customers, stability is far more important than the new
> feature no matter the problem is caused by drive or controller.

Agreed.  Done!

	Jeff




