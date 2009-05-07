Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbZEGJj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbZEGJj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbZEGJjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:39:48 -0400
Received: from mga12.intel.com ([143.182.124.36]:23905 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753005AbZEGJjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:39:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,308,1239001200"; 
   d="scan'208";a="140155339"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Date: Thu, 7 May 2009 17:40:15 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       virtualization@lists.linux-foundation.org
References: <20090507082841.GA31751@redhat.com> <200905071651.24970.sheng@linux.intel.com> <20090507092731.GH8112@parisc-linux.org>
In-Reply-To: <20090507092731.GH8112@parisc-linux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905071740.16190.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009 17:27:31 Matthew Wilcox wrote:
> On Thu, May 07, 2009 at 04:51:24PM +0800, Sheng Yang wrote:
> > On Thursday 07 May 2009 16:28:41 Michael S. Tsirkin wrote:
> > > pci_enable_msix currently returns -EINVAL if you ask
> > > for more vectors than supported by the device, which would
> > > typically cause fallback to regular interrupts.
> > >
> > > It's better to return the table size, making the driver retry
> > > MSI-X with less vectors.
> >
> > Hi Michael
> >
> > I think driver should read from capability list to know how many vector
> > supported by this device before enable MSI-X for device, as
> > pci_msix_table_size() did...
>
> I think Michael's patch makes sense.  It reduces the amount of work the
> driver has to do without requiring any additional work in the core.  I
> don't see the disadvantage to it.
>
> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

It's indeed weird. Why the semantic of pci_enable_msix can be changed to 
"enable msix, or tell me how many vector do you have"? You can simply call 
pci_msix_table_size() to get what you want, also without any more work, no? I 
can't understand...

-- 
regards
Yang, Sheng

