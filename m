Return-Path: <linux-kernel-owner+w=401wt.eu-S1762351AbZD3MnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762351AbZD3MnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 08:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZD3MnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 08:43:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46465 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbZD3MnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 08:43:07 -0400
Date: Thu, 30 Apr 2009 14:47:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
Message-ID: <20090430124716.GW23223@one.firstfloor.org>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <87iqknp8a0.fsf@basil.nowhere.org> <20090430115741.GA23634@aftab>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430115741.GA23634@aftab>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ok, how about we remove tha MSR/PCI cfg space reading bits and leave
> that task solely to the mce core. Then, iff you have edac turned on in

That's the minimum fix, but even then the patchkit does a lot of 
things, not necessarily all needs to be together.

> Kconfig, mce code delivers needed error info to edac which, in turn,
> goes and decodes the error/does the mapping to DIMM blocks/supplies DRAM
> error injection facility for testing purposes and similar things. That
> way you have both and they don't overlap in functionality.

You can do that, but it's redundant because mcelog can do this
this already. I had some conversations with existing EDAC users
recently and they seem to only care about the resulting output,
so just querying from mcelog is fine.
The only issue is that mcelog needs to get the DIMM data. In many
cases it can do so from SMBIOS output, if not a suitable interface
would need to be provided by the kernel.

> By the way, I think there's a similar attempt/proposal of letting mce
> and edac talk to each other from Red Hat so I think this could be a

There was a fairly dubious patch floating around I think, but it
had a couple of problems.

> > -Andi (who thinks all of this decoding should be in user space anyways)
> 
> Think of a big data center with a thousands of 2,4,8 socket blades
> and the admin collecting mce output and running around decoding the

Nobody said anything about admins decoding on their workstation.

Corrected events (which are the 90+% case) get decoded in user space on the 
same system.  Uncorrected events get decoded after the reboot. Both happens 
automatically and transparently.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
