Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbXGCWBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbXGCWBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbXGCWBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:01:04 -0400
Received: from canuck.infradead.org ([209.217.80.40]:33222 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbXGCWBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:01:02 -0400
Subject: Re: [PATCH] Re: Sparc32: random invalid instruction occourances on
	sparc32 (sun4c)
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mark@mtfhpc.demon.co.uk, linux-mm@kvack.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       clameter@engr.sgi.com, wli@holomorphy.com
In-Reply-To: <20070703.144112.24611353.davem@davemloft.net>
References: <Pine.LNX.4.61.0707031817050.29930@mtfhpc.demon.co.uk>
	 <Pine.LNX.4.61.0707031910280.29930@mtfhpc.demon.co.uk>
	 <1183490778.29081.35.camel@shinybook.infradead.org>
	 <20070703.144112.24611353.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 18:01:36 -0400
Message-Id: <1183500096.29081.51.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 14:41 -0700, David Miller wrote:
> Please don't use get_unaligned() or whatever to fix this, it's
> going to generate the byte-at-a-time accesses on sparc64
> which doesn't need it since the redzone will be aligned. 

Yes, get_unaligned() would suck. But 'u64 __aligned__((BYTES_PER_WORD))'
as I suggested should result in a single 64-bit load on 64-bit
architectures, and two 32-bit loads on 32-bit architectures.

But I think the patch I just sent is a better option than that anyway.

-- 
dwmw2

