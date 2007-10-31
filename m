Return-Path: <linux-kernel-owner+w=401wt.eu-S1758440AbXJaXQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbXJaXQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 19:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbXJaXQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 19:16:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46378
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753074AbXJaXQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 19:16:31 -0400
Date: Wed, 31 Oct 2007 16:16:30 -0700 (PDT)
Message-Id: <20071031.161630.207675833.davem@davemloft.net>
To: davej@redhat.com
Cc: linux-kernel@vger.kernel.org, per.liden@ericsson.com,
       jon.maloy@ericsson.com, allan.stephens@windriver.com
Subject: Re: [PATCH] Fix make headers_check for tipc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071031212932.GA4933@redhat.com>
References: <20071031212932.GA4933@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>
Date: Wed, 31 Oct 2007 17:29:32 -0400

> make headers_check currently fails in mainline with..
> 
> include/linux/tipc_config.h requires linux/string.h, which does not exist in exported headers
> 
> There's no reason to even include this in this header as far as I can tell.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

It uses memcpy() in the inline routines which are in fact used by both
userspace and the kernel.  The change you are suggesting will also
break the TIPC kernel build.

A proper fix has been merged into Linus's tree already.
