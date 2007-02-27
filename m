Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbXB0LcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbXB0LcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 06:32:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933057AbXB0LcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 06:32:01 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:14185 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053AbXB0LcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 06:32:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hgNL5VJ7m5OW2QhryoefNIqBsO/XBWdA/2VidR+Mt8D47qeBD6W/9sSaCU/pApujS700fOPjwXAc8GxhEoJilw1j3Gls9uXVdtd1oHAAh+06yy281XprAyhrmNmZ9CO7JdR20d1jThRTtcvr/m97zbztenD/6PK+PqlQ+BQzUC8=
Message-ID: <6278d2220702270331k7b91017ds4c0eb0be4e4e9697@mail.gmail.com>
Date: Tue, 27 Feb 2007 11:31:58 +0000
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Stephen Hemminger" <shemminger@osdl.org>
Subject: sky2 stable in 2.6.12-rc1 (but still performance problem)...
Cc: "Linux Netdev" <netdev@vger.kernel.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Linux Networking" <linux-net@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

2.6.21-rc1 is the first kernel where my SysKonnect Yukon 2 hardware
with the sky2 v1.13 driver is stable under moderate load. Before a few
GBs of data going over my GigE network quickly with NFSv4 would cause
transmit timeouts previously, but now fine.

I am still observing a performance problem - feels like a wmb() or
some buffer flushing is missing somewhere - disabling processor clock
scaling reduces the problem a bit, but does not eliminate it.

What are your preferred way of checking performance? I think that the
TCP send window can grow enough even if ACKs are delayed due to this
problem, such that TCP does not immediately demonstrate this issue. I
could restrict the window scaling factor, so it would be bound by the
data->ACK round-trip latency, which /should/ be low, but I've been
observing it higher. Maybe I try this.

I'll see what I get with iperf UDP also, since this shows min, max,
avg UDP packet latency IIRC.

Thanks for your great work so far though!
  Dan
-- 
Daniel J Blueman
