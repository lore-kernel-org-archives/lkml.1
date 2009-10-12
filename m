Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbZJLVc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbZJLVc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758484AbZJLVc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:32:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:60766 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758478AbZJLVcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:32:25 -0400
Date: Mon, 12 Oct 2009 14:27:22 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tom Hanrahan <hanrahat@microsoft.com>,
       Hashir Abdi <habdi@microsoft.com>
Subject: Re: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Message-ID: <20091012212722.GA22118@suse.de>
References: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012153013.GA2062@suse.de>
 <1FB5E1D5CA062146B38059374562DF7212DF10DD@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012172953.GA10557@suse.de>
 <8AFC7968D54FB448A30D8F38F259C5620E7B1C22@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20091012202214.GA9631@suse.de>
 <1FB5E1D5CA062146B38059374562DF7212DF127D@TK5EX14MBXC130.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7212DF127D@TK5EX14MBXC130.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 08:44:06PM +0000, Haiyang Zhang wrote:
> > Can you figure out why?  What is the output of gcc for both ways?
> There are no build errors in either ways, I think it may be a bug in
> gcc handing __attribute__((packed)).

Of course there is not a build error.  I mean what is the difference in
the assembly produced?  Why is the __attribute__ version not the same

> > Can you show what is fixed by this change?
> Before the fix:
> The command "insmod hv_vmbus.ko" hangs. 
> Root cause: The message data sent from Linux guest to HyperV host were
> not correctly packed and not recognized by HyperV host. So, the host
> doesn't acknowledge that the vmbus channel is set up. Then, the guest
> keeps on waiting for the event and hangs the insmod command.
> 
> After the fix:
> The command "insmod hv_vmbus.ko" completes successfully with vmbus
> module loaded.

That's not showing me why the above fixed the problem.

> > Also note that #pragma packed is not supported by older versions of gcc,
> > so I don't think that it would work at all on some compiler versions
> > that are still legal to use for the kernel.  But I'm not quite sure when
> > it was added, so I might be wrong.
> This pragma was used in older distro, such as SLES10 (kernel 2.6.16)
> without any problem.

What compiler version was that?  Have you tried it on the lowest
required version of gcc?

> >From your newer email:
> > I also note that you are packing more structures here with this patch than the code before the patch had.  Could that be the 
> > issue here?  The additional structures are ones that should be packed instead?
> No, the extra packed structures are not required for this bug fix. Just to make sure any future struct related to message is packed, so I put the pack() around the entire file.

Please wrap your email lines properly...

Your patch changes structures that it is needed for.

We need to find the root cause of _why_ your patch fixes the problem here,
that is what I am trying to get you to do.

thanks,

greg k-h
