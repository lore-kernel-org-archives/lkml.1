Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbZCZWvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbZCZWvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZCZWux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:50:53 -0400
Received: from outbound-mail-23.bluehost.com ([69.89.21.18]:38876 "HELO
	outbound-mail-23.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752260AbZCZWuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:50:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qjHIHV05n49P+kGrACZ7qYu2GP4c4shJiFms4A6cUh+AxmFCYMN64aojkVDqslTGR1n0ixPLWpE69GXmAL/u/9PI0guIQjEoTELRew1obWj8wNAdTcT0RvbwOcqOVsLC;
Date: Thu, 26 Mar 2009 15:50:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yu Zhao <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 1/8] PCI: initialize and release SR-IOV capability
Message-ID: <20090326155048.4a8f9d36@hobbes>
In-Reply-To: <20090321140511.GA24964@yzhao-otc.sh.intel.com>
References: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
	<1237519518-24048-2-git-send-email-yu.zhao@intel.com>
	<20090320105409.5ed80885@hobbes.lan>
	<20090321140511.GA24964@yzhao-otc.sh.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009 22:05:11 +0800
Yu Zhao <yu.zhao@intel.com> wrote:

> On Sat, Mar 21, 2009 at 01:54:09AM +0800, Jesse Barnes wrote:
> > On Fri, 20 Mar 2009 11:25:11 +0800
> > Yu Zhao <yu.zhao@intel.com> wrote:
> > 
> > > If a device has the SR-IOV capability, initialize it (set the ARI
> > > Capable Hierarchy in the lowest numbered PF if necessary;
> > > calculate the System Page Size for the VF MMIO, probe the VF
> > > Offset, Stride and BARs). A lock for the VF bus allocation is
> > > also initialized if a PF is the lowest numbered PF.
> > > 
> > > Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> > > Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> > 
> > I applied this series to my linux-next branch, but there were a few
> > conflicts here and there, so please check it out.  Looks like from
> > start to finish this took about 6 months to get banged into shape,
> > thanks for staying on it, Yu!
> 
> Yes, I checked them and found there is conflict between the SR-IOV
> changes and Yinghai's 'PCI/x86: detect host bridge config space size
> w/o using quirks'. Following is the fix, thanks!
> 
> 
> New pci_cfg_space_size() needs invalid pdev->class, put it in the
> right place in the pci_setup_device().
> 
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>

Applied, thanks Yu.

-- 
Jesse Barnes, Intel Open Source Technology Center
