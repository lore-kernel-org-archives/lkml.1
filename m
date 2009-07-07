Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbZGGBPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbZGGBPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 21:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbZGGBPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 21:15:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32993
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752957AbZGGBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 21:15:25 -0400
Date: Mon, 06 Jul 2009 18:15:31 -0700 (PDT)
Message-Id: <20090706.181531.105788026.davem@davemloft.net>
To: benjamin.poirier@polymtl.ca
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       tcpdump-workers@lists.tcpdump.org, wireshark-dev@wireshark.org
Subject: Re: [PATCH] net: Take GSO into account when capturing packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A523CB0.8080005@polymtl.ca>
References: <4A523CB0.8080005@polymtl.ca>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <benjamin.poirier@polymtl.ca>
Date: Mon, 06 Jul 2009 14:04:32 -0400

> move the point where the support routine for packet capture is called to
> better reflect what is transmitted on the wire when GSO is active.
> 
> At the moment, packet capture (a la tcpdump) on the transmission side happens
> before GSO takes place (if it does). Therefore, even if a packet gets
> segmented by GSO, the capture shows that one big packet was sent when in fact
> many small packets were sent on the wire. This behavior does not reflect the
> "reality" of what is transmitted and could lead to confusion, especially since
> a capture on the receiving side shows the segmented packets.
> 
> Signed-off-by: Benjamin Poirier <benjamin.poirier@polymtl.ca>

TSO does the same exact thing except that the networking card
chops up the packet before it hits the wire.

I really doubt there is anything seriously to gain by having
GSO behave one way and TSO another, and we should just keep
things as they are right now.

I'm not applying this, sorry.
