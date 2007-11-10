Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbXKJTEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbXKJTEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 14:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXKJTEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 14:04:36 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43772 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbXKJTEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 14:04:35 -0500
Message-ID: <473600B6.5070103@garzik.org>
Date: Sat, 10 Nov 2007 14:04:22 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Allen Martin <AMartin@nvidia.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>,
       Riki Oktarianto <rkoktarianto@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
References: <20071109020235.GA2031@ceren>	<20071109023129.GA25581@havoc.gtf.org>	<4733D421.7000505@rtr.ca>	<20071109034622.GB25581@havoc.gtf.org> <20071109120425.543971bf@the-village.bc.nu> <47351FE1.4000001@garzik.org> <DBFABB80F7FD3143A911F9E6CFD477B0329351A3@hqemmail02.nvidia.com>
In-Reply-To: <DBFABB80F7FD3143A911F9E6CFD477B0329351A3@hqemmail02.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allen Martin wrote:
> At least for NVIDIA controllers, loading the AHCI driver when the BIOS
> is set to IDE mode is not recommended by NVIDIA.  Any AHCI workarounds
> in the BIOS are likely to be disabled when set to IDE mode.  In practice

What workarounds, if any, are needed?

We need those in the driver not BIOS anyway, in order to fully support 
suspend/resume and host controller reset during runtime operation.


> we don't expect to see a lot of users running an AHCI controller in IDE
> mode unless they have explicitly disabled AHCI from the BIOS or the
> system builder has some specific reason for shipping IDE mode by default
> (like support for some legacy DOS or Win9x tools)

That's the situation we run into the most:  the system is in IDE mode 
not because AHCI doesn't work, but for legacy compatibility.  We even 
run into cases (MacBook, Dell servers) where the user is never offered 
the option to turn on AHCI, even though the silicon supports it.

As such, the user winds up being forced to into the inferior mode for no 
reason related to their own setup (since they are obviously running Linux).

In Linux at least, we have a bunch of open sata_nv issues, so forcing 
users' interface into AHCI mode as a default future policy seems like 
the most stable choice on NVIDIA AHCI platforms.

	Jeff


