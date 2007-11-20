Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbXKTD13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbXKTD13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 22:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbXKTD1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 22:27:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:37121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbXKTD1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 22:27:20 -0500
From: Andi Kleen <ak@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc 37/45] x86_64: Support for fast per cpu operations
Date: Tue, 20 Nov 2007 04:23:07 +0100
User-Agent: KMail/1.9.1
Cc: David Miller <davem@davemloft.net>, clameter@sgi.com,
       akpm@linux-foundation.org, travis@sgi.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
References: <20071120011132.143632442@sgi.com> <20071119.181720.03409715.davem@davemloft.net> <47424435.8050704@zytor.com>
In-Reply-To: <47424435.8050704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711200423.08195.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 03:19, H. Peter Anvin wrote:
> David Miller wrote:
> >> There was, at some point, discussion about using the gcc TLS mechanism,
> >> which should permit even better code to be generated.  Unfortunately, it
> >> would require gcc to be able to reference %gs instead of %fs (and vice
> >> versa for i386), which I don't think is available in anything except
> >> maybe the most cutting-edge version of gcc.
> >
> > You can't use __thread because GCC will cache __thread computed
> > addresses across context switches and cpu changes.
> >
> > It's been tried before on powerpc, it doesn't work.
>
> OK, that pretty much answers that question.

I investigated that some time ago.

There are other obstacles too on x86-64, e.g. the relocations
are wrong for kernel mode. You would need to extend the linker first.

-Andi
