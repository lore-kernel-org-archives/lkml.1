Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbZJTI0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbZJTI0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 04:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbZJTIZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 04:25:59 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47667 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZJTIZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 04:25:58 -0400
Date: Tue, 20 Oct 2009 02:26:02 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/3] Expose MSI-X interrupts through a dynamically
	generated sysfs directory
Message-ID: <20091020082602.GA979@parisc-linux.org>
References: <20091020054740.GC29158@parisc-linux.org> <20091020055055.GF29158@parisc-linux.org> <2375c9f90910200114q641c4368s49695c36ca76f7c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2375c9f90910200114q641c4368s49695c36ca76f7c9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'll note that one of the complaints at the kernel summit has been
that people have lost the art of trimming mail they're replying to.
There's a proposal to filter mail like the one you sent as spam.

On Tue, Oct 20, 2009 at 04:14:44PM +0800, Am??rico Wang wrote:
> On Tue, Oct 20, 2009 at 1:50 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > +#define kobj_to_pci_dev(obj) to_pci_dev(container_of(obj, struct device, kobj))
> 
> You define this, but no one uses it?

Yeah, left over from an earlier version of the patch.  Thanks, I'll
remove it.

> > + ?? ?? ?? array = kmalloc((nr_irqs + 1) * sizeof(void *), GFP_KERNEL);
> > + ?? ?? ?? if (!array)
> > + ?? ?? ?? ?? ?? ?? ?? return -ENOMEM;
> > + ?? ?? ?? attr = kmalloc(nr_irqs * sizeof(*attr), GFP_KERNEL);
> > + ?? ?? ?? if (!attr)
> > + ?? ?? ?? ?? ?? ?? ?? return -ENOMEM;
> 
> Here leaks memory allocated above.

Oh, yeah, duh, thanks.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
