Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbZHBURy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbZHBURy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZHBURx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:17:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbZHBURw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:17:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
Date: Sun, 2 Aug 2009 22:18:27 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Matthew Wilcox <willy@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200908021619.48285.rjw@sisk.pl> <20090802165926.GB3711@parisc-linux.org>
In-Reply-To: <20090802165926.GB3711@parisc-linux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908022218.27939.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 August 2009, Matthew Wilcox wrote:
> On Sun, Aug 02, 2009 at 04:19:47PM +0200, Rafael J. Wysocki wrote:
> > Hi Matthew,
> > 
> > As reported at
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=13891
> > 
> > there is a problem with allocating PCI resources on HP nx6325 introduced by
> > your commit a76117dfd687ec4be0a9a05214f3009cc5f73a42
> > (x86: Use pci_claim_resource).
> > 
> > On this particular box it causes the audio adapter's PCI memory space to
> > be allocated for something else.
> 
> Could you also attach lspci -v?  It seems that the 0000:00:12.0 resource
> is nesting inside the 0000:00:14.2 resource, which is just not possible.

It only looks like that in the failing case, though.

> Also, could you boot -rc5 (without
> a76117dfd687ec4be0a9a05214f3009cc5f73a42 reverted) with this patch
> applied?  It may give us some idea of what's going wrong.

I tested the Linus' patch replacing insert_resource() with request_resource()
and it worked, so do you still want me to provide this information?

Rafael
