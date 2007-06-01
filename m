Return-Path: <linux-kernel-owner+w=401wt.eu-S1764816AbXFAVTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764816AbXFAVTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764521AbXFAVTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:19:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38635 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764514AbXFAVTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:19:44 -0400
Date: Fri, 1 Jun 2007 23:19:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <andi@firstfloor.org>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Message-ID: <20070601211943.GO7217@one.firstfloor.org>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011210.15808.jbarnes@virtuousgeek.org> <p73k5unbcnq.fsf@bingen.suse.de> <200706011407.51779.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706011407.51779.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 02:07:51PM -0700, Jesse Barnes wrote:
> On Friday, June 1, 2007 2:14:17 Andi Kleen wrote:
> > Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> > > (or we get proper PAT support, which I think would make this problem
> > > go away as well).
> >
> > No it won't. If the basic MTRRs for memory are wrong just having PAT
> > support in drivers (which already exist in a limited form already, just for
> > UC only) won't change anything.
> 
> No obviously just using PAT for drivers wouldn't help, I was thinking more of 
> having one PAT type be WB memory, and using it by default for most PTEs 

Then the BIOS couldn't override it anymore in case it is needed somewhere.
e.g. normally we just use normal 2MB direct mappings for the hole 
if there is memory beyond it and the hole doesn't need to be 2MB aligned.
Just assuming UC for all reserved pages would be also pretty drastic
and likely result in many 2MB pages being split and using a lot more 
TLB.

> covering normal memory.  If that's not possible, then it seems sensible to 

And normally the MTRRs win, don't they (if I remember the table correctly) 
So if the MTRR says UC and PAT disagrees it might not actually help

-Andi
