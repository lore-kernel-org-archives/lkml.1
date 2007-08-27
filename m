Return-Path: <linux-kernel-owner+w=401wt.eu-S1764449AbXH0Vyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764449AbXH0Vyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933550AbXH0Vno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:43:44 -0400
Received: from mail.fieldses.org ([66.93.2.214]:49775 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbXH0Vnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:43:41 -0400
Date: Mon, 27 Aug 2007 17:43:33 -0400
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add source address to sunrpc svc errors
Message-ID: <20070827214333.GM3118@fieldses.org>
References: <20070825012630.GB5431@gallifrey> <20070824185621.3f16f7c9.randy.dunlap@oracle.com> <20070825150927.GA29335@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070825150927.GA29335@gallifrey>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2007 at 04:09:27PM +0100, Dr. David Alan Gilbert wrote:
>   This patch adds the address of the client that caused an
> error in sunrpc/svc.c so that you get errors that look like:
> 
> svc: 192.168.66.28, port=709: unknown version (3 for prog 100003, nfsd)
> 
> I've seen machines which get bunches of unknown version or similar
> errors from time to time, and while the recent patch to add
> the service helps to find which service has the wrong version it doesn't
> help find the potentially bad client.

Looks like a reasonable idea to me, thanks!  Any objection to just
calling it "svc_printk" instead of "svc_printkerr"?

I also wonder whether these shouldn't all be dprintk's instead of
printk's.  One misbehaving client could create a lot of noise in the
logs.

--b.
