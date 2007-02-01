Return-Path: <linux-kernel-owner+w=401wt.eu-S1161242AbXBGL5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161242AbXBGL5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161246AbXBGL5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:57:41 -0500
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:14970 "EHLO
	outbound2-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161242AbXBGL5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:57:39 -0500
X-BigFish: V
Subject: [LIBATA BUG] sr.c: TEST_UNIT_READY error
From: Conke Hu <conke.hu@amd.com>
Reply-To: conke.hu@amd.com
To: Jeff Garzik <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45BEF61F.7000400@garzik.org>
References: <1170101430.29240.34.camel@localhost.localdomain>
	 <20070129133849.1b523226@freekitty>
	 <1170109401.29240.49.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>
	 <20070129144055.151cfe52@freekitty> <Pine.LNX130065457.GA23390@elte.hu>
	 <45BEF61F.7000400@garzik.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: AMD
Date: Thu, 01 Feb 2007 14:15:02 +0800
Message-Id: <1170310503.5166.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
X-OriginalArrivalTime: 07 Feb 2007 11:55:52.0229 (UTC) FILETIME=[EA7EC550:01C74AAE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   TEST_UNIT_READY in get_capabilities (drivers/scsi/sr.c line 743, or
see below) always returns error.

  ---------------- code begin -----------------------------
    retries = 0;
    do {
        memset((void *)cmd, 0, MAX_COMMAND_SIZE);
        cmd[0] = TEST_UNIT_READY;

        the_result = scsi_execute_req (cd->device, cmd, DMA_NONE, NULL,
                           0, &sshdr, SR_TIMEOUT,
                           MAX_RETRIES);

        retries++;
    } while (retries < 5 &&
         (!scsi_status_is_good(the_result) ||
          (scsi_sense_valid(&sshdr) &&
           sshdr.sense_key == UNIT_ATTENTION)));
  ---------------- code end -----------------------------

  I debugged all kernel versions from 2.6.17 to 2.6.20 on several AMD
and other vendor's PATA/IDE controllers, and I get the_result==0x8000002
and retries==5; on silicon image 3132, i get the_result=0x2eb.
  Does 0x8000002 mean ((DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION)?
what's wrong?


Conke 



