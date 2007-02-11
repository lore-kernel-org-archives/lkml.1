Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbXBKA4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbXBKA4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 19:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXBKA4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 19:56:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51524
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752492AbXBKA4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 19:56:05 -0500
Date: Sat, 10 Feb 2007 16:56:02 -0800 (PST)
Message-Id: <20070210.165602.07642259.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: zach.brown@oracle.com, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       suparna@in.ibm.com, bcrl@kvack.org, mingo@elte.hu
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	<Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Feb 2007 14:33:01 -0800 (PST)

> So I actually like this, because it means that while we slow down
> real IO, we don't slow down the cached cases at all.

Even if you have everything, every page, every log file, in the page
cache, everything talking over the network wants to block.

Will you create a thread every time tcp_sendmsg() hits the send queue
limits?

Add some logging to tcp_sendmsg() on a busy web server if you do not
believe me :-)

The idea is probably excellent for operations on real files, but it's
going to stink badly for networking stuff.
