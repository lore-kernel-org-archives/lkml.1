Return-Path: <linux-kernel-owner+w=401wt.eu-S1764302AbXHFKwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764302AbXHFKwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXHFKwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:52:13 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:52599 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbXHFKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:52:12 -0400
X-Greylist: delayed 2816 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 06:52:12 EDT
Message-ID: <46B6F22E.1020300@csr.com>
Date: Mon, 06 Aug 2007 11:04:30 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: Re: sdio: set the functions' block size
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<1185896193612-git-send-email-david.vrabel@csr.com> <20070804153040.73668e4e@poseidon.drzeus.cx>
In-Reply-To: <20070804153040.73668e4e@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Aug 2007 10:04:30.0573 (UTC) FILETIME=[2E45F9D0:01C7D811]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Tue, 31 Jul 2007 16:36:32 +0100
> David Vrabel <david.vrabel@csr.com> wrote:
> 
>> Prior to calling the driver's probe(), set the functions' block size
>> to the largest that's supported by both the card and the driver.
>>
>> Signed-off-by: David Vrabel <david.vrabel@csr.com>
>>
> 
> Why a maximum size for the driver?

For efficient use of the bus it is useful to pad transfers to a multiple
of the block size.  I reckoned it was potentially beneficial for drivers
to use smaller blocks so less padding was required.  However, after
looking at some figures the per block overhead (28 clocks for a write)
really does limit the transfer sizes where small block sizes is beneficial.

I'll remove this.  Drivers can still override the block size by calling
sdio_set_block_size() directly.

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.
