Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZGDSke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZGDSke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 14:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZGDSkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 14:40:24 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51944 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZGDSkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 14:40:23 -0400
Message-ID: <4A4FA212.8030506@monstr.eu>
Date: Sat, 04 Jul 2009 20:40:18 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Simek <monstr@monstr.eu>, Sam Ravnborg <sam@ravnborg.org>,
       Paul Mundt <lethal@linux-sh.org>, Tony Luck <tony.luck@intel.com>,
       tj@kernel.org
Subject: Re: [microblaze-uclinux] [RFC PATCH] linker script: unify usage of
 discard definition
References: <4A4E9638.20304@kernel.org>
In-Reply-To: <4A4E9638.20304@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Tejun Heo wrote:
> Discarded sections in different archs share some commonality but have
> considerable differences.  This led to linker script for each arch
> implementing its own /DISCARD/ definition, which makes maintaining
> tedious and adding new entries error-prone.
> 
> This patch makes all linker scripts to move discard definitions to the
> end of the linker script and use the common DISCARDS macro.  As ld
> uses the first matching section definition, archs can include default
> discarded sections by including them earlier in the linker script.
> 
> On x86-64 which explicitly includes EXIT_TEXT, this produces identical
> output as before and all but one archs included directives (include or
> discard) for all default discarded sections, so this patch shouldn't
> cause any behavior difference.
> 
> The only problem case is microblaze, which didn't explicitly included
> EXIT_TEXT and DATA but didn't discard them either leaving ld to create
> identically names output sections for them.  This patch will make the
> end result different by throwing away exit text and data.  It looks
> like the ommission was accidental and throwing away is the right thing
> to do, but I won't push it till someone who knows microblaze confirms
> it.

As you expected noMMU Microblaze kernel has some problems with that patch. (MMU version is fine)
I'll take a look at it closer yesterday.

Thanks,
Michal



> ___________________________
> microblaze-uclinux mailing list
> microblaze-uclinux@itee.uq.edu.au
> Project Home Page : http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
> Mailing List Archive : http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
> 
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
