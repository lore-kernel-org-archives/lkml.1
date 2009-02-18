Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZBRT5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZBRT5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZBRT4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:56:54 -0500
Received: from outbound-mail-30.bluehost.com ([69.89.17.212]:55587 "HELO
	outbound-mail-30.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752446AbZBRT4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:56:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=PuUZNwuYD0/PTNrElm6aa4MzwPMmw0S0/ZJwun6ptrBvIezj3YCzeF13mL5JX8wPRx18te24tjsDw46yr3BbRzW0sDVfTJhL8peLa88O2/wm6fBpyjjL16vONdN+t+mt;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH] alpha: pci sysfs resources
Date: Wed, 18 Feb 2009 11:56:50 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>,
       Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
References: <20090217104653.GA25856@jurassic.park.msu.ru>
In-Reply-To: <20090217104653.GA25856@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181156.50547.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 17, 2009 2:46 am Ivan Kokshaysky wrote:
> This closes http://bugzilla.kernel.org/show_bug.cgi?id=10893
> which is a showstopper for X development on alpha.
>
> The generic HAVE_PCI_MMAP code (drivers/pci-sysfs.c) is not
> very useful since we have to deal with three different types
> of MMIO address spaces: sparse and dense mappings for old
> ev4/ev5 machines and "normal" 1:1 MMIO space (bwx) for ev56 and
> later.
> Also "write combine" mappings are meaningless on alpha - roughly
> speaking, alpha does write combining, IO reordering and other
> optimizations by default, unless user splits IO accesses
> with memory barriers.
>
> I think the cleanest way to deal with resource files on alpha
> is to convert the default no-op pci_create_resource_files() and
> pci_remove_resource_files() for !HAVE_PCI_MMAP case into __weak
> functions and override them with alpha specific ones.
>
> Another alpha hook is needed for "legacy_" resource files
> to handle sparse addressing (pci_adjust_legacy_attr).
>
> With the "standard" resourceN files on ev56/ev6 libpciaccess
> works "out of the box". Handling of resourceN_sparse/resourceN_dense
> files on older machines obviously requires some userland work.
>
> Sparse/dense stuff has been tested on sx164 (pca56/pyxis, normally
> uses bwx IO) with the kernel hacked into "cia compatible" mode.

Excellent, thanks Ivan.  I've applied this one to my linux-next branch.  
Should make userspace stuff on the ev56/6 machines that much easier.

-- 
Jesse Barnes, Intel Open Source Technology Center
