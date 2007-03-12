Return-Path: <linux-kernel-owner+w=401wt.eu-S1030300AbXCLO4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030300AbXCLO4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030266AbXCLO4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:56:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50933 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030300AbXCLO43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:56:29 -0400
Message-ID: <45F56A18.4040008@garzik.org>
Date: Mon, 12 Mar 2007 10:56:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       Chip Coldwell <coldwell@redhat.com>
Subject: Re: data corruption with nvidia chipsets and IDE/SATA drives (k8
 cpu errata needed?)
References: <fa.Tb2r8Il/2H8l9dhmsGAAQB2WEZg@ifi.uio.no> <fa.lphwLNvMksoBFaqfqCzMG1UVhsA@ifi.uio.no> <45EBB7C5.2010407@shaw.ca> <200703121406.33334.ak@suse.de>
In-Reply-To: <200703121406.33334.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> in Linux. Apparently in some cases sata_nv does DMA on an already freed and then
> reused mapping.

Any data or additional info on that?  Did you discover this by tracking 
the DMA API software routines, or something lower level (like a bus 
analyzer)?

libata handles all the DMA allocation and mapping and cleanup for 
sata_nv, so any software problem would affect the whole of libata.

But it's possible that the nForce SATA chip has DMA padding needs that 
are different from those provided by libata-core (grep for "pad"), which 
could create a situation where the hardware continues DMA'ing past the 
end of the DMA area.

	Jeff




