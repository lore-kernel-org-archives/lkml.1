Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZJ0R5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZJ0R5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbZJ0R5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:57:49 -0400
Received: from kroah.org ([198.145.64.141]:46851 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504AbZJ0R5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:57:47 -0400
Date: Tue, 27 Oct 2009 10:32:47 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Am??rico Wang <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/3] Expose MSI-X interrupts through a dynamically
 generated sysfs directory
Message-ID: <20091027173247.GA23368@kroah.com>
References: <20091020054740.GC29158@parisc-linux.org>
 <20091020055055.GF29158@parisc-linux.org>
 <2375c9f90910200114q641c4368s49695c36ca76f7c9@mail.gmail.com>
 <20091020082602.GA979@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020082602.GA979@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 02:26:02AM -0600, Matthew Wilcox wrote:
> On Tue, Oct 20, 2009 at 04:14:44PM +0800, Am??rico Wang wrote:
> > On Tue, Oct 20, 2009 at 1:50 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > > +#define kobj_to_pci_dev(obj) to_pci_dev(container_of(obj, struct device, kobj))
> > 
> > You define this, but no one uses it?
> 
> Yeah, left over from an earlier version of the patch.  Thanks, I'll
> remove it.
> 
> > > + ?? ?? ?? array = kmalloc((nr_irqs + 1) * sizeof(void *), GFP_KERNEL);
> > > + ?? ?? ?? if (!array)
> > > + ?? ?? ?? ?? ?? ?? ?? return -ENOMEM;
> > > + ?? ?? ?? attr = kmalloc(nr_irqs * sizeof(*attr), GFP_KERNEL);
> > > + ?? ?? ?? if (!attr)
> > > + ?? ?? ?? ?? ?? ?? ?? return -ENOMEM;
> > 
> > Here leaks memory allocated above.
> 
> Oh, yeah, duh, thanks.

Care to resend this series with these fixes?

thanks,

greg k-h
