Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbXLFIx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbXLFIx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 03:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXLFIxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 03:53:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44949
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbXLFIxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 03:53:45 -0500
Date: Thu, 06 Dec 2007 00:53:44 -0800 (PST)
Message-Id: <20071206.005344.74817074.davem@davemloft.net>
To: stefan@loplof.de
Cc: herbert@gondor.apana.org.au, simon@fire.lp0.eu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sockets affected by IPsec always block (2.6.23)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200712060949.02524.stefan@loplof.de>
References: <200712051939.08384.stefan@loplof.de>
	<20071205.182500.166603251.davem@davemloft.net>
	<200712060949.02524.stefan@loplof.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Rompf <stefan@loplof.de>
Date: Thu, 6 Dec 2007 09:49:01 +0100

> "If the connection cannot be established immediately and O_NONBLOCK is set for 
> the file descriptor for the socket, connect() shall fail and set errno to 
> [EINPROGRESS], but the connection request shall not be aborted, and the 
> connection shall be established asynchronously."
> 
> I think the words "shall fail" and "immediately" are quite clear.

They are, but the context in which they apply is vague.

I can equally generate examples where the non-blocking behavior you
are a proponent of would break non-blocking UDP apps during a
sendmsg() call when we hit IPSEC resolution.  Yet similar language on
blocking semantics exists for sendmsg() in the standards.

The world is shades of gray, implying anything else is foolhardy and
that's how I'm handling this.

> Well, the only reason this doesn't break on a daily basis is because the code 
> isn't in the kernel that long and not many people run applications on an 
> IPSEC gateway. This will change if kernel based IPSEC is used for roadwarrior 
> connections or dnssec based anonymous IPSEC someday. Trust me, you will 
> revert this misbehaviour in -stable then.

I use IPSEC every single day in this fashion, and I haven't.
