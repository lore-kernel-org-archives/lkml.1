Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZALRKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZALRKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZALRKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:10:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53147 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZALRKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:10:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <496B7969.5050706@s5r6.in-berlin.de>
Date: Mon, 12 Jan 2009 18:10:01 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Enrik Berkhan <Enrik.Berkhan@ge.com>
CC: Pierre Ossman <drzeus-mmc@drzeus.cx>, David Vrabel <david.vrabel@csr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Reference counting of MMC host driver modules
References: <49678443.8040909@ge.com> <49679570.3070403@csr.com> <20090109200024.GA14754@ngeserver2.localdomain> <49686F0C.7030807@s5r6.in-berlin.de> <20090111104111.5a0f00e1@mjolnir.drzeus.cx> <20090112154150.GA27289@ngeserver2.localdomain>
In-Reply-To: <20090112154150.GA27289@ngeserver2.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enrik Berkhan wrote:
> When removing the mmc_host_driver, everything seems to be fine; the
> MMC/SD block device has been deactivated by mmc_blk_remove(), that in
> turn has stopped the queue via mmc_cleanup_queue(). mmc_cleanup_queue()
> calls blk_cleanup_queue() on the underlying struct request_queue. By
> this, the reference count of the struct request_queues kboj drops to
> zero. The MD driver still has the block device open and, actually,
> things work fine unless the memory of the struct request_queue isn't
> touched, because it is marked dead. Of course, accessing the MD device
> returns EIO, but that's fine.
> 
> When the mmc_host_driver is reloaded, new struct request_queues will be
> allocated and with some probability, the old memory will be re-used for
> them or the old memory locations will be re-used for something else. The
> key point is that the queues still in use by the MD layer will
> effectively no longer be marked dead or completely corrupted.

So in short, the request_queue's reference count goes to zero even
though something still points to it?
-- 
Stefan Richter
-=====-==--= ---= -==--
http://arcgraph.de/sr/
