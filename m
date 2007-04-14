Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbXDNWFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbXDNWFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 18:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXDNWFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 18:05:08 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbXDNWFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 18:05:06 -0400
Message-ID: <46214FD3.3080400@zytor.com>
Date: Sat, 14 Apr 2007 15:04:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org> <20070414204924.125386443@goop.org>
In-Reply-To: <20070414204924.125386443@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> -
> +LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
> +

Again, for debugging... it would be interesting to replace this with:

LOW_PAGES = (0x100000000-__PAGE_OFFSET) >> PAGE_SHIFT_asm

... to smoke out further problems; this will take the strict definition 
of "lowmem" (modulo the pci region, which someone unwisely made 
dynamically adjustable... which would have been fine if initramfs could 
live in highmem, which it can't yet.)

	-hpa
