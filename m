Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbXEMVqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbXEMVqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbXEMVq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:46:26 -0400
Received: from verein.lst.de ([213.95.11.210]:55195 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111AbXEMVq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:46:26 -0400
Date: Sun, 13 May 2007 23:46:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Olof Johansson <olof@lixom.net>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcmcia: ppc64 needs 64-bit ioaddr_t
Message-ID: <20070513214608.GA26187@lst.de>
References: <20070512143105.GA12890@lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512143105.GA12890@lixom.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 09:31:05AM -0500, Olof Johansson wrote:
> ppc64 really needs ioaddr_t to be 64-bit, since I/O addresses really
> are MMIO addresses, and remapped to a high range.
> 
> While the type is exported to userspace, there hasn't been any platforms
> with PCMCIA on 64-bit powerpc until now, so changing it won't regress
> any existing users.

In fact the only use of the type should be in the obsolete ioctl-based user
interface.  So instead of changing the size of the type you should

 a) make sure you're not using cardmgr
 b) fix up those places that still use ioaddr_t where they shouldn't
    and switch the to kio_addr_t (why not just unsigned long like all
    other busses?) 

