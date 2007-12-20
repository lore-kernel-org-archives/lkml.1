Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbXLTSgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbXLTSgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXLTSgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:36:43 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:43703 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbXLTSgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:36:42 -0500
Date: Thu, 20 Dec 2007 11:36:41 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Tony Camuso <tcamuso@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071220183641.GG29690@parisc-linux.org>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AB4B8.90307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476AB4B8.90307@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 01:30:16PM -0500, Tony Camuso wrote:
> Matthew Wilcox wrote:
> 
> >Bad deduction.  What's happening is that the write to the BAR is causing
> >it to overlap the decode for mmconfig space.  So the mmconfig write to
> >set the BAR back never gets through.
> >
> >I have a different idea to fix this problem.  Instead of writing
> >0xffffffff, we could look for an unused bit of space in the E820 map and
> >write, say, 0xdfffffff to the low 32-bits of a BAR.  Then it wouldn't
> >overlap, and we could find its size using MMCONFIG.
> >
> The BAR claims to be a 64-bit BAR.

And what's in the upper 32 bits by default?  I'm guessing all zeroes.
We size 64-bit BARs by writing to each half individually.  So I bet this
one still overlaps the MMCONFIG space at 0xf0000000.

> As far as I know, Windows has a blacklist that limits systems with these
> devices to legacy PCI config access.

I don't think that's true.  If the people designing these machines had
noticed Windows failing to boot on them, they'd've fixed the BIOS to put
the MMCONFIG region elsewhere, not hacked Windows until it worked.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
