Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbYFMA5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbYFMA5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 20:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbYFMA5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 20:57:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:3120 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbYFMA5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 20:57:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,634,1204531200"; 
   d="scan'208";a="339770597"
Subject: Re: Confusions with reserve_early, reserve_bootmem, e820, efi, ...
	on x86_64
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Bernhard Walle <bwalle@suse.de>, Johannes Weiner <hannes@saeurebad.de>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>
In-Reply-To: <20080612050609.88a8cf7f.pj@sgi.com>
References: <20080612050609.88a8cf7f.pj@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jun 2008 08:59:39 +0800
Message-Id: <1213318779.20431.3.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 13 Jun 2008 00:56:59.0335 (UTC) FILETIME=[624ADD70:01C8CCF0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 05:06 -0500, Paul Jackson wrote:
> Bernhard, Johannes, Huang, and Yinghai:
> 
> I am running into some complications with reserve_bootmem vs
> reserve_early, and a reserve_early of "EFI memmap" in the
> efi_reserve_early() routine conflicting with reserve_early of
> "BIOS reserved" in reserve_ebda_region().
> 
> This is on x86_64 arch, using Ingo's x86-latest, with possibly
> still buggy EFI firmware in a lab system I'm helping to develop.
> 
> I have three concerns:
> 
>  1) The find_overlapped_early() check called from reserve_early is
>     failing on my lab system , causing panic, when it tries to
>     register "EFI memmap" at addresses <0xe0660, 0xe0778> that
>     overlaps with the "BIOS reserved" early reserve at addresses
>     <0x9f000, 0x100000>

I think this can be resolved by avoiding memory area <0x9f000, 0x100000>
when allocating memory for EFI memory map in boot-loader.

Best Regards,
Huang Ying


