Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZDRUJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZDRUJF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbZDRUIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:08:53 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:41791 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbZDRUIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:08:53 -0400
Date: Sun, 19 Apr 2009 00:09:09 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] pci: don't assume pref memio are 64bit -v2
Message-ID: <20090418200909.GA23229@jurassic.park.msu.ru>
References: <49E992C2.4010707@kernel.org> <49E99303.50004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E99303.50004@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 01:44:51AM -0700, Yinghai Lu wrote:
> and BIOS set
> [    0.240007] pci 0000:00:01.0: bridge 64bit mmio pref: [0xbdf00000-0xddefffff]

An obvious BIOS bug, the bridge base overlaps the physical low RAM
(0x00000000-0xc0000000). Technically speaking, this nonsense *happens*
to work on Intel hardware, so it seems to be quite common bug nowadays -
BIOS writers get lost in ACPI and other "useful" stuff contradicting
the PCI specs.

...

> +	/* don't allocate too high if the pref mem doesn't support 64bit*/
> +	if ((res->flags & (IORESOURCE_PREFETCH | PCI_PREF_RANGE_TYPE_64)) ==
> +	    IORESOURCE_PREFETCH)
> +		max = 0xffffffff;

This effectively destroys non-x86 64-bit arches. You've been told about
that before, so I'm really surprised to see this "patch" once again.

Categorically NACKed.

P.S. I recall that I had a patch that addressed the issue, and Ingo
made some reasonable comments about it. Will post it tomorrow.

Ivan.
