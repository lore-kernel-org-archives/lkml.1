Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbZEMTgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbZEMTgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbZEMTgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:36:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57298 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZEMTgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:36:33 -0400
Message-ID: <4A0B213F.2060900@garzik.org>
Date: Wed, 13 May 2009 15:36:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: C Z <cziom2523@hotmail.com>
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: Help with SATA driver/libata/SCSI subsystem
References: <SNT104-W6340D4A4CFCC4D6DEF1140BB610@phx.gbl>
In-Reply-To: <SNT104-W6340D4A4CFCC4D6DEF1140BB610@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C Z wrote:
> I am attempting to write a SATA driver under libata for a custom core on a Microblaze Xilinx FPGA. I can not get ata_device_add() in drivers/ata/libata-core.c to return successfully.
> 
> I have tracked the immediate problem to the function scsi_eh_flush_done_q() in drivers/scsi/scsi_error.c. The problem is this function calls "list_for_each_entry_safe(scmd, next, done_q, eh_entry)". Unfortunately, this returns the result scmd = 0xFFFFFFF0. This very strange address is the result of containerof() being called on a NULL pointer. The NULL pointer is the done_q list head. This is clearly wrong.
> 
> I have 2 questions. First, why is libata invoking the error handler after a probe in ata_device_add? This seems very counter intuitive to me. It isn't at all clear why libata needs to do this. Can someone explain the rationale behind this function?
> 
> Second, and more importantly, can someone who is experienced with this subsystem explain in simple terms the call flow that happens in the function ata_device_add? I am having trouble understanding which procedure should have issued a command and set up the done_q list head. Therefore I don't know how to track this problem further. Indeed, it doesn't appear to me that anyone actually issues a command during the probe. I'm guessing it was supposed to have been done somewhere, but where/in what function should I start looking? What was the command supposed to have been?
> 
> I am using an old kernel version 2.6.20, however I don't believe these subsystems have changed substantially since then.
> 
> Any assistance or advice from someone who has dealth with this area of the kernel before is appreciated.

Please cc linux-ide@vger.kernel.org, and turn on word wrapping in your 
email.

Please also use an updated kernel, libata has changed substantially 
since 2.6.20.

Hardware drivers do not invoke ata_device_add() [which does not exist 
anymore], so it sounds like you are doing something really wrong...

	Jeff



