Return-Path: <linux-kernel-owner+w=401wt.eu-S1762896AbXIKJ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762896AbXIKJ2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 05:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761662AbXIKJ2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 05:28:07 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3154 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760575AbXIKJ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 05:28:05 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: Socket owner problem?
Date: Tue, 11 Sep 2007 02:27:24 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEHGGLAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <8d33dcd40709110138h1bee46d2x8521f5b8f0d3a955@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 11 Sep 2007 02:28:11 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 11 Sep 2007 02:28:13 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi David,
>
> Thanks for your quick reply.
>
> > If that were true, anyone who could send those packets to your
> > machine would
> > be able to cause the system to hang too.
>
> You're right to say that :)
>
> > Perhaps you are feeding the packets
> > back in at too high a layer.
>
> Not really. In fact, I pass the packet back to the "lower layer" again
> by calling netif_receive_skb(). Note that packets can go in a loop
> here. To avoid queuing the same packets repeatedly, the module "marks"
> them the first time they are queued. Marked packets are simply
> NF_ACCEPT'ed by the module hook and therefore are propagated up the
> netfilter chain.

So then there is no reason there should be any problem if the packets are
fed after the socket is destroyed. I would try to figure out why something
that should not give you a problem is giving you a problem.

> > What object is this queue logically associated with? If the socket, you
> > should probably hook 'release' so you can purge the queue when
> > the socket is
> > removed.

> The queue is not associated with the socket. It is independent and is
> meant just for the module to use for queuing packets that are supposed
> to be delayed. But for each packet in this queue, there is an
> associated kernel timer. Once this timer expires, the associated
> packet is fed into the netif_receive_skb().

So what exactly goes wrong then? This approach sounds bulletproof.

DS


