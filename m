Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbXHZOHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbXHZOHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 10:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXHZOHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 10:07:45 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47594 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbXHZOHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 10:07:45 -0400
Date: Sun, 26 Aug 2007 08:07:44 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Jesse Barnes <jesse.barnes@intel.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Fix boot-time hang on G31/G33 PC
Message-ID: <20070826140743.GF14130@parisc-linux.org>
References: <20070826015556.GC14130@parisc-linux.org> <46D10099.40401@shaw.ca> <20070826125542.GD14130@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070826125542.GD14130@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2007 at 06:55:42AM -0600, Matthew Wilcox wrote:
> On Sat, Aug 25, 2007 at 10:24:57PM -0600, Robert Hancock wrote:
> > We've already got a patch for this in Greg's PCI tree, hopefully it 
> > should go in for 2.6.24.
> 
> I haven't seen it.  I guess it wasn't sent to the PCI mailing list.
> 
> Your patch had two or three problems with it; assuming we're talking
> about the same patch.

I found
http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=pci/pci-disable-decode-of-io-memory-during-bar-sizing.patch;h=958ef4e837733206a80f058aee236847eec5fbd8;hb=HEAD

which has two problems:

 - With a 64-bit BAR, it checks to see if the upper 32 bits represent IO
   or memory.  You can't do that to the upper 32 bits.
 - It does a lot of additional writes to the cmd register; my patch does two
   writes per device; yours does two per BAR

It's also a lot more complex than my patch, IMO.

Greg, please drop Robert's patch and put mine in instead.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
