Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZBVWch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZBVWch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZBVWc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:32:29 -0500
Received: from imta-38.everyone.net ([216.200.145.38]:41828 "EHLO
	omta0111.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753224AbZBVWc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:32:29 -0500
X-Eon-Dm: dm0205
X-Eon-Sig: AQHOS7NJodJ7Sk7GeAIAAAAH,4b7f68dca2a7af1f4311cffe40495769
Date: Sun, 22 Feb 2009 17:32:26 -0500
From: "Kevin O'Connor" <kevin@koconnor.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stefan Reinauer <stepan@coresystems.de>,
       linux-kernel@vger.kernel.org, coreboot@coreboot.org,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>
Subject: Re: MPTable can not be high-memory on Linux
Message-ID: <20090222223226.GA3346@morn.localdomain>
References: <499DB40C.1060205@coresystems.de> <499DCE79.8020809@coresystems.de> <20090222152530.GA30576@morn.localdomain> <200902221806.55429.rjw@sisk.pl> <49A1C4AF.9000009@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A1C4AF.9000009@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 01:33:35PM -0800, Yinghai Lu wrote:
[...]
> >>>  BIOS-e820: 0000000000090000 - 0000000000100000 (reserved)
> >>>  BIOS-e820: 0000000000100000 - 000000003f7f0000 (usable)
> >>>  BIOS-e820: 000000003f7f0000 - 0000000040000000 (reserved)
[...]
> >>> found SMP MP-table at [c00f9fc0] 000f9fc0
[...]
> 
> that should work for a long time.
> 
> 0xf9fc0 < 1M is quite < max_low_pfn, so wonder why bootmem could panic.

On this machine the mptable "floating" structure is at 0xf9fc0.  It
points to the rest of the table which is in the 0x3f7f0000 area.

Note, that this is on a Coreboot+SeaBIOS machine - so we can change
the bios.  However, the mptable spec does allow for part of the table
to be high memory.

-Kevin
