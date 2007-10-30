Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbXJ3WGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbXJ3WGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbXJ3WFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:05:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39436
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbXJ3WFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:05:52 -0400
Date: Tue, 30 Oct 2007 15:05:37 -0700 (PDT)
Message-Id: <20071030.150537.240140474.davem@davemloft.net>
To: sam@ravnborg.org
Cc: raa.lkml@gmail.com, linux-kernel@vger.kernel.org, per.liden@ericsson.com,
       allan.stephens@windriver.com
Subject: Re: tipc_config.h requires linux/string.h, which does not exist in
 exported headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071030.145926.219328422.davem@davemloft.net>
References: <20071030191317.GB9403@steel.home>
	<20071030215409.GB19598@uranus.ravnborg.org>
	<20071030.145926.219328422.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 30 Oct 2007 14:59:26 -0700 (PDT)

> I think the thing to do is just __KERNEL__ protect the
> <linux/string.h> include and require userspace to
> include <string.h> itself when using these headers.
> 
> That's what I'm testing right now.
> 
> I'm pretty sure those inlines are indeed used by userspace.

Actually, I'm tempted to put <string.h> in the ifndef __KERNEL__
block of that header.

That's ugly.

An alternative is to add linux/string.h to unifdef-y and have it
include <string.h> when !__KERNEL__ in order to handle cases like
this.

Sam, what do you think of that idea?
