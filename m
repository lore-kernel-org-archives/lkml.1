Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbYCUNvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbYCUNvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYCUNvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:51:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39980 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbYCUNvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:51:31 -0400
Date: Fri, 21 Mar 2008 14:54:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080321135418.GB2346@one.firstfloor.org>
References: <20080320111429.GA14764@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320111429.GA14764@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 12:14:29PM +0100, Pavel Machek wrote:
> Hi!
> 
> On 64-bit machine with 4GB ram (8core from amd), iommu breaks USB
> after swsusp. iommu=soft fixes that issue.
> 
> I guess iommu handling in arch/x86/kernel/ should have some
> suspend/resume support, as it manipulates hardware registers...?

AGP suspend/resume should already handle restoring of the aperture
and the IOMMU code uses the same.  It has not other state. It might not work 
when the AGP driver is not compiled in/loaded though (I suspect
that is what happened to you) One simple fix would be to just enforce
that in Kconfig when suspend/resume is enabled.

-Andi
