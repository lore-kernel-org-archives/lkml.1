Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbZEMXqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbZEMXqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759948AbZEMXpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:45:38 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:51756 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760355AbZEMXph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Eftk6TdIK+g3wlVYws/YFwI2Qc8xhOX1vxNBEJXPRmkL/fQvx1ypUMaJfdELnuPMcg
         T4ha2gLkAe8FqW4Vb8KClU5ZQa8pVYzIgIs7eH0FpYiq9HJUuEv54D0iBfHUmJgBOwTy
         FybbkgPZJB5hhNC1Rl3zo6CAEFFfFFX9fluzk=
Message-ID: <4A0B5B9C.2030104@gmail.com>
Date: Wed, 13 May 2009 17:45:32 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: C Z <cziom2523@hotmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Help with SATA driver/libata/SCSI subsystem
References: <SNT104-W6340D4A4CFCC4D6DEF1140BB610@phx.gbl>
In-Reply-To: <SNT104-W6340D4A4CFCC4D6DEF1140BB610@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C Z wrote:
> I am attempting to write a SATA driver under libata for a custom core on a Microblaze Xilinx FPGA. I can not get ata_device_add() in drivers/ata/libata-core.c to return successfully.
> 
> I have tracked the immediate problem to the function scsi_eh_flush_done_q() in drivers/scsi/scsi_error.c. The problem is this function calls "list_for_each_entry_safe(scmd, next, done_q, eh_entry)". Unfortunately, this returns the result scmd = 0xFFFFFFF0. This very strange address is the result of containerof() being called on a NULL pointer. The NULL pointer is the done_q list head. This is clearly wrong.
> 
> I have 2 questions. First, why is libata invoking the error handler after a probe in ata_device_add? This seems very counter intuitive to me. It isn't at all clear why libata needs to do this. Can someone explain the rationale behind this function?

To add to what Jeff said, the error handler thread is used for a lot 
more than just handling errors in libata, including for device probing..
