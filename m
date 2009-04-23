Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbZDWM6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbZDWM6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbZDWM6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:58:40 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:58460 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZDWM6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:58:40 -0400
Date: Thu, 23 Apr 2009 16:58:49 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [RFC PATCH 1/2] pci: don't assume pref memio are 64bit -v3
Message-ID: <20090423125848.GB11519@jurassic.park.msu.ru>
References: <20090419090208.GA30211@elte.hu> <20090419090615.GA30631@elte.hu> <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org> <20090421105629.GB17904@jurassic.park.msu.ru> <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes> <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes> <86802c440904221903p5667bbf9y642d671942555958@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440904221903p5667bbf9y642d671942555958@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 07:03:33PM -0700, Yinghai Lu wrote:
> to check the BAR support 64bit or not should be read from
> pci_read_bases and pci_bridge_read_bases...

pci_read_bases: take a closer look at decode_bar() function and
PCI_BASE_ADDRESS_MEM_TYPE_64 flag.

pci_bridge_read_bases: we cannot rely on the bits 0-3 of 
PCI_PREF_MEMORY_BASE providing correct information anyway.
More reliable check for 64-bitness would be a test for
PCI_PREF_BASE_UPPER32 register being r/w, which I think
belongs in pci_bridge_check_ranges().

Ivan.
