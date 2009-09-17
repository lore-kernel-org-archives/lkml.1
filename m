Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbZIQRbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbZIQRbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbZIQRbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:31:37 -0400
Received: from outbound-mail-23.bluehost.com ([69.89.21.18]:36716 "HELO
	outbound-mail-23.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758047AbZIQRbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:31:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=oDz4njURsD1om6VOLaKqGDwC38Gud7e1eGgcJ7K0EzAhTZAJ3FGfTwvpmwxLGurfedE+AzI+kmM6pd4mUebLLOTqZkqMoWLSFG2yJ8Z88w36gJN8sllEEHosSZxn3sby;
Date: Thu, 17 Sep 2009 10:31:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
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
Subject: Re: [PATCH 1/3] pci: determine CLS more intelligently
Message-ID: <20090917103131.55eca691@jbarnes-g45>
In-Reply-To: <4A4EE3E9.7090205@kernel.org>
References: <4A4EE3E9.7090205@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Jul 2009 14:08:57 +0900
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

This sounds like a good improvement (though I share Ingo's concerns
about platform breakage here).  Can you respin the patchset against my
linux-next current tree?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
