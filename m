Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbYG2Ga0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbYG2Ga0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYG2GaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:30:13 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:43380 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbYG2GaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KIy0wUaDtoMm70HR9qjemb1Vr7ikpT/WLF6TG/jeXLRChA5ihMgYUj/+vQ094g1K7R
         NE4Rjwwyp3qmgLBT2VANKIWBhcHTOPYcxVgEbintOFMsl17HRM3VvQu+zljCUleIXDtd
         JZiNVenK+NcO4mlxe+UhB1wqHjZ5vpsSIiKhM=
Message-ID: <74d0deb30807282330y142cedd2ld0ecf33cc459a75a@mail.gmail.com>
Date: Tue, 29 Jul 2008 08:30:09 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Uli Luckas" <u.luckas@road.de>
Subject: Re: [PATCH] fix misalignment in pxamci
Cc: LKML <linux-kernel@vger.kernel.org>, "Marek Vasut" <marek.vasut@gmail.com>,
       drzeus-mmc@drzeus.cx
In-Reply-To: <200807281823.25302.u.luckas@road.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807050219.52218.marek.vasut@gmail.com>
	 <74d0deb30807050121n38c44dfaoa843fe8a0b581d01@mail.gmail.com>
	 <200807281823.25302.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 6:23 PM, Uli Luckas <u.luckas@road.de> wrote:
> On Saturday, 5. July 2008, pHilipp Zabel wrote:
>> On Sat, Jul 5, 2008 at 2:19 AM, Marek Vasut <marek.vasut@gmail.com> wrote:
>> > Hi,
>> > Philipp Zabel finally made the pxamci issue clear. It turned out, that
>> > pxamci needs the DMA destination address to be aligned to 8 bytes. In
>> > some cases it happened, that the address was aligned to 4 bytes causing
>> > controller to incorrectly transfer data (and resulting into error like
>> > "mmc0: unrecognised SCR structure version 1"). The following patch allows
>> > to debug this issue and moreover fixes it by moving one 4 byte entry of
>> > mmc_card structure, aligning the DMA destination back to 8 bytes.
>> >
>> > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
>>
>> We can enable byte aligned transfers on the DMA controller. This is
>> what I came up with yesterday:
>> (sorry for wrapped lines - the proper patch should probably be a
>> combination of both
>> warning/DALGN handling and and moving something in mmc_card around).
>>
> Hi Philipp,
> this driver is not only for pxa27x but for pxa25x as well and pxa25x can't
> handle unaligned DMA.
> Shouldn't Marek Vasut's patch be included for the PXA25x case?

Argh, DALGN shouldn't be defined in pxa-regs.h. We really need an
aligned SCR target then. Pierre, is there any way we can have the MMC
core align DMA targets for pxa25x?

Just moving elements of the mmc_card structure around seems to be good
enough, but I fear this will break again as soon as the next person
forgets about pxamci's special needs on pxa25x.

regards
Philipp
