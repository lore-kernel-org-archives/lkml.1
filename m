Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbXBUHDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbXBUHDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 02:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932499AbXBUHDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 02:03:52 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:52381 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359AbXBUHDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 02:03:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YTo7hV0UvBEDZfIyzPx4b6U/2HTYrnCsBMeZ6z9SdgteKCdX+XhCPzkAXVjpd6JwKVCm5nXVGusoaUYgDLttjByXaft59J1pbNK7W5RdqSeL7gGFfPgorJvJpyVGrfxz/W9/dnHqhXh0NrzrupDS/+evciMW+fpNSl6se7a18MI=
Message-ID: <45DBEED0.6050703@gmail.com>
Date: Wed, 21 Feb 2007 16:03:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Mark Lord <lkml@rtr.ca>, auxsvr@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: ata command timeout
References: <200702192119.50954.auxsvr@gmail.com> <45DA7416.4040101@gmail.com> <45DB114B.4020903@rtr.ca> <45DB15C2.7020206@garzik.org>
In-Reply-To: <45DB15C2.7020206@garzik.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Mark Lord wrote:
>> I don't believe that.  Command timeouts never happen on healthy systems,
>> unless we have a driver bug.  Okay, so I can imagine a pathological case
>> of a full queue (NCQ) with all 32 commands taking longer than usual due
>> to ECC retries in the firmware..
> 
> It's not quite so black and white.  There have definitely been interrupt
> delivery problems that cause command timeouts.  Also, Intel PIIX BMDMA
> (all standard PCI IDE, I think?) is defined to /not/ send an interrupt,
> when a DMA error occurs.  The driver is instructed to time out the
> transaction, and start recovery by deducing the state of things from the
> DMA status bits.
> 
> Nonetheless, I mostly agree with your statement.  The two most common
> causes of timeouts that I see are interrupt delivery problems, and
> driver bugs.

Oh.. well.  My experience is that it's much more common on SATA compared
to PATA.  SATA link seems to be one of the most vulnerable parts to
interference.  When PSU has the slightest of problem, SATA drives
timeout or give transmission problems.  System often survives brief
fluctuation in power input (e.g. when the compressor starts up) but SATA
link sometimes reports error after such event.

Or just buy a static generator and apply it to your computer case.
Generally system is perfectly okay with that but the SATA devices tend
to complain or timeout.

Those condition might not be considered too healthy in any server
environment but they do occur on cheap desktop environment.  I mean, a
lot of people are putting 10USD PSU into their desktop machines.

So, yeah, it might be a driver or other problem but if problem is very
intermittent, I tend to lean toward transient hardware problem and
that's primarily why I wanna make EH kick in and recover faster.

Thanks.

-- 
tejun
