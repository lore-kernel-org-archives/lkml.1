Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbXJaEOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbXJaEOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXJaEOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:14:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34451
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752222AbXJaEOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:14:05 -0400
Date: Tue, 30 Oct 2007 21:14:04 -0700 (PDT)
Message-Id: <20071030.211404.43558275.davem@davemloft.net>
To: sam@ravnborg.org
Cc: raa.lkml@gmail.com, linux-kernel@vger.kernel.org, per.liden@ericsson.com,
       allan.stephens@windriver.com
Subject: Re: tipc_config.h requires linux/string.h, which does not exist in
 exported headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071030.153154.241148799.davem@davemloft.net>
References: <20071030.150537.240140474.davem@davemloft.net>
	<20071030222025.GA19792@uranus.ravnborg.org>
	<20071030.153154.241148799.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 30 Oct 2007 15:31:54 -0700 (PDT)

> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Tue, 30 Oct 2007 23:20:25 +0100
> 
> > Something like this..
> > I like it - much better than adding string.h to unidef-y.
> > PS - had not pulled latest -linus - so you must update Kbuild.
> > PPS - tipc.h should be exported too as I understood Stephen.
> 
> tipc.h is already listed in header-y.
> 
> I'll merge your patch, thanks Sam.

Unfortunately I have to back it out, it breaks the build.

In file included from net/tipc/core.h:41,
                 from net/tipc/addr.c:37:
include/linux/tipc_config.h: In function 'TLV_SET':
include/linux/tipc_config.h:306: error: implicit declaration of function 'memcpy'
include/linux/tipc_config.h:306: warning: incompatible implicit declaration of built-in function 'memcpy'

I truly think adding linux/string.h to unifdef-y along with:

#ifndef __KERNEL__
#include <string.h>
#else
 ...
#endif

in linux/string.h is a much cleaner and less error prone solution :-)
