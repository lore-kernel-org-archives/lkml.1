Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZDUKUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZDUKUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZDUKUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:20:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37351 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZDUKUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:20:41 -0400
Date: Tue, 21 Apr 2009 12:24:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections -fdata-sections
Message-ID: <20090421102402.GZ14687@one.firstfloor.org>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain> <alpine.DEB.1.10.0904202010220.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are there any advantages outside of the size things?

Yes ksplice needs it too.

> Do we end up packing data better? 

There used to be tools to do that (use profile feedback to pack
code), but I'm not sure they would help the kernel too much
because they were mostly aimed at demand paging. But such tools
definitely would need this infrastructure. Iirc there are some architectures
othat benefit from hold/cold partioning during execution.

> I'd like to have some more champions of this code, in other words.

I definitely like the size angle -- letting the linker eliminate
code without ifdef jungles certainly sounds attractive to me.

Also if we find broken toolchains I suppose it wouldn't be too
difficult to black list them.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
