Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYKGERv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYKGERv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 23:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYKGERk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 23:17:40 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:43080 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYKGERj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 23:17:39 -0500
Date: Thu, 6 Nov 2008 21:17:22 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Greg KH <greg@kroah.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 16/16 v6] PCI: document the new PCI boot parameters
Message-ID: <20081107041721.GB15439@parisc-linux.org>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084531.GP3773@yzhao12-linux.sh.intel.com> <20081106043235.GA30292@kroah.com> <4913AA03.5060807@intel.com> <20081107025032.GA12824@kroah.com> <4913B8A5.5010806@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4913B8A5.5010806@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 11:40:21AM +0800, Zhao, Yu wrote:
> Greg KH wrote:
> >We've thought about this in the past, and even Microsoft said it was
> >going to happen for Vista, but they realized in the end, like we did a
> >few years previously, that it would require full support of all PCI
> >drivers as well (if you rebalance stuff that is already bound to a
> >driver.)  So they dropped it.
> >
> >When would you want to do this kind of rebalancing?  Before any PCI
> >driver is bound to any devices?  Or afterwards?
> 
> I guess if we want the rebalance dynamic, then we should have it full -- 
> the rebalance would be functional even after the driver is loaded.
> 
> But in most cases, there will be problem when we unload driver from a 
> hard disk controller, etc. We can mount root on a ramdisk and do the 
> rebalance there, but it's complicated for a real user.
> 
> So looks like doing rebalancing before any driver is bound to any device 
> is also a nice idea, if user can get a shell to do rebalance before 
> built-in PCI driver grabs device.

Can we use the suspend/resume code to do this?  Some drivers (sym2 for
one) would definitely need to rerun some of their init code to cope with
a BAR address changing.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
