Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbYEDOZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbYEDOZD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbYEDOYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:24:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:62274 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYEDOYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:24:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CFIYwUl2eQoTrUApSgyMGMJa1h8ohzRLgPfO2brlVVO/a/o8tI6E+Os7GI7R0qrupz5XYCxoBKV3kQl1iMi1JGu6wrm/qWPM7ihN4TTTaL45qWU4Tn3f/eVBmXdmZc4QcUM3zkFmom0sWra9Bv/P8N8g/DJPxHqs+PGjMivnkVE=
Message-ID: <481DC731.5090303@gmail.com>
Date: Sun, 04 May 2008 16:24:49 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Chris Snook <csnook@redhat.com>
Subject: Re: Need help debugging memory corruption
References: <20080503130951.091392ba@osprey.hogchain.net>
In-Reply-To: <20080503130951.091392ba@osprey.hogchain.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote, On 05/03/2008 08:09 PM:
...

> Here is the relevant console output when the bug is hit.  I note that
> the apparent corrupting data beginning at address 0xffff81010fcff402 is
> actually a received ethernet frame.  (The value 00:17:31:4e:9d:41 is
> the MAC address of the local host, corresponding to the destination
> address of a received frame.)
> 
> Can someone with more experience than me please take a look and give me
> some advice or explain what might be happening here?  (What may be
> obvious to you is probably not obvious to me.)

I'm definitely with less experience, so I wonder why it can't be
a simple race between atl1_clean_rx_ring() and something (maybe even
pending atl1_intr_rx()) on the other cpu writing skb while kfreeing?

Regards,
Jarek P.

