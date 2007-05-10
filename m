Return-Path: <linux-kernel-owner+w=401wt.eu-S1761024AbXEJOTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024AbXEJOTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbXEJOTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:19:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45090 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbXEJOTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:19:46 -0400
Date: Thu, 10 May 2007 16:19:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pete Zaitcev <zaitcev@redhat.com>,
       ak@suse.de, linux-kernel@vger.kernel.org,
       Benny Halevy <bhalevy@panasas.com>, akpm@linux-foundation.org
Subject: Re: Andi, you broke my laptop :-)
Message-ID: <20070510141942.GM14898@one.firstfloor.org>
References: <20070509125616.cde56b8e.zaitcev@redhat.com> <20070510130144.GI14898@one.firstfloor.org> <20070510133555.GA5705@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510133555.GA5705@amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 03:35:56PM +0200, Joerg Roedel wrote:
> On Thu, May 10, 2007 at 03:01:44PM +0200, Andi Kleen wrote:
> > On Wed, May 09, 2007 at 12:56:16PM -0700, Pete Zaitcev wrote:
> > > Hi, Andi:
> > > 
> > > The attached patch (actually, git show output) makes my Dell 1501 to hang
> > > on boot. Sorry, I have no clue why... The culprit is found with git bisect.
> > > But yes, it's an AMD MK-36. I use an x86_64 kernel. It is 100% reproducible.
> > 
> > MK-36? Does it have SVM? 
> > 
> > Anyways we previously had issues with this being miscompiled, but 
> > I thought the latest patch should have been ok. What compiler do you use?
> > 
> > Can you send me a disassembly listing of arch/x86_64/kernel/time.o?
> 
> I debugged this problem a bit and my compiler[1]interprets the =A
> constraint as %rax instead of %edx:%eax on x86_64 which causes the
> problem. The appended patch provides a workaround for this and fixed the
> hang on my machine.

Hmm yes now I can reproduce it too. I didn't see any hangs so i suppose 
my (and that of most -mm tester's) compiled binary always happened to have a 
suitable value in edx

Thanks for the patch.

-Andi
