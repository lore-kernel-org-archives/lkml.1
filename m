Return-Path: <linux-kernel-owner+w=401wt.eu-S1751523AbXB0F3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbXB0F3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 00:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXB0F3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 00:29:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32836
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbXB0F3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 00:29:03 -0500
Date: Mon, 26 Feb 2007 21:29:02 -0800 (PST)
Message-Id: <20070226.212902.78711266.davem@davemloft.net>
To: Joerg.Friedrich@friedrich-kn.de
Cc: j.j.green@sheffield.ac.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc64 / bbc_i2c.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070227052239.GA30083@stardust.friedrich-kn.de>
References: <Pine.LNX.4.64.0702252352310.32309@parallax.ddns.shef.ac.uk>
	<20070226.101219.18306730.davem@davemloft.net>
	<20070227052239.GA30083@stardust.friedrich-kn.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Friedrich <Joerg.Friedrich@friedrich-kn.de>
Date: Tue, 27 Feb 2007 06:22:39 +0100

> Can you just tell me if it's sufficient to check for  a return value >0
> of wait_event_interruptible_timeout? I was not sure so I extended the
> check to 
> if ((val != -ERESTARTSYS) && (val > 0))

I changed the check to just "val > 0".

The comments in the kernel around the implementation and
declaration of the function wait_event_interruptible()
VERY CLEARLY state that the possible return values are:

1) Negative error code on interrupt
2) Zero if timeout expired
3) Positive non-zero value if condition became true before
   timeout expired

So there is no doubt that "val > 0" is sufficient.
