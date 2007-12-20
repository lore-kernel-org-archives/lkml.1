Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbXLTTiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbXLTTiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbXLTThy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:37:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbXLTThx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:37:53 -0500
Message-ID: <476AC48D.6000103@redhat.com>
Date: Thu, 20 Dec 2007 14:37:49 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org>
In-Reply-To: <20071220181603.GF29690@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:

> Bad deduction.  What's happening is that the write to the BAR is causing
> it to overlap the decode for mmconfig space.  So the mmconfig write to
> set the BAR back never gets through.
> 
> I have a different idea to fix this problem.  Instead of writing
> 0xffffffff, we could look for an unused bit of space in the E820 map and
> write, say, 0xdfffffff to the low 32-bits of a BAR.  Then it wouldn't
> overlap, and we could find its size using MMCONFIG.
> 
Let me see if I understand this correctly.

Writing this BAR with 0xffffffff causes it to decode all further mmconfig
references based at addr 0xfxxxxxxx as its own?

If I've got that right, then why don't any of the other BARs do that? Is
it because this one's a 64-bit BAR?

AFIK, there are no devices out there that require 32-bits of address
space, so using 0xdfffffff in the low register would certainly work.

However, the PCI spec says that we should be able to write 0xffffffff
to the BAR, buggy BIOS and hardware notwithstanding.

Does anybody see that change as being within the purview of the patch-set
I am proposing? Or is that another patch for another time?
