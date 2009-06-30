Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbZF3CZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbZF3CZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 22:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760254AbZF3CYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 22:24:52 -0400
Received: from mga06.intel.com ([134.134.136.21]:29100 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757740AbZF3CYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 22:24:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,313,1243839600"; 
   d="scan'208";a="528914943"
Date: Mon, 29 Jun 2009 19:24:53 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: pci tree build failure
Message-ID: <20090630022453.GE24061@linux.intel.com>
References: <20090630120727.24450bab.sfr@canb.auug.org.au> <20090629191324.5c86bbc0@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629191324.5c86bbc0@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 07:13:24PM -0700, Jesse Barnes wrote:
> On Tue, 30 Jun 2009 12:07:27 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Jesse,
> > 
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > 
> > ERROR: "pci_claim_resource" [drivers/pcmcia/yenta_socket.ko]
> > undefined!
> > 
> > Caused by commit 6bb04b65dbff5a5bb01617351dbb0af577084752 ("yenta: Use
> > pci_claim_resource").  yenta can be built as a module, but
> > pci_claim_resource is not exported ...
> > 
> > I have used the pci tree from next-20090629 for today.
> 
> Damn, thought I built that.  linux-next earns its keep yet again.

Sorry about that.  I thought I'd checked that.  Must have been confused
with another function.  There do seem to be legitimate *drivers*
that could use it (i2o for one), so I propose making it a full-bodied
'EXPORT_SYMBOL' and not bother with the _GPL tag.  Thoughts?
