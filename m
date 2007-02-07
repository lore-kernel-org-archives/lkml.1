Return-Path: <linux-kernel-owner+w=401wt.eu-S1030625AbXBGMkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030625AbXBGMkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 07:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030623AbXBGMkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 07:40:36 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:32860 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030625AbXBGMkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 07:40:35 -0500
Message-ID: <45C9C8BF.6030501@garzik.org>
Date: Wed, 07 Feb 2007 07:40:31 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: conke.hu@amd.com
CC: Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [LIBATA BUG] sr.c: TEST_UNIT_READY error
References: <1170101430.29240.34.camel@localhost.localdomain>	 <20070129133849.1b523226@freekitty>	 <1170109401.29240.49.camel@localhost.localdomain>	 <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>	 <20070129144055.151cfe52@freekitty> <Pine.LNX130065457.GA23390@elte.hu>	 <45BEF61F.7000400@garzik.org> <1170310503.5166.17.camel@localhost.localdomain>
In-Reply-To: <1170310503.5166.17.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Conke Hu wrote:
> Hi,
>    TEST_UNIT_READY in get_capabilities (drivers/scsi/sr.c line 743, or
> see below) always returns error.
> 
>   ---------------- code begin -----------------------------
>     retries = 0;
>     do {
>         memset((void *)cmd, 0, MAX_COMMAND_SIZE);
>         cmd[0] = TEST_UNIT_READY;
> 
>         the_result = scsi_execute_req (cd->device, cmd, DMA_NONE, NULL,
>                            0, &sshdr, SR_TIMEOUT,
>                            MAX_RETRIES);
> 
>         retries++;
>     } while (retries < 5 &&
>          (!scsi_status_is_good(the_result) ||
>           (scsi_sense_valid(&sshdr) &&
>            sshdr.sense_key == UNIT_ATTENTION)));
>   ---------------- code end -----------------------------
> 
>   I debugged all kernel versions from 2.6.17 to 2.6.20 on several AMD
> and other vendor's PATA/IDE controllers, and I get the_result==0x8000002
> and retries==5; on silicon image 3132, i get the_result=0x2eb.
>   Does 0x8000002 mean ((DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION)?
> what's wrong?

What does the sense data returned in the sense buffer say is wrong?

	Jeff



