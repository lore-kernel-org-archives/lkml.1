Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbZLOMDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbZLOMDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 07:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbZLOMDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 07:03:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:45899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbZLOMDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 07:03:32 -0500
Message-ID: <4B277AB2.8030107@kernel.org>
Date: Tue, 15 Dec 2009 04:01:54 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com
Subject: Re: kexec boot regression
References: <20091215115052.GA28252@kernel.dk>
In-Reply-To: <20091215115052.GA28252@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Hi,
> 
> I have this big box that takes forever to boot, so I use kexec to boot
> into new kernels. Works fine, but some time past 2.6.32 it stopped
> working. Instead of wasting brain cycles on finding out why, I handed
> the problem to my trusty regression friend - git bisect.
> 
> This is what it found (sorry Yinghai it's you again, you owe me a beer
> for hours of 2.6.32-git bisecting ;-)

sure.

> 
> 
> 99935a7a59eaca0292c1a5880e10bae03f4a5e3d is the first bad commit
> commit 99935a7a59eaca0292c1a5880e10bae03f4a5e3d
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Sun Oct 4 21:54:24 2009 -0700
> 
>     x86/PCI: read root resources from IOH on Intel
>     
>     For intel systems with multi IOH, we should read peer root resources
>     directly from PCI config space, and don't trust _CRS.
> 
> 
> I could not revert this single commit, as a further commit made other
> changes. So I reverted 67f241f4 first and then 99935a7a. I confirmed
> that this kernel then works fine.
>

let see how BIOS mess it up again!
 
> With current -git, I get tons and tons of:
> 
> [   16.841724] pci 0000:00:01.0: BAR 7: no parent found for bridge [io
> 0x6000-0x6fff]
> [   16.850368] pci 0000:00:01.0: BAR 7: can't allocate [io
> 0x6000-0x6fff]
> [   16.857821] pci 0000:00:01.0: BAR 8: no parent found for bridge [mem
> 0x9bc00000-0x9bcfffff]
> [   16.867238] pci 0000:00:01.0: BAR 8: can't allocate [mem
> 0x9bc00000-0x9bcfffff]
> [   16.875492] pci 0000:00:02.0: BAR 7: no parent found for bridge [io
> 0x5000-0x5fff]
> [   16.884137] pci 0000:00:02.0: BAR 7: can't allocate [io
> 0x5000-0x5fff]
> [   16.891591] pci 0000:00:02.0: BAR 8: no parent found for bridge [mem
> 0x9bb00000-0x9bbfffff]
> [   16.901010] pci 0000:00:02.0: BAR 8: can't allocate [mem
> 0x9bb00000-0x9bbfffff]
> [   16.909264] pci 0000:00:03.0: BAR 7: no parent found for bridge [io
> 0x4000-0x4fff]
> [   16.917908] pci 0000:00:03.0: BAR 7: can't allocate [io
> 0x4000-0x4fff]
> [...]
> 
> I can provide a full log if needed.

please.

YH
