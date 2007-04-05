Return-Path: <linux-kernel-owner+w=401wt.eu-S1767130AbXDEP54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767130AbXDEP54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767131AbXDEP54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:57:56 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:42927 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767126AbXDEP5y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:57:54 -0400
X-BigFish: VP
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Warning: unable to open an initial console.
Date: Thu, 5 Apr 2007 08:57:49 -0700
In-Reply-To: <a8e1da0704031853q3f36570ey864cf18126c90f4@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Warning: unable to open an initial console.
Thread-Index: Acd2XB/uTqkIYdnSQUu2w7/6K3+RRABPeBsQ
References: <20070402190458.0EDD039005F@mail42-fra.bigfish.com> <20070402224923.GA11208@tuatara.stupidest.org> <20070402232012.6716E64781D@mail78-cpk.bigfish.com> <a8e1da0704021834q7911fb56oa0f3f23651ee6be2@mail.gmail.com> <20070403183532.0EE676CC6F2@mail138-cpk.bigfish.com> <a8e1da0704031853q3f36570ey864cf18126c90f4@mail.gmail.com>
From: "Tom Strader" <tom.strader@xilinx.com>
To: "young dave" <hidave.darkstar@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Apr 2007 15:57:50.0489 (UTC) FILETIME=[29993090:01C7779B]
Message-Id: <20070405155751.5C30ACD005F@mail79-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The problem appears to be that the uart driver is not assigning the
port.  In uart_get() located in drivers/serial/serial_core.c the code
tries to access state->port but it does not appear to exist.  Where is
the port supposed to get added/setup?  Should this happen in the driver
init or does the kernel add the ports to the driver after init?

Uart_get knows the correct driver name drv->driver_name = "PXA serial"
and drv->dev_name = "ttyS", but the drv->state->port does not exist.
Where should the port be added?  The port info exists in
drivers/serial/pxa.c but I cant find where its initialized.  Any help
would be great.
Thanks,
Tom

-----Original Message-----
From: young dave [mailto:hidave.darkstar@gmail.com] 
Sent: Tuesday, April 03, 2007 6:54 PM
To: Tom Strader
Cc: linux-kernel@vger.kernel.org
Subject: Re: Warning: unable to open an initial console.

Hi;
The errno "-6" is defined as:
#define ENXIO            6      /* No such device or address*/

You can try to retrieve the rootfs and add the necessary device file
to it, then reflash the rootfs.

I'm Sorry, I  have no embedded environment to test.

Regards
dave


