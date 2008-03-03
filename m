Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYCCWC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYCCWC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYCCWCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:02:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37190
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751362AbYCCWCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:02:18 -0500
Date: Mon, 03 Mar 2008 14:02:03 -0800 (PST)
Message-Id: <20080303.140203.201465683.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: bunk@kernel.org, wli@holomorphy.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sparc vs. gcc 4.3
From: David Miller <davem@davemloft.net>
In-Reply-To: <1204580471.22933.17.camel@brick>
References: <20080303192651.GL26072@cs181133002.pp.htv.fi>
	<20080303.130348.25289482.davem@davemloft.net>
	<1204580471.22933.17.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Mon, 03 Mar 2008 13:41:11 -0800

> Could you hide the asm inside an actual function and annotate the
> function with __used?

Won't work, the asm needs to be inlined because it needs to:

1) Know where local variables are located

2) Has to run in the context of the stack frame the
   call site runs in so that the tail-call it's doing works

And actually all of this is why the sparc64 fix turned out to
be so invasive, and I'll need to do the same for sparc32
as a result.
