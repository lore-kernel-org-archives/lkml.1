Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYASHwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYASHwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 02:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYASHwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 02:52:09 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41380 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYASHwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 02:52:08 -0500
Date: Fri, 18 Jan 2008 23:58:19 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] X86: fix typo PAT to X86_PAT
In-reply-to: <20080119032849.GA16757@redhat.com>
To: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, venkatesh.pallipadi@intel.com,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200801182358.19394.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <20080118123140.GI11044@elte.hu> <20080118210210.GB10717@elte.hu>
 <20080119032849.GA16757@redhat.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 07:28:49 pm Dave Jones wrote:
> On Fri, Jan 18, 2008 at 10:02:10PM +0100, Ingo Molnar wrote:
>  > 
>  > * Dave Jones <davej@redhat.com> wrote:
>  > 
>  > >  > you mean modifies MTRRs? Which code is that? (besides the 
>  > >  > /proc/mtrr userspace API)
>  > > 
>  > > This exclusion is going to be a real pain in the ass for distro 
>  > > kernels. It's impossible for example to build a kernel that will now 
>  > > support the MTRR-alike registers on the AMD K6/early Cyrix etc and 
>  > > also support PAT.
>  > > 
>  > > Additionally, given people tend to update their kernels a lot more 
>  > > often than they update to a whole new version of X, it means until 
>  > > userspace has caught up, we can't ship a kernel with PAT supported, or 
>  > > else X gets a lot slower due to the missing mtrr support.
>  > 
>  > there's no exclusion enforced right now, and if a CPU is PAT-incapable 
>  > (or if the kernel is booted nopat) then the MTRR bits should be usable. 
>  > But if we boot with PAT enabled, and Xorg gets /proc/mtrr wrong, we'll 
>  > see nasty crashes. If it gets them right, it should all still work just 
>  > fine. Is this ok? Then, in a year or two, distros can disable write 
>  > support to /proc/mtrr. Hm?
> 
> A crazy idea just occured to me..  We could make /proc/mtrr an interface
> to set PAT on a range of memory.  This would make it transparently work
> without any changes in X or anything else that sets them in userspace.

goog idea...

we need to make X86_PAT depend on MTRR in arch/x86/Kconfig

YH
