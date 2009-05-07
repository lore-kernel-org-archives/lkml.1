Return-Path: <linux-kernel-owner+w=401wt.eu-S1761961AbZEGJdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761961AbZEGJdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762204AbZEGJ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:27:34 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54193 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762193AbZEGJ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:27:32 -0400
Date: Thu, 7 May 2009 03:27:31 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Sheng Yang <sheng@linux.intel.com>
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Message-ID: <20090507092731.GH8112@parisc-linux.org>
References: <20090507082841.GA31751@redhat.com> <200905071651.24970.sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905071651.24970.sheng@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 04:51:24PM +0800, Sheng Yang wrote:
> On Thursday 07 May 2009 16:28:41 Michael S. Tsirkin wrote:
> > pci_enable_msix currently returns -EINVAL if you ask
> > for more vectors than supported by the device, which would
> > typically cause fallback to regular interrupts.
> >
> > It's better to return the table size, making the driver retry
> > MSI-X with less vectors.
> 
> Hi Michael
> 
> I think driver should read from capability list to know how many vector 
> supported by this device before enable MSI-X for device, as 
> pci_msix_table_size() did...

I think Michael's patch makes sense.  It reduces the amount of work the
driver has to do without requiring any additional work in the core.  I
don't see the disadvantage to it.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
