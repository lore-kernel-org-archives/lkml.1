Return-Path: <linux-kernel-owner+w=401wt.eu-S1761624AbXIKIBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761624AbXIKIBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbXIKIBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:01:25 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3389 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbXIKIBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:01:24 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: Socket owner problem?
Date: Tue, 11 Sep 2007 01:01:07 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEHAGLAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <8d33dcd40709110045v532e062ex7f05ac3ba9386161@mail.gmail.com>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 11 Sep 2007 01:01:50 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 11 Sep 2007 01:01:51 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The problem happens like this:
> Once the socket is closed by the user-space application, there are
> still packets left in the module's queue. Now, the moment the kernel
> timer expires and the module propagates those packets up into the
> higher layer, the system hangs.

If that were true, anyone who could send those packets to your machine would
be able to cause the system to hang too. Perhaps you are feeding the packets
back in at too high a layer.

> I've been searching for ways to determine if associated socket is
> closed. This way, if my module knows that the user-space already
> closed the socket, it will not propagate the packet up. Does anyone
> have a solution for this problem?

What object is this queue logically associated with? If the socket, you
should probably hook 'release' so you can purge the queue when the socket is
removed.

DS


