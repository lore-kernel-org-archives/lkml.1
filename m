Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZHBRZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZHBRZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 13:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZHBRZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 13:25:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59077 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbZHBRZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 13:25:32 -0400
Date: Sun, 2 Aug 2009 11:25:33 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
Message-ID: <20090802172532.GD3711@parisc-linux.org>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090802171550.GC3711@parisc-linux.org> <alpine.LFD.2.01.0908021018420.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908021018420.3352@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 10:19:42AM -0700, Linus Torvalds wrote:
> On Sun, 2 Aug 2009, Matthew Wilcox wrote:
> > 
> > It *might* break HP's ia64 machines.  I have this feeling that the serial
> > ports may be claimed in the resource tree before the PCI resources are
> > claimed (and then they need to nest under a PCI bus).
> > 
> > How about this variant which will insert_resource for _bus_ resources,
> > but request_resource for _device_ resources?
> 
> Ugh. Please no. Hackery like this will just lead to unmaintainable crud in 
> the long run. Can you just fix ia64 instead? The firmware resources should 
> be added _after_ the PCI resource tree has been walked, not before.

I'll take a look later if Andrew doesn't beat me to it.  I still happen
to have two of those machines in my basement.  But my wife is hassling
me to go out now (it's not crazy 40C in Ottawa ...)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
