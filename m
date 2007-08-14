Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbXHNSSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbXHNSSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbXHNSSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:18:07 -0400
Received: from gw.goop.org ([64.81.55.164]:40302 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbXHNSSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:18:05 -0400
Message-ID: <46C1F168.5050102@goop.org>
Date: Tue, 14 Aug 2007 11:16:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, NetDev <netdev@vger.kernel.org>,
       Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-netfront: Avoid deref'ing skbafter it is potentially
 freed.
References: <46C0B6FD.7020701@goop.org> <200708140203.30711.jesper.juhl@gmail.com>
In-Reply-To: <200708140203.30711.jesper.juhl@gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> This moves the updating of both tx_bytes and tx_packets inside the 
> spinlock, but as far as I can see we only _really_ need to move the 
> tx_bytes update. Considering that we generally want to do as little 
> work as possible while holding a lock, wouldn't the following be 
> slightly better?
>   

Hm, I think it would be better to keep them together.  The second add is
going to be pretty much free, particularly since the tx_bytes add will
probably pull tx_packets into cache.

I have a followup patch to convert it to using the netdevice stats
structure, which will definitely put them in the same cacheline (though
perhaps the stats structure should group tx and rx members together?).

    J

    J
