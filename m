Return-Path: <linux-kernel-owner+w=401wt.eu-S2993059AbXCIH3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993059AbXCIH3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993064AbXCIH3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:29:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46271
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2993058AbXCIH3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:29:08 -0500
Date: Thu, 08 Mar 2007 23:29:08 -0800 (PST)
Message-Id: <20070308.232908.92582631.davem@davemloft.net>
To: amit2030@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [REVISED] net/ipv4/multipath_wrandom.c: check
 kmalloc() return value.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070308232215.aa512aaa.amit2030@gmail.com>
References: <20070308232215.aa512aaa.amit2030@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Choudhary <amit2030@gmail.com>
Date: Thu, 8 Mar 2007 23:22:15 -0800

> Description: Check the return value of kmalloc() in function wrandom_set_nhinfo(), in file net/ipv4/multipath_wrandom.c.
> 
> Signed-off-by: Amit Choudhary <amit2030@gmail.com>

This kind of patch has been submitted several times before and it's
never accepted because you have to do much more than this to recover
from the allocation error.

There is no error status returned to the caller, so the callers assume
the operation succeeded, and will either OOPS or crash in some other
way.

Therefore, just adding some NULL pointer checks and returning is not
going to fix this bug.

The whole cahce-multipath subsystem has to have it's guts revamped for
proper error handling.
