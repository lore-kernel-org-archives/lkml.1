Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbYI3Xi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbYI3Xi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYI3XiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:38:19 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36090 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbYI3XiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:38:19 -0400
Message-ID: <48E2B868.9070407@lwfinger.net>
Date: Tue, 30 Sep 2008 18:38:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Robert Hancock <rwh461@mail.usask.ca>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Logs being spammed with "Unable to enumerate USB device"
References: <fa.dl+pVhW/kcgBFo0dsyPEgn0MhtE@ifi.uio.no> <48D9865B.8080806@mail.usask.ca> <48D9912A.20303@lwfinger.net>
In-Reply-To: <48D9912A.20303@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> Robert Hancock wrote:
>> Is this just occurring during bootup? I think this is normal if the EHCI
>> driver is loaded after UHCI or OHCI because it causes the device to be
>> switched away from the other controller that's trying to enumerate it,
>> at least momentarily.
> 
> It sometimes happens at bootup, but at other times I will get hundreds
> of them in a row in the logs. I have put in some debugging where the
> message is triggered, but have not seen any of the flood-type since.

I now have more information. The if statement that triggers the
message is as follows:

if (hub->hdev->parent ||
    !hcd->driver->port_handed_over ||
    !(hcd->driver->port_handed_over)(hcd, port1))

For all the messages that I have captured, the first condition
(hub->hdev->parent) is always true.

For the isolated message that occurs at bootup, the second condition
(!hcd->driver->port_handed_over) is true and the third is false.

When the message storm occurs, the second condition is false, i.e.
hcd->driver->port_handed_over is not zero, but
!(hcd->driver->port_handed_over)(hcd, port1) is true.

As before, I am willing to test any patches. As the message storm is
rare, it will be difficult to show that a patch fixes the problem.

Larry

