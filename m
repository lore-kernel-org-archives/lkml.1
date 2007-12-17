Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbXLQRB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbXLQRB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbXLQRBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:01:37 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20805 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752839AbXLQRBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:01:34 -0500
Message-ID: <4766AB2A.7000206@panasas.com>
Date: Mon, 17 Dec 2007 19:00:26 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Filippos Papadopoulos <psybases@gmail.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: INITIO scsi driver fails to work properly
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com> <20071217031841.f483e5ac.akpm@linux-foundation.org> <20071217130523.7e9c88bb@the-village.bc.nu> <47668A75.7040707@panasas.com> <20071217143641.760d4162@the-village.bc.nu> <1197903781.3204.4.camel@localhost.localdomain> <47669F1B.4090400@panasas.com> <20071217162040.GB5056@dspnet.fr.eu.org>
In-Reply-To: <20071217162040.GB5056@dspnet.fr.eu.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Dec 2007 17:00:28.0764 (UTC) FILETIME=[537471C0:01C840CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17 2007 at 18:20 +0200, Olivier Galibert <galibert@pobox.com> wrote:
> On Mon, Dec 17, 2007 at 06:08:59PM +0200, Boaz Harrosh wrote:
>> Below fixes a deadly typo. Might as well be included in 2.6.24
> 
> You're sure ?  scsi_for_each_sg includes a (sg)++ already...
> 
> 
>>  		scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
>>  			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
>>  			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
>> +			++sg;
>>  		}
> 
>   OG.
> --
Don't mix up between the here sg that points to a driver specific struct sg_entry
and the here sglist which points to struct scatterlist, and is named sg inside
the scsi_for_each_sg() macro. Please inspect the full code, the patch does not
show the complete information. I admit it's confusing.

Boaz

