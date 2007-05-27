Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbXE0Vr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbXE0Vr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759971AbXE0Vq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:46:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49864
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759951AbXE0Vq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:46:56 -0400
Date: Sun, 27 May 2007 14:47:02 -0700 (PDT)
Message-Id: <20070527.144702.55507425.davem@davemloft.net>
To: jengelh@linux01.gwdg.de
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Linux always started with 9600 8N1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070527.141622.30184020.davem@davemloft.net>
References: <20070526.154745.30164056.davem@davemloft.net>
	<Pine.LNX.4.61.0705271816310.7344@yvahk01.tjqt.qr>
	<20070527.141622.30184020.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 27 May 2007 14:16:22 -0700 (PDT)

> So even writes to so-called 'read-only' sections of the kernel image
> will work and therefore I don't understand what the bug could be other
> than the compiler "optimizing" away the write to the constant string
> in which case the compiler should have warned about it.

I just stared at the drivers/serial/suncore.s assembler a little
bit and this is indeed what appears to be happening, the compiler
is optimizing the stores away completely yet not doing so much
as emitting a warning, how rude :-)

Perhaps there is some warning option that isn't enabled which
would have caught this...

Thanks a lot for your patch, I'll apply it.
