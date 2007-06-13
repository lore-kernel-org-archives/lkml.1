Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbXFMC30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbXFMC30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 22:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXFMC3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 22:29:18 -0400
Received: from outbound-mail-18.bluehost.com ([69.89.20.233]:39130 "HELO
	outbound-mail-18.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752766AbXFMC3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 22:29:18 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Tue, 12 Jun 2007 19:29:07 -0700
User-Agent: KMail/1.9.6
Cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>
References: <200706061229.24486.jesse.barnes@intel.com> <m14plcpsjq.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14plcpsjq.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706121929.07527.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 12, 2007 6:11:21 Eric W. Biederman wrote:
> Jesse Barnes <jesse.barnes@intel.com> writes:
> > On some machines, buggy BIOSes don't properly setup WB MTRRs to
> > cover all available RAM, meaning the last few megs (or even gigs)
> > of memory will be marked uncached.  Since Linux tends to allocate
> > from high memory addresses first, this causes the machine to be
> > unusably slow as soon as the kernel starts really using memory
> > (i.e. right around init time).
> >
> > This patch works around the problem by scanning the MTRRs at
> > boot and figuring out whether the current end_pfn value (setup
> > by early e820 code) goes beyond the highest WB MTRR range, and
> > if so, trimming it to match.  A fairly obnoxious KERN_WARNING
> > is printed too, letting the user know that not all of their
> > memory is available due to a likely BIOS bug.
>
> A quick update.  This patch is horribly incorrect on a socket F
> opteron/Athlon 64 with memory above 4GB.
>
> In particular those cpus are capable of mapping all of memory
> above 4GB as write back without using a single MTRR.
>
> So examining MTRRs is insufficient.

Hm, yuck.  What do you suggest?  Should we only run this check when Intel 
chips are present?  Checking only the bottom 4G isn't sufficient since we've 
seen platforms that have issues above that range...

Thanks,
Jesse
