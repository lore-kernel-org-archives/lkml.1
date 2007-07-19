Return-Path: <linux-kernel-owner+w=401wt.eu-S1763882AbXGSH1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763882AbXGSH1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 03:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbXGSH1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 03:27:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54789
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbXGSH1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 03:27:17 -0400
Date: Thu, 19 Jul 2007 00:27:16 -0700 (PDT)
Message-Id: <20070719.002716.30181989.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Re: cmpxchg is not available to generic code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070719000549.1e57b5b2.akpm@linux-foundation.org>
References: <20070719000549.1e57b5b2.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 19 Jul 2007 00:05:49 -0700

> What's that code doing anyway?  driver-private locking primitives?

It's an atomic lock shared with userspace.  Whatever implementation is
used to do the lock on that object must be identical in the userspace
DRM bits.

Unlike futex, the lock operation on the user side isn't optional.
So if the platform can't do a true cmpxchg it generally cannot
support DRM.

