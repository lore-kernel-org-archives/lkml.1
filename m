Return-Path: <linux-kernel-owner+w=401wt.eu-S1761262AbZEMSL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262AbZEMSL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760150AbZEMSLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:11:18 -0400
Received: from snt0-omc1-s7.snt0.hotmail.com ([65.55.90.18]:45714 "EHLO
	snt0-omc1-s7.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760644AbZEMSLR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:11:17 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 May 2009 14:11:17 EDT
Message-ID: <SNT104-W6340D4A4CFCC4D6DEF1140BB610@phx.gbl>
X-Originating-IP: [124.121.136.78]
From: C Z <cziom2523@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Help with SATA driver/libata/SCSI subsystem
Date: Wed, 13 May 2009 11:05:05 -0700
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 13 May 2009 18:05:07.0515 (UTC) FILETIME=[5948A0B0:01C9D3F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am attempting to write a SATA driver under libata for a custom core on a Microblaze Xilinx FPGA. I can not get ata_device_add() in drivers/ata/libata-core.c to return successfully.

I have tracked the immediate problem to the function scsi_eh_flush_done_q() in drivers/scsi/scsi_error.c. The problem is this function calls "list_for_each_entry_safe(scmd, next, done_q, eh_entry)". Unfortunately, this returns the result scmd = 0xFFFFFFF0. This very strange address is the result of containerof() being called on a NULL pointer. The NULL pointer is the done_q list head. This is clearly wrong.

I have 2 questions. First, why is libata invoking the error handler after a probe in ata_device_add? This seems very counter intuitive to me. It isn't at all clear why libata needs to do this. Can someone explain the rationale behind this function?

Second, and more importantly, can someone who is experienced with this subsystem explain in simple terms the call flow that happens in the function ata_device_add? I am having trouble understanding which procedure should have issued a command and set up the done_q list head. Therefore I don't know how to track this problem further. Indeed, it doesn't appear to me that anyone actually issues a command during the probe. I'm guessing it was supposed to have been done somewhere, but where/in what function should I start looking? What was the command supposed to have been?

I am using an old kernel version 2.6.20, however I don't believe these subsystems have changed substantially since then.

Any assistance or advice from someone who has dealth with this area of the kernel before is appreciated.

Best Regards,

Chris






_________________________________________________________________
Hotmail® has a new way to see what's up with your friends.
http://windowslive.com/Tutorial/Hotmail/WhatsNew?ocid=TXT_TAGLM_WL_HM_Tutorial_WhatsNew1_052009