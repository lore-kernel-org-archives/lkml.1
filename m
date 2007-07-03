Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbXGCTZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbXGCTZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbXGCTZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:25:46 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53262 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbXGCTZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:25:46 -0400
Subject: Re: [PATCH] Re: Sparc32: random invalid instruction occourances on
	sparc32 (sun4c)
From: David Woodhouse <dwmw2@infradead.org>
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Christoph Lameter <clameter@engr.sgi.com>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <Pine.LNX.4.61.0707031910280.29930@mtfhpc.demon.co.uk>
References: <468A7D14.1050505@googlemail.com>
	 <Pine.LNX.4.61.0707031817050.29930@mtfhpc.demon.co.uk>
	 <Pine.LNX.4.61.0707031910280.29930@mtfhpc.demon.co.uk>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 15:26:18 -0400
Message-Id: <1183490778.29081.35.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 19:57 +0100, Mark Fortescue wrote:
> > Commit b46b8f19c9cd435ecac4d9d12b39d78c137ecd66 partially fixed alignment 
> > issues but does not ensure that all 64bit alignment requirements of sparc32 
> > are met. Tests have shown that the redzone2 word can become misallignd.

Oops, sorry about that. I'm not sure about your patch though -- I think
I'd prefer to keep the redzone misaligned (and hence _right_ next to the
real data), and just deal with it.

typedef unsigned long long __aligned__((BYTES_PER_WORD)) redzone_t;

-- 
dwmw2

