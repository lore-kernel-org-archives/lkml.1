Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbYBSAfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbYBSAfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYBSAfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:35:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43691
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbYBSAfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:35:18 -0500
Date: Mon, 18 Feb 2008 16:35:54 -0800 (PST)
Message-Id: <20080218.163554.74130592.davem@davemloft.net>
To: mchan@broadcom.com
Cc: tonyb@cybernetics.com, herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: TG3 network data corruption regression 2.6.24/2.6.23.4
From: David Miller <davem@davemloft.net>
In-Reply-To: <1203381120.13495.78.camel@dell>
References: <47BA0984.2070306@cybernetics.com>
	<1203381120.13495.78.camel@dell>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Mon, 18 Feb 2008 16:32:00 -0800

> On Mon, 2008-02-18 at 17:41 -0500, Tony Battersby wrote:
> > I am experiencing network data corruption with a 3Com 3C996B-T NIC
> > (Broadcom NetXtreme BCM5701; driver tg3.ko).  I have identified the
> > following patch as the trigger:
> 
> Assuming this problem is unique to the 5701, I'm not sure how it is
> exposed by Herbert's patch.  One thing unique on the 5701 is that it
> double-copies all RX packets so that the data starts at offset 2, but
> that's quite unrelated to the patch below.

One consequence of Herbert's change is that the chip will see a
different datastream.  The initial skb->data linear area will be
smaller, and the transition to the fragmented area of pages will be
quicker.
