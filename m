Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbYAKUmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbYAKUmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 15:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761500AbYAKUma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 15:42:30 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:41386 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761151AbYAKUma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 15:42:30 -0500
Date: Fri, 11 Jan 2008 13:42:28 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080111204228.GP18741@parisc-linux.org>
References: <20071225032605.29147200@laptopd505.fenrus.org> <20080111190229.GB10112@kroah.com> <20080111192820.GM18741@parisc-linux.org> <20080111114002.3e59d1ad@laptopd505.fenrus.org> <20080111194524.GA17170@suse.de> <20080111194931.GN18741@parisc-linux.org> <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org> <20080111201716.GO18741@parisc-linux.org> <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 12:27:06PM -0800, Linus Torvalds wrote:
> On Fri, 11 Jan 2008, Matthew Wilcox wrote:
> > 
> > Ivan's patch doesn't start enabling MMCONFIG in more places than we
> > currently do.  It makes us use conf1 accesses for all accesses below
> > 256 bytes.  That fixes all known problems to date.
> 
> .. and I agree with that patch. But there will be people who try to access 
> extended space by mistake, and they'll have a hard-locked machine or 
> something.

But they can't.  We limit the size they can access to 256 bytes, unless
the kernel probed address 256 and it worked.

> > The armour plating that already exists -- pci=nommconf.
> 
> No. It needs to be automatic, OR THE OTHER WAY AROUND.
> 
> Ie we disable the unsafe feature on purpose, and then force people who 
> access it to do so *consciously*.

I'd be fine with making mmconfig off by default.  Make people pass
pci=mmconf to activate it.

> Extended config space is different, for chissake! It's not even like it's 
> just a bigger normal config space where normal config accesses just 
> overflow into it. It really does have different rules etc.

Yes, but it's also important to enable some of the PCIe features.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
