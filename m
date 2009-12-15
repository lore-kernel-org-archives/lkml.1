Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbZLOMjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbZLOMjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 07:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbZLOMjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 07:39:52 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44805 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbZLOMjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 07:39:52 -0500
Date: Tue, 15 Dec 2009 13:39:51 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com
Subject: Re: kexec boot regression
Message-ID: <20091215123951.GD28252@kernel.dk>
References: <20091215115052.GA28252@kernel.dk> <4B277AB2.8030107@kernel.org> <20091215121436.GB28252@kernel.dk> <4B2781AC.8020301@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2781AC.8020301@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15 2009, Yinghai Lu wrote:
> Jens Axboe wrote:
> > On Tue, Dec 15 2009, Yinghai Lu wrote:
> >> Jens Axboe wrote:
> >>> Hi,
> >>>
> >>> I have this big box that takes forever to boot, so I use kexec to boot
> >>> into new kernels. Works fine, but some time past 2.6.32 it stopped
> >>> working. Instead of wasting brain cycles on finding out why, I handed
> >>> the problem to my trusty regression friend - git bisect.
> >>>
> >>> This is what it found (sorry Yinghai it's you again, you owe me a beer
> >>> for hours of 2.6.32-git bisecting ;-)
> >> sure.
> >>
> >>>
> >>> 99935a7a59eaca0292c1a5880e10bae03f4a5e3d is the first bad commit
> >>> commit 99935a7a59eaca0292c1a5880e10bae03f4a5e3d
> >>> Author: Yinghai Lu <yinghai@kernel.org>
> >>> Date:   Sun Oct 4 21:54:24 2009 -0700
> >>>
> >>>     x86/PCI: read root resources from IOH on Intel
> >>>     
> >>>     For intel systems with multi IOH, we should read peer root resources
> >>>     directly from PCI config space, and don't trust _CRS.
> >>>
> >>>
> >>> I could not revert this single commit, as a further commit made other
> >>> changes. So I reverted 67f241f4 first and then 99935a7a. I confirmed
> >>> that this kernel then works fine.
> >>>
> >> let see how BIOS mess it up again!
> > 
> > Heh, I had a feeling this was coming :-)
> > 
> >> please.
> > 
> > Please find two logs attached - one from a boot with -git and the two
> > patches reverted, and one from a boot with -git.
> 
> please enabled CONFIG_PCI_DEBUG and boot with debug in boot command line.

On the good or bad kernel?

-- 
Jens Axboe

