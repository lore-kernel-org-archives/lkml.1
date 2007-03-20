Return-Path: <linux-kernel-owner+w=401wt.eu-S965810AbXCTCip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965810AbXCTCip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 22:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966071AbXCTCip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 22:38:45 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2769 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965810AbXCTCid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 22:38:33 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: UDP packets scheduling
Date: Mon, 19 Mar 2007 19:37:58 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEEACGAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <20070320005228.GN22880@mail.muni.cz>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 19 Mar 2007 19:38:21 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 19 Mar 2007 19:38:22 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> can anyone suggest me a proper way how to schedule UDP packets to
> transmit at
> some given rate?
>
> E.g., I have two boxes both having 10 GE interfaces. One box is able to
> transmit at 9.9Gbps, the other one is able to receive only at
> about 5.5Gbps.
> Flow control must be turned off for some other reason.

UDP is not a very good choice of protocol for this purpose. UDP pushes the
transmit timing job into user-space, where it cannot be done particularly
well.

> How can I put delay between subsequent msg sends to achieve desired
> packet rate without loses, e.g., 3.5Gbps without bursts? Even nanosleep()
> with the lowest possible delay seems to be too much delay. Busy loop with
> clock_gettime(3) works OK on SMP boxes, but on UP it causes problems.

Why do you want to avoid bursts? You're going to be bursting between 10Gb/s
and 0 anyway.

It sounds like you're deliberately putting impossible requirements on
yourself choosing the worst possible protocol and demanding the pacing be
perfect. I don't think the technology to do that is here yet, but why would
you possibly need it?

10GE cards tend to have large buffers precisely because it's not possible to
get the timing even. Why is burstiness a problem?

DS


