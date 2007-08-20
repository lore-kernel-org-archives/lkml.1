Return-Path: <linux-kernel-owner+w=401wt.eu-S1762583AbXHTXB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762583AbXHTXB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXHTXBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:01:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37251
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbXHTXBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:01:50 -0400
Date: Mon, 20 Aug 2007 16:01:48 -0700 (PDT)
Message-Id: <20070820.160148.11597718.davem@davemloft.net>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB bug on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0708201124140.25298@schroedinger.engr.sgi.com>
References: <20070817.221758.116352652.davem@davemloft.net>
	<Pine.LNX.4.64.0708201124140.25298@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Mon, 20 Aug 2007 11:34:52 -0700 (PDT)

> On Fri, 17 Aug 2007, David Miller wrote:
> 
> > When I force SLUB debugging on sparc64, it barfs on early bootup while
> > making the sysfs nodes.  Removing the BUG()'s on the sysfs error
> > returns, and adding some tracing I captured the log below.
> > 
> > BTW, I would recommending removing the BUG() calls, they serve only to
> > force someone hitting them to edit them out and reboot which is
> > absolutely pointless :-) This code can also often run before the
> > console is first enabled, making analysis of the error return that
> > much harder if it BUG()'s instead of trying to continue.
> 
> Not sure what BUG's you are talking about.

The two BUG_ON()'s on "err" as returned from sysfs_slab_alias()
and sysfs_slab_add().

> Does this patch fix it?

Yep, it does, thanks a lot!
