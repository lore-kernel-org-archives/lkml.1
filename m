Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZJFQxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZJFQxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbZJFQxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:53:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:33107 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435AbZJFQxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:53:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,513,1249282800"; 
   d="scan'208";a="500370552"
Date: Tue, 6 Oct 2009 09:53:06 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>, Robert Hancock <hancockr@shaw.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Axel Birndt <towerlexa@gmx.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/3 pci#linux-next] pci: determine CLS more
 intelligently
Message-ID: <20091006095306.3e28a1eb@jbarnes-g45>
In-Reply-To: <4AB88BE2.2030501@kernel.org>
References: <4A4EE3E9.7090205@kernel.org>
	<20090917103131.55eca691@jbarnes-g45>
	<4AB88BE2.2030501@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 17:33:38 +0900
Tejun Heo <tj@kernel.org> wrote:

> Till now, CLS has been determined either by arch code or as
> L1_CACHE_BYTES.  Only x86 and ia64 set CLS explicitly and x86 doesn't
> always get it right.  On most configurations, the chance is that
> firmware configures the correct value during boot.
> 
> This patch makes pci_init() determine CLS by looking at what firmware
> has configured.  It scans all devices and if all non-zero values
> agree, the value is used.  If none is configured or there is a
> disagreement, pci_dfl_cache_line_size is used.  arch can set the dfl
> value (via PCI_CACHE_LINE_BYTES or pci_dfl_cache_line_size) or
> override the actual one.
> 
> ia64, x86 and sparc64 updated to set the default cls instead of the
> actual one.
> 
> While at it, declare pci_cache_line_size and pci_dfl_cache_line_size
> in pci.h and drop private declarations from arch code.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: David Miller <davem@davemloft.net>
> Acked-by: Greg KH <gregkh@suse.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tony Luck <tony.luck@intel.com>

Applied this series to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
