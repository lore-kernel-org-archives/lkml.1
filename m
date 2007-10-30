Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbXJ3V75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbXJ3V75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbXJ3V7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:59:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46835
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755512AbXJ3V7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:59:42 -0400
Date: Tue, 30 Oct 2007 14:59:26 -0700 (PDT)
Message-Id: <20071030.145926.219328422.davem@davemloft.net>
To: sam@ravnborg.org
Cc: raa.lkml@gmail.com, linux-kernel@vger.kernel.org, per.liden@ericsson.com,
       allan.stephens@windriver.com
Subject: Re: tipc_config.h requires linux/string.h, which does not exist in
 exported headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071030215409.GB19598@uranus.ravnborg.org>
References: <20071030191317.GB9403@steel.home>
	<20071030215409.GB19598@uranus.ravnborg.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 30 Oct 2007 22:54:09 +0100

> tipc_config.h uses memcpy in an inline function that is
> never used in the kernel.
> I'm awaiting response from tipc people if we can kill
> that inline or we should make it a macro.
> But davem decided just to include tipc_config.h and will now
> sort it out.

I think the thing to do is just __KERNEL__ protect the
<linux/string.h> include and require userspace to
include <string.h> itself when using these headers.

That's what I'm testing right now.

I'm pretty sure those inlines are indeed used by userspace.
