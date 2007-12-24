Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbXLXIJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbXLXIJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 03:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbXLXIJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 03:09:42 -0500
Received: from colo.lackof.org ([198.49.126.79]:54880 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbXLXIJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 03:09:41 -0500
Date: Mon, 24 Dec 2007 01:09:22 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Loic Prylli <loic@myri.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Tony Camuso <tcamuso@redhat.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071224080922.GE3758@colo.lackof.org>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476EC218.6030000@myri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476EC218.6030000@myri.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 03:16:24PM -0500, Loic Prylli wrote:
...
> I just realized one thing: the bar sizing code in pci_read_bases() (that
> writes 0xffffffff in the bars) does not seem to disable the
> PCI_COMMAND_MEM/PCI_COMMAND_IO bits in the cmd register before
> manipulating the BARs. And it seems nobody else ensures they are
> disabled at this point either (or am I missing something?).

You are missing some history... I posted such a patch in 2002:
    http://lkml.org/lkml/2002/12/19/145

> Touching the bars while they are enabled would be buggy behaviour from
> our part, and something trivial to fix. And it might well fix that
> particular problem (it's fair play from the machine to crash if we
> create a decoding conflict, simply disabling the cmd bits in
> pci_read_bases() should remove that conflict).

ISTR willy or Ivan recently posted a patch that was suggested in 2002
as well (don't disable MMIO on bridge devices when sizing BARs)...so the
main objections might be resolved to this "obvious fix". *sigh*

> FWIW, to partially answer your last question, Windows does disable
> mem-space and/or IO-space when sizing the bars of a device (I have some
> traces of configuration-space-access taken on a window machine for one
> of the PCI busses).

Thanks for posting the traces...it's past midnight here and I'll try to
look at those tomorrow. (Sorry - sounds like a lame excuse but I'm likely
to read the trace incorrectly at the moment.)

cheers,
grant
