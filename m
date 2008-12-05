Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYLEJp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYLEJp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 04:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYLEJpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 04:45:14 -0500
Received: from www.tglx.de ([62.245.132.106]:39777 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbYLEJpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 04:45:12 -0500
Date: Fri, 5 Dec 2008 10:44:48 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Hans J. Koch" <hjk@linutronix.de>, edward_estabrook@agilent.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       edward.estabrook@gmail.com, hugh <hugh@veritas.com>,
       linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
Message-ID: <20081205094447.GA3081@local>
References: <43FC624C55D8C746A914570B66D642610367F29B@cos-us-mb03.cos.agilent.com> <1228379942.5092.14.camel@twins> <20081204180809.GB3079@local> <1228461060.18899.8.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228461060.18899.8.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 08:10:59AM +0100, Peter Zijlstra wrote:
> > I don't like to have a separate device for DMA memory. It would completely
> > break the current concept of userspace drivers if you had to get normal
> > memory from one device and DMA memory from another. Note that one driver
> > can have both.
> 
> How would that break anything, the one driver can simply open both
> files.

I agree there's not much breakage, but it's a difference in handling things.
People who wrote libraries that generically find mappable memory of a UIO
device need to change their handling.

> 
> > But I agree that it's confusing if the physical address is stored somewhere
> > in the mapped memory. That should simply be omitted, we have that information
> > in sysfs anyway - like for any other memory mappings. But I guess we need
> > some kind of "type" or "flags" attribute for the mappings so that userspace
> > can find out if a mapping is DMA capable or not.
> 
> We have that, different file.
> 
> I'll NAK any attempt that rapes the mmap interface like proposed - that
> is just not an option.

Well, UIO already rapes the mmap interface by using the "offset" parameter to
pass in the number of the mapping.
But I'll NAK the current concept, too. It's a UIO kernel driver's task to tell
userspace which memory a device has to offer. The UIO core prevents userspace
as much as possible from mapping anything different. And it should stay that
way.

Thanks,
Hans

