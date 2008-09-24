Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbYIXAO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbYIXAO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 20:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYIXAOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 20:14:21 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:55826 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYIXAOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 20:14:20 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=dz9Uz24-bVE81DiM-LMA:9 a=uAqhTRXLft-Q-TG0U2CimIofN3IA:4 a=W6NcNfrOW04A:10 a=ajM0KTv7SNIA:10
Message-ID: <48D9865B.8080806@mail.usask.ca>
Date: Tue, 23 Sep 2008 18:14:19 -0600
From: Robert Hancock <rwh461@mail.usask.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Logs being spammed with "Unable to enumerate USB device"
References: <fa.dl+pVhW/kcgBFo0dsyPEgn0MhtE@ifi.uio.no>
In-Reply-To: <fa.dl+pVhW/kcgBFo0dsyPEgn0MhtE@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> At times, my logs are filled with multiple copies of the following
> message:
> 
> hub 4-0:1.0: unable to enumerate USB device on port 5
> 
> The output of lsusb is as follows:
> 
> Bus 003 Device 002: ID 04f2:b016 Chicony Electronics Co., Ltd
> Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> 
> The hubs are built into an HP dv2815nr laptop, and nothing is plugged in.
> 
> I'm currently running v2.6.27-rc7 from the linux-2.6 git tree, but it
> does not seem to be a regression. In checking my back logs, my first
> such "storm" happened on July 25, with successive ones on September 8,
> 9, 12 and 21.
> 
> Is this an indication of hardware failure? What further info is
> required? Any suggestions for debugging code to try to pinpoint the
> problem?

Is this just occurring during bootup? I think this is normal if the EHCI 
driver is loaded after UHCI or OHCI because it causes the device to be 
switched away from the other controller that's trying to enumerate it, 
at least momentarily.
