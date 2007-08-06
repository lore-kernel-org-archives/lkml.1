Return-Path: <linux-kernel-owner+w=401wt.eu-S932425AbXHFKb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbXHFKb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762658AbXHFKbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:31:47 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:41490 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762717AbXHFKbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:31:46 -0400
X-Greylist: delayed 920 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 06:31:46 EDT
Message-ID: <46B6F877.7060504@csr.com>
Date: Mon, 06 Aug 2007 11:31:19 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: Re: sdio: enhance IO_RW_EXTENDED support
References: <11858961933491-git-send-email-david.vrabel@csr.com> <20070804152304.65ed8f1b@poseidon.drzeus.cx>
In-Reply-To: <20070804152304.65ed8f1b@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Aug 2007 10:31:20.0449 (UTC) FILETIME=[EDD58F10:01C7D814]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Tue, 31 Jul 2007 16:36:30 +0100
> David Vrabel <david.vrabel@csr.com> wrote:
> 
>> These three patches enhance the support for the SDIO IO_RW_EXTENDED
>> command. The block size of functions is managed and the I/O ops
>> (sdio_readsb() etc) are extended to handle arbitrary lengths of data
>> (by using multiple commands).
>>
>> I've not yet had a chance to test this stuff as I don't (yet) have
>> the time to write a Bluetooth Type-A driver so these are posted as an
>> example of the sort of API I'd expect.
>>
> 
> Thanks. These are some nice improvements. I do have one suggestion
> though:
> 
> Could we design it so that sdio_io_rw_ext_helper() sets the block size
> itself? That way most drivers wouldn't have to care about that detail
> and the core would be free to choose optimal values.

I would expect the block size to be set once per card, and never be
changed and thus it's not logically a per-transfer operation.  We
certainly wouldn't want to change the block size willy-nilly as it's an
expensive operation.

The patch I've presented does put the selection of the block size in the
core (bar one thing which I agree should be removed).

> I suspect that some transactions might require a certain block size.
> But we could satisfy that by stating that any transfer small enough to
> fit into one block will not be split up.

I consider it unlikely that any card would want to do anything other
than always use the largest possible block size.

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.
