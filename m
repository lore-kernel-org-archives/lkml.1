Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbXIYUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbXIYUlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbXIYUlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:41:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35792 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbXIYUlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:41:05 -0400
Message-ID: <46F97257.3020502@garzik.org>
Date: Tue, 25 Sep 2007 16:40:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Berck E. Nash" <flyboy@gmail.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <46F7FBCB.4030803@gmail.com> <46F8665A.4000206@garzik.org> <46F9617F.1010508@gmail.com>
In-Reply-To: <46F9617F.1010508@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Berck E. Nash wrote:
> Jeff Garzik wrote:
>> Once the blame has been squared fixed upon me :) you can use git-bisect
>> to locate the precise change that broke your setup.
> 
> Okay, here's the problem:
> 
> 268fe6f9f15551be9abedd44a237392675d529d5 is first bad commit
> commit 268fe6f9f15551be9abedd44a237392675d529d5
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Fri Sep 21 07:09:36 2007 -0400
> 
>     [libata] SCSI: simple TEST UNIT READY simulation
> 
>     It's trivial to ping the device, and that's a much more sane behavior
>     than no-op.
> 
>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> :040000 040000 44d34cdad073bd623545b8239aca9a113652c6d0
> df6d21f7ce56a4e796f8f856c1f647b0395ab4df M      drivers

Thanks for debugging!

Can you tell me something about this device?

[   49.045635] ata2.00: ATA-6: Config  Disk, RGL10364, max UDMA/133
[   49.051677] ata2.00: 640 sectors, multi 1: LBA
[   49.056321] ata2.00: configured for UDMA/133

It seems like it does not support the 'check power mode' command.

Can you post a text file attachment, containing the output of 'hdparm 
--Istdout' ?

	Jeff



