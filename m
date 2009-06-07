Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbZFGIWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbZFGIWO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 04:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZFGIWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 04:22:01 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59000 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZFGIV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 04:21:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XnS12Rvw0EuTlNBCTfH7daKPdecdqIXLrPn3tp6wGVCC6N4hMpbH4vFYWfebkqxDbF
         7E2AE6oQjrUaasfCHquboqsJN0iFEyinKoMRDAYMO9yb5iCigkLWV/HN+oT/Y4pmzd4u
         IGeg5sOE0ZP07r4wVEZs6ulKg4aW8GLoHrO58=
MIME-Version: 1.0
In-Reply-To: <20090607081305.GA12497@elte.hu>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	 <20090605104132.GE24836@amd.com> <20090607081305.GA12497@elte.hu>
Date: Sun, 7 Jun 2009 10:22:00 +0200
Message-ID: <64bb37e0906070122t652051d7oaa1e7ec70e4c05ea@mail.gmail.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>, lethal@linux-sh.org,
       hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 7, 2009 at 10:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
>> But its up to Linus/Ingo to decide if it can be accepted at this
>> very late point in the cycle. Since dma-debug is new with 2.6.30
>> it will at least not introduce any regression. [...]
>
> I think it's too late for v2.6.30 to do any of the changes - and the
> DMA debug facility is off by default.
>
> Also, i think such DMA patterns, while 'allowed' can be quite
> dangerous as its such a rare usage combination really. AIO and DIO
> are crazy to begin with, mixing AIO and DIO for the same buffer is
> madness square two. (It can result in 3 agents for the same memory
> address: CPU, dma1 and dma2. How many interesting chipset erratums
> could there be related to such scenarios?)

I think in my case the cause is somewhat simpler: RAID1
My root filesystem is on a RAID1 that consists of two disks, both
connected to the sata_sil24 controller.
So it is only natural for the md driver to issue two dma read requests
for the same address: one for each drive.

Torsten
