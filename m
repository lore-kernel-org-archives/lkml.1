Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbXKTCTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbXKTCTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759779AbXKTCRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:17:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53774
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760490AbXKTCRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:17:21 -0500
Date: Mon, 19 Nov 2007 18:17:20 -0800 (PST)
Message-Id: <20071119.181720.03409715.davem@davemloft.net>
To: hpa@zytor.com
Cc: clameter@sgi.com, ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [rfc 37/45] x86_64: Support for fast per cpu operations
From: David Miller <davem@davemloft.net>
In-Reply-To: <47423FB7.20800@zytor.com>
References: <20071120011132.143632442@sgi.com>
	<20071120011340.569486037@sgi.com>
	<47423FB7.20800@zytor.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 19 Nov 2007 18:00:23 -0800

> Christoph Lameter wrote:
> > Support fast cpu ops in x86_64 by providing a series of functions that
> > generate the proper instructions. Define CONFIG_FAST_CPU_OPS so that core code
> > can exploit the availability of fast per cpu operations.
> > 
> > Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> There was, at some point, discussion about using the gcc TLS mechanism, 
> which should permit even better code to be generated.  Unfortunately, it 
> would require gcc to be able to reference %gs instead of %fs (and vice 
> versa for i386), which I don't think is available in anything except 
> maybe the most cutting-edge version of gcc.

You can't use __thread because GCC will cache __thread computed
addresses across context switches and cpu changes.

It's been tried before on powerpc, it doesn't work.
