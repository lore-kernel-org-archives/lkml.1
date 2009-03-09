Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZCISLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZCISLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZCISLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:11:22 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34382 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZCISLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:11:21 -0400
Date: Mon, 9 Mar 2009 12:11:19 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Yu Zhao <yu.zhao@intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 3/7] PCI: reserve bus range for SR-IOV device
Message-ID: <20090309181118.GV25995@parisc-linux.org>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-4-git-send-email-yu.zhao@intel.com> <20090306202024.GF25995@parisc-linux.org> <20090309081337.GB4638@yzhao-otc.sh.intel.com> <49B55B3E.3090502@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B55B3E.3090502@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 11:09:02AM -0700, Randy Dunlap wrote:
> >> static inline __pure u16 virtfn_bdf(struct pci_dev *dev, int id)
> >> {
> >> 	return (dev->bus->number << 8) + dev->devfn + dev->sriov->offset +
> >> 		dev->sriov->stride * id;
> >> }
> >>
> >> #define VIRT_BUS(dev, id)	(virtfn_bdf(dev, id) >> 8)
> >> #define VIRT_DEVFN(dev, id)	(virtfn_bdf(dev, id) & 0xff)
> >>
> >> We rely on GCC to do CSE and not actually invoke virtfn_bdf more than
> >> once.
> > 
> > Yes, that's a good idea. Will replace that function with macros.
> 
> That's the opposite of most changes lately.  I.e., functions (with
> typechecking) are preferred.

There's every bit as much typechecking with the approach I outlined as
there was with the original.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
