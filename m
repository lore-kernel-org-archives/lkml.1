Return-Path: <linux-kernel-owner+w=401wt.eu-S1031473AbXD3JSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031473AbXD3JSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031478AbXD3JSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:18:20 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4486 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031467AbXD3JSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 05:18:18 -0400
Date: Mon, 30 Apr 2007 10:18:09 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>, Roland McGrath <roland@redhat.com>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: utrace comments
Message-ID: <20070430091808.GA11345@flint.arm.linux.org.uk>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20061127165138.GA2991@lst.de> <20070430040213.BF9901801A4@magilla.sf.frob.com> <20070430090840.GB31397@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430090840.GB31397@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:08:40AM +0100, Christoph Hellwig wrote:
> Btw, is there a fundamental reason why an architecture would not support
> single-stepping except for a transition period of porting, i.e. are there
> real hardware limitation in any of our ports?

Roland's idea of single-stepping is that it *must* be supported by
hardware for utrace to use it.  There are a number of architectures
which can only do single-stepping by modifying the text of the
program being single stepped.  ARM is one such example.

As such, even when utrace is complete, some architectures will never
support in-kernel single step with utrace.  I believe Roland's idea
is to have single step supported on these via some vapourware userspace
library.

My biggest worry is that the architectures which do not support hardware
single stepping are seen by many people as "minority architectures" which
"don't really matter" and as such making support for a feature such a
special case will probably result in the feature effectively being
unavailable on those architectures.

As such I have zero motivation to continue my forrey into utrace from
a couple of months ago.  I'd also like to see utrace become *optional*
for architectures to support, rather than as it currently stands as
a *mandatory* requirement when merged.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
