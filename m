Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXEGKlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXEGKlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 06:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbXEGKlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 06:41:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37101
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932203AbXEGKlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 06:41:14 -0400
Date: Mon, 07 May 2007 03:41:17 -0700 (PDT)
Message-Id: <20070507.034117.115910272.davem@davemloft.net>
To: tilman@imap.cc
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, netdev@vger.kernel.org
Subject: Re: trying to track a change to drivers/isdn/usb-gigaset.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <463EF77A.9020808@imap.cc>
References: <463EF77A.9020808@imap.cc>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Mon, 07 May 2007 11:55:06 +0200

[ netdev@vger.kernel.org is the place to discuss kernel networking
  issues, thanks ]

> But I cannot remember seeing that patch via the maintainer
> addresses for ISDN or the Gigaset driver, and the LKML archive
> doesn't seem to have it either.
> 
> Where was that patch discussed? What is its rationale?

This was a wholesale change done across the entire tree, they were all
straightforward transformations that didn't change what the code did.

It was a change done so that we could hide the skb data buffering
details to the point where we could change the protocol header
pointers into 32-bit offsets which saves 4 bytes per such pointer per
protocol header stored in struct sk_buff.

We're not going to notify the maintainer of each of the hundreds of
source files we had to touch in order to pull this off, sorry.

These changes were posted to netdev@vger.kernel.org, they also
sat in Andrew Morton's -mm tree for quite some time.
