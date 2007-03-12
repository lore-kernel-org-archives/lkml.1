Return-Path: <linux-kernel-owner+w=401wt.eu-S1030295AbXCLOr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030295AbXCLOr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030280AbXCLOr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:47:26 -0400
Received: from rtr.ca ([64.26.128.89]:2718 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030295AbXCLOrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:47:25 -0400
Message-ID: <45F56800.3040104@rtr.ca>
Date: Mon, 12 Mar 2007 10:47:28 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Vitaliyi <imgrey@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: libata extension
References: <3aac340703102322p362998b9labedc13503702d2b@mail.gmail.com>
In-Reply-To: <3aac340703102322p362998b9labedc13503702d2b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaliyi wrote:
> Good Day
> 
> Say i want to implement extended set of ATA commands available to
> userspace for building diagnostic tools.
> I need 0x40 -- read verify and 0x32 -- write long with error handling,
> for example. I was trying ide driver through ioctl's, but seems it
> lack of functionality and full of gotchas. Furthermore it oopses
> sometimes.

Use the SCSI SG_IO ioctl() with opcode=ATA_16,
which gives you access to the ATA Passthrough mechanism.
This will work for most ATA commands.

I already use it in hdparm and in some other utilities
for scanning/repairing drives.

A notable exeception are the READ/WRITE LONG opcodes,
which require an extra kernel patch from me,
awaiting merge into libata some year.

Cheers

-ml
