Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZFQU7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZFQU7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZFQU7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:59:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57239 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbZFQU7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:59:04 -0400
Date: Wed, 17 Jun 2009 14:59:05 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, jbarnes@virtuousgeek.org,
       andrew.patterson@hp.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ia64: Fix resource assignment for root busses
Message-ID: <20090617205905.GX19977@parisc-linux.org>
References: <1245270816-11755-1-git-send-email-willy@linux.intel.com> <1245270816-11755-5-git-send-email-willy@linux.intel.com> <alpine.LFD.2.01.0906171356040.16802@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906171356040.16802@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 01:56:39PM -0700, Linus Torvalds wrote:
> On Wed, 17 Jun 2009, Matthew Wilcox wrote:
> >
> > ia64 was assigning resources to root busses after allocations had
> > been made for child busses.  Calling pcibios_setup_root_windows() from
> > pcibios_fixup_bus() solves this problem by assigning the resources to
> > the root bus before child busses are scanned.
> > 
> > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> > Tested-by: Andrew Patterson <andrew.patterson@hp.com>
> 
> So I assume this "Tested-by:" means that Andrew confirmed that this 
> actually fixes the nesting? I wasn't cc'd on that, so I'm just checking..

Yes, he says it fixes the nesting problem, and as a result hotplug now works.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
