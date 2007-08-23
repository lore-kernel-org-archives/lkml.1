Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbXHWIeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbXHWIeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 04:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbXHWIeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 04:34:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50093 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbXHWIeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 04:34:01 -0400
Date: Thu, 23 Aug 2007 01:21:14 -0700
From: Greg KH <greg@kroah.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       michal.k.k.piotrowski@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH] make kobject dynamic allocation check use
	kallsyms_lookup()
Message-ID: <20070823082114.GA7945@kroah.com>
References: <20070822220341.7926F241@kernel> <alpine.LFD.0.999.0708231037040.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708231037040.2049@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 10:48:23AM +0530, Satyam Sharma wrote:
> Hi Dave,
> 
> 
> On Wed, 22 Aug 2007, Dave Hansen wrote:
> > 
> > One of the top ten sysfs problems is that users use statically
> > allocated kobjects.  This patch reminds them that this is a
> > naughty thing.
> 
> Hmm, I might've missed previous discussion regarding this, but I'm
> curious to know why using statically allocated kobjects is "naughty".
> The code / warnings / printk messages below indicate this is only a
> "silly/janitorial" issue?
> 
> The reason I ask is that if it is serious, there is no reason why this
> check cannot be done at build-time itself, instead of this runtime
> kludge in the kernel -- catching potential bugs at build-time is always
> desirable. Modpost or some such tool can be taught to detect kobjects
> allocated statically in vmlinux/modules -- or there can be other build-
> time solutions, possibly. Have you considered such an approach?

If you have a patch to do so, I would appreciate it.

But the main reason I don't push such a change into Linus's tree is that
there are still a lot of statically allocated kobjects today, like all
driver definitions :(

Converting them to be dynamic is on my list of things to do, it's just a
ways down there.

thanks,

greg k-h
