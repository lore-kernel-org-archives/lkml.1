Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbXLTSt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbXLTSt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXLTStu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:49:50 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1842 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753254AbXLTStu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:49:50 -0500
Message-ID: <476AB920.7040604@myri.com>
Date: Thu, 20 Dec 2007 13:49:04 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Tony Camuso <tcamuso@redhat.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org>
In-Reply-To: <20071220181603.GF29690@parisc-linux.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/20/2007 1:16 PM, Matthew Wilcox wrote:
>
> Bad deduction.  What's happening is that the write to the BAR is causing
> it to overlap the decode for mmconfig space.  So the mmconfig write to
> set the BAR back never gets through.
>
> I have a different idea to fix this problem.  Instead of writing
> 0xffffffff, we could look for an unused bit of space in the E820 map and
> write, say, 0xdfffffff to the low 32-bits of a BAR.  Then it wouldn't
> overlap, and we could find its size using MMCONFIG.
>
> Does anyone know how Windows handles these machines?  Obviously, if it's
> using MMCONFIG, it'd have the same problems.  Does it just use type 1
> for initial sizing?  Or does it use type 1 for all accesses below 256
> bytes?
>   



Always using type 1 for accesses below 256 bytes looks like a very very
attractive solution

I know we had a lot of older kernels over the last two years that we
patched like that (we needed MMCONFIG for our own device development
purposes, but we also needed our machines to boot and discover all
devices reliably). Recent kernels works fine out of the box on all
hardware we have, but all this sometimes tricky and apparently endless
work (in big part because of buggy BIOSes) about MMCONFIG would probably
become relatively easy by limiting the aim to have MMCONFIG work when it
is required (for cfg-space accesses >= 256).


Loic

