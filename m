Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZI1Rwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZI1Rwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 13:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZI1Rwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 13:52:45 -0400
Received: from outbound-mail-317.bluehost.com ([67.222.54.10]:44390 "HELO
	outbound-mail-317.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752106AbZI1Rwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 13:52:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mZBLUi+PX6fPvVOw5Ne/Etgdht7eVr4AenM/X5sMR65MPrtZkXhX/Wr1DR0iPG+pWd2U0A31ECm83h6QXoMsnuqazqi6yhTi23JbJHCTXF7MMFVqSY2kBZzX1eSRcUrj;
Date: Mon, 28 Sep 2009 10:52:47 -0700
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
Message-ID: <20090928105247.3f643083@jbarnes-x200>
In-Reply-To: <4A4EE3E9.7090205@kernel.org>
References: <4A4EE3E9.7090205@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.240.212 authed with jbarnes@virtuousgeek.org}
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
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: David Miller <davem@davemloft.net>
> Acked-by: Greg KH <gregkh@suse.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tony Luck <tony.luck@intel.com>
> ---

Thanks Tejun, I'll pull these in later this week when I get back from
Portland.

Jesse
