Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbXLWU4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbXLWU4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 15:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXLWUz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 15:55:57 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:43928 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXLWUz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 15:55:57 -0500
Date: Sun, 23 Dec 2007 13:55:55 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Loic Prylli <loic@myri.com>
Cc: Tony Camuso <tcamuso@redhat.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071223205555.GV29690@parisc-linux.org>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476EC218.6030000@myri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476EC218.6030000@myri.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 03:16:24PM -0500, Loic Prylli wrote:
> I just realized one thing: the bar sizing code in pci_read_bases() (that
> writes 0xffffffff in the bars) does not seem to disable the
> PCI_COMMAND_MEM/PCI_COMMAND_IO bits in the cmd register before
> manipulating the BARs. And it seems nobody else ensures they are
> disabled at this point either (or am I missing something?).

Right, we don't.  Ivan and Greg are convinced that doing so can break
some machines.  

> FWIW, to partially answer your last question, Windows does disable
> mem-space and/or IO-space when sizing the bars of a device (I have some
> traces of configuration-space-access taken on a window machine for one
> of the PCI busses).

Now that contradicts some information we've been told before; can you
post those traces?  That would argue in favour of disabling memspace
when configuring BARs.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
