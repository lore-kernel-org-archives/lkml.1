Return-Path: <linux-kernel-owner+w=401wt.eu-S1763181AbXIKIiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763181AbXIKIiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761988AbXIKIiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:38:09 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:15514 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761801AbXIKIiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nEdSkzpJeEDcT2GzS+21McWyeGFxA78ffZO2SDlop/mapxsNeU5Dvvi1ji929EdRMv4O0o07OLvXbaXstIarAJX6k03zsWX8wzSHVPhjU5mQhbP0UYBJBjq17RyohkoUeJysWkPSvzeKepKIBufVq7WEcgjUfN4YZpvia1sD5U8=
Message-ID: <8d33dcd40709110138h1bee46d2x8521f5b8f0d3a955@mail.gmail.com>
Date: Tue, 11 Sep 2007 16:38:06 +0800
From: "Alvin Valera" <alvinvalera@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Socket owner problem?
In-Reply-To: <8d33dcd40709110045v532e062ex7f05ac3ba9386161@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1189496159.849702.82190@50g2000hsm.googlegroups.com>
	 <8d33dcd40709110045v532e062ex7f05ac3ba9386161@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for your quick reply.

> If that were true, anyone who could send those packets to your machine would
> be able to cause the system to hang too.

You're right to say that :)

> Perhaps you are feeding the packets
> back in at too high a layer.

Not really. In fact, I pass the packet back to the "lower layer" again
by calling netif_receive_skb(). Note that packets can go in a loop
here. To avoid queuing the same packets repeatedly, the module "marks"
them the first time they are queued. Marked packets are simply
NF_ACCEPT'ed by the module hook and therefore are propagated up the
netfilter chain.

> What object is this queue logically associated with? If the socket, you
> should probably hook 'release' so you can purge the queue when the socket is
> removed.

The queue is not associated with the socket. It is independent and is
meant just for the module to use for queuing packets that are supposed
to be delayed. But for each packet in this queue, there is an
associated kernel timer. Once this timer expires, the associated
packet is fed into the netif_receive_skb().


AV
