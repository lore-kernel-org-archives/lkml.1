Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbXBJJkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbXBJJkI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 04:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbXBJJkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 04:40:08 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2264 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbXBJJkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 04:40:06 -0500
Date: Sat, 10 Feb 2007 09:39:54 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Imre Deak <imre.deak@solidboot.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DEV: zero: use correct pgprot for zeromapping
Message-ID: <20070210093954.GA29145@flint.arm.linux.org.uk>
Mail-Followup-To: Imre Deak <imre.deak@solidboot.com>,
	linux-kernel@vger.kernel.org
References: <20070210091521.GA7350@bitbox.mine.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210091521.GA7350@bitbox.mine.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 11:15:21AM +0200, Imre Deak wrote:
> Instead of PAGE_COPY use the pgprot bits established already at
> original mapping time of the VMA. This will also include any
> architecture specific bits setup through protection_map.
> zeromap_page_range will take care of COW'ing the passed pgprot.

NAK.  What if PAGE_COPY is used elsewhere and ends up accidentally
allowing write access?

I think the right solution is to make PAGE_COPY a variable in the same
way that PAGE_KERNEL is, and adjust it as appropriate.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
