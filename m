Return-Path: <linux-kernel-owner+w=401wt.eu-S1423106AbXD3HZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423106AbXD3HZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423110AbXD3HZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:25:46 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:48223
	"EHLO gwia-smtp.id2.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1423106AbXD3HZp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:25:45 -0400
Message-Id: <4635B62D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 30 Apr 2007 08:26:05 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Bryan O'Sullivan" <bos@pathscale.com>, "Andi Kleen" <ak@suse.de>
Cc: "Roland Dreier" <rolandd@cisco.com>, <linux-kernel@vger.kernel.org>,
       <patches@x86-64.org>
Subject: Re: [patches] [PATCH] [8/35] x86_64: a memcpy that tries to
	reducecache pressure
References: <20070428752.712152000@suse.de>
 <20070428175232.5A688151CA@wotan.suse.de>
In-Reply-To: <20070428175232.5A688151CA@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>+	testb	$8, %dxl	/* rdx is 3,5,6,7,9..15 */

Could you use the more conventional name %dl (or whatever is being meant)
here?

>+.L42:
>+	prefetchnta	128(%rsi)

I think I commented similarly on a previous version of the patch: This will 
- result in still bringing the first 128 bytes into the cache
- prevent caching of memory beyond the buffer being dealt with

>+	sfence

Similarly, I continue to believe this is wrong here (again I commented before
that this is likely unnecessary, or if at all, it should be an lfence).

>+	orl	%edx, %edx

Operations of this type generally should use 'test', not 'or' or 'and'.

Jan


