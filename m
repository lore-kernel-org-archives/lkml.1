Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbZHNVpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbZHNVpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZHNVpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:45:03 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:49787 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZHNVpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:45:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADN4hUqrR7PE/2dsb2JhbAC5cYgtkHwFhBk
X-IronPort-AV: E=Sophos;i="4.43,382,1246838400"; 
   d="scan'208";a="195798144"
Date: Fri, 14 Aug 2009 14:45:03 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com
Subject: Re: [PATCH 1/2] Use kfifo to buffer USB generic serial writes
Message-ID: <20090814214503.GA9051@cuplxvomd02.corp.sa.net>
References: <20090814200251.GA26258@cuplxvomd02.corp.sa.net> <20090814222039.0cc29713@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814222039.0cc29713@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-4; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 10:20:39PM +0100, Alan Cox wrote:
> > +		spin_lock_irqsave(&port->write_fifo_lock, flags);
> > +		chars = __kfifo_len(port->write_fifo);
> > +		spin_unlock_irqrestore(&port->write_fifo_lock, flags);
> 
> Any reason for not using kfifo_len() ?

Nope. At one time there was a bit more code protected here and when I took it
out, I missed the opportunity to squash it down. I'll incorporate this with
any other changes that come in.

> Alan
