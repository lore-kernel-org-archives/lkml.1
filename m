Return-Path: <linux-kernel-owner+w=401wt.eu-S1763124AbXGMHth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763124AbXGMHth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbXGMHta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:49:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:39056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817AbXGMHt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:49:29 -0400
Date: Fri, 13 Jul 2007 09:49:27 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070713074927.GA15920@suse.de>
Mail-Followup-To: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <20070711073216.GA11757@localdomain> <20070711224304oomichi@mail.jp.nec.com> <20070713035825.GB4975@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713035825.GB4975@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-07-13 05:58]:
> Given the fact that more and more architectures are supporting multiple
> page sizes. Now one can also export relevant kernel CONFIG variables
> through this ELF note. makedumpfile's job will be simpler. You don't have
> to make any guesses about various config options like page size.
> 
> This approach will make second kernel truly independent of first kernel.
> Currently, if first kernel changes one shall have to regenerate the 
> initrd for second kenrel. Hence in a sense, second kernel is dependent on
> first kernel. Now kernel will export all the required data for dump filtering
> so one does not have to rebuild the seond kernel initrd even if first kernel
> changes.

That's only the RedHat mechanism. You can copy all CONFIGFILEs to the
initrd, and then pick the right one via the version. Then, you only
have to regenerate the initrd when you *install* a new first kernel,
not when you boot a new first kernel. And that's also why I wanted the
kernel version to be accessible in the crashkernel ...

> I think overall the approach of exporting right info from kernel should 
> help. Only thing is that we shall have to manage the ELF note better in
> terms of making it more generic.

Basically I like the idea of exporting the information from the kernel
without generating the CONFIGFILE. The only big problem I see that the
makedumpfile release cycles would depend on the kernel release cycles,
and, you cannot add new features to makedumpfile for old kernels since
you always rely on the information which is exported.


Thanks,
   Bernhard
