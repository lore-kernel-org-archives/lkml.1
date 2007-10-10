Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbXJJPuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbXJJPuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 11:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbXJJPuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 11:50:04 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:1806 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844AbXJJPuC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 11:50:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 10 Oct 2007 15:49:58.0734 (UTC) FILETIME=[361216E0:01C80B55]
Content-class: urn:content-classes:message
Subject: Re: Ethernet driver problem
Date: Wed, 10 Oct 2007 11:49:58 -0400
Message-ID: <Pine.LNX.4.61.0710101141590.17013@chaos.analogic.com>
In-Reply-To: <1192028669.25145.1215155009@webmail.messagingengine.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Ethernet driver problem
Thread-Index: AcgLVTYZSLe3V6avQK+Vc1Sbh04pjw==
References: <1192028669.25145.1215155009@webmail.messagingengine.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Jupe" <jupejupe@rushpost.com>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Oct 2007, Jupe wrote:

> Hi,
>
> I have written an ethernet driver for an ARM based board.
> Linux version: 2.6.20.1
>
> Ping is working fine.
>
> I have written a test server/client application using socket programming
> (TCP).
> After the connection is setup the server sends a file to the client.
>
> When I run server on PC and client on ARM board it works without any
> problem.
>
> BUT if I run server on ARM board and client on PC, it works for some
> time and
> then the speed is drastically reduced. (I am sending 4k of data each
> time.
> after 50 sends it reduces its speed.  This happens always.)
>
> I did some debugging and found that after 50 sends, tcp_sendmsg() is not
> being
> called at the same frequency before slowdown.  Also when my driver
> ether_tx seems to
> be working fine.
>
> But still i am not able to get the reason for this behaviour.  Can
> anyone give hints as to
> why this is happening?
>
>
> Regards
> Jupe
>
> -- 
>  Jupe
>  jupejupe@rushpost.com
>
> -- 
> http://www.fastmail.fm - mmm... Fastmail...

First, does your TCP/IP test application work okay on
a Linux machine that does not use your new driver?

That's the first thing to test.

Next, is auto-negotiation working correctly in your
driver? If you don't have auto-negotiation, have you
set the Ethernet parameters correctly so that BOTH
the server and the client use either full-duplex, or
half-duplex, without mixing them up?

Next, make sure that you are properly handling
transmit retries (handling all possible errors)
in your driver. The transmitter does not want
to drop packets if there is no room in the
device, only the receiver should drop packets
if there are no buffers. You do not want
the TCP/IP replacement algorithm to request
missing packets because this slows everything
down. Again, in the transmitter section
of your driver, consider data precious.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
