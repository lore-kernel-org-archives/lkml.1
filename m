Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbYJWT20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbYJWT20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYJWT2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:28:18 -0400
Received: from colo.lackof.org ([198.49.126.79]:56498 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYJWT2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:28:17 -0400
Date: Thu, 23 Oct 2008 13:28:00 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: show dma_mask bits in /sys
Message-ID: <20081023192800.GB8060@colo.lackof.org>
References: <20081009211837.GC18444@colo.lackof.org> <48EE7745.2020603@kernel.org> <20081009213551.GC25780@parisc-linux.org> <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com> <20081009225533.GB1914@colo.lackof.org> <48EE8E55.4000009@kernel.org> <20081012071157.GA20056@colo.lackof.org> <48FFD726.2010600@kernel.org> <20081023064815.GE31186@colo.lackof.org> <86802c440810222351g18a34904ka1f3621df7f2614f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810222351g18a34904ka1f3621df7f2614f@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 11:51:36PM -0700, Yinghai Lu wrote:
> On Wed, Oct 22, 2008 at 11:48 PM, Grant Grundler
> <grundler@parisc-linux.org> wrote:
> > On Wed, Oct 22, 2008 at 06:45:10PM -0700, Yinghai Lu wrote:
> >> Grant prefer to add it /sys instead of showing in bootlog
> >>
> >> so could catch if the driver set the correct dma_mask.
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> >> ---
> >>  drivers/pci/pci-sysfs.c |   17 +++++++++++++++++
> >>  1 file changed, 17 insertions(+)
> >>
> >> Index: linux-2.6/drivers/pci/pci-sysfs.c
> >> ===================================================================
> >> --- linux-2.6.orig/drivers/pci/pci-sysfs.c
> >> +++ linux-2.6/drivers/pci/pci-sysfs.c
> >> @@ -169,6 +169,21 @@ numa_node_show(struct device *dev, struc
> >>  #endif
> >>
> >>  static ssize_t
> >> +dma_mask_bits_show(struct device *dev, struct device_attribute *attr, char *buf)
> >> +{
> >> +     struct pci_dev *pdev = to_pci_dev(dev);
> >> +
> >> +     return sprintf (buf, "%d\n", fls64(pdev->dma_mask));
> >
> > Is there any reason to use %d instead of "0x%x" ?
> > I'd much rather see this dumped in hex.
> 
> that is bits, so it will be 64, 41 instead of 0xfffff

Sorry - I missed the fls64(). Looks good to me.

We only need to know if willy agrees to how/when to
limit when this is available.

thanks,
grant
