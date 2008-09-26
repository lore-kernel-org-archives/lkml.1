Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbYIZOsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbYIZOsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 10:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYIZOry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 10:47:54 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:33216 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYIZOrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 10:47:53 -0400
Date: Fri, 26 Sep 2008 17:47:08 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andres Freund <andres@anarazel.de>, linux-kernel@vger.kernel.org
Subject: Re: bad DMAR interaction with iwlagn and SATA
Message-ID: <20080926144708.GD9118@il.ibm.com>
References: <200809251511.20132.andres@anarazel.de> <48DC44D4.8000103@garzik.org> <200809260419.07713.andres@anarazel.de> <48DC4BC0.7090203@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC4BC0.7090203@garzik.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 10:41:04PM -0400, Jeff Garzik wrote:
> Andres Freund wrote:
>> Hi Jeff,
>> On Friday 26 September 2008, you wrote in "Re: bad DMAR interaction with 
>> iwlagn and SATA":
>>> Andres Freund wrote:
>>>> sleeping I activated DMAR...
>>>> ..
>>>> Second:
>>>> [ 2937.484251] DMAR:[DMA Read] Request device [00:1f.2] fault addr
>>>> fffbf000 [ 2937.484255] DMAR:[fault reason 06] PTE Read access is not 
>>>> set
>>>> [ 2937.484297] ata1.00: exception Emask 0x60 SAct 0x1 SErr 0x800 action
>>>> 0x6 frozen
>>>> [ 2937.484303] ata1.00: irq_stat 0x20000000, host bus error
>>>> [ 2937.484309] ata1: SError: { HostInt }
>>>> [ 2937.484319] ata1.00: cmd 61/08:00:c0:1d:6b/00:00:07:00:00/40 tag 0 
>>>> ncq
>>>> 4096 out
>>>> [ 2937.484321]          res 40/00:00:c0:1d:6b/00:00:07:00:00/40 Emask
>>>> 0x60 (host bus error)
>>> Ouch, a host bus error is serious nastiness...
>> I only hit that with DMAR activated (hit it twice, different boots), so it 
>> seems to be related to that. Is there anything I can help to debug that?
>
> No idea about DMAR.  On the ATA side, it pretty diagnoses itself as
> you see here.  Unfortunately, ATA controller is behaving exactly as
> it should, when a major system error is thrown its way.

The way to debug this is to figure out why device 00:1f.2 is trying to
read from DMA address fffbf000 and does not have permission to do
so. This could be indicative of a driver bug where it is programming
the device to read from some buffer that has not been allocated
through the DMA API and thus does not have a valid IOMMU mapping, or a
hardware quirk where the device tries to read from memory without host
involvement. The former is much more likely.

Cheers,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                      xxx
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/
