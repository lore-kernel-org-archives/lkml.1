Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbXLTSac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbXLTSac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbXLTSaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:30:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbXLTSaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:30:22 -0500
Message-ID: <476AB4B8.90307@redhat.com>
Date: Thu, 20 Dec 2007 13:30:16 -0500
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
The BAR claims to be a 64-bit BAR.

> Does anyone know how Windows handles these machines?  Obviously, if it's
> using MMCONFIG, it'd have the same problems.  Does it just use type 1
> for initial sizing?  Or does it use type 1 for all accesses below 256
> bytes?
> 
As far as I know, Windows has a blacklist that limits systems with these
devices to legacy PCI config access.

