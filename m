Return-Path: <linux-kernel-owner+w=401wt.eu-S965692AbXCLLr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692AbXCLLr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965722AbXCLLr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:47:28 -0400
Received: from mx10.go2.pl ([193.17.41.74]:40573 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965692AbXCLLr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:47:27 -0400
Date: Mon, 12 Mar 2007 12:51:37 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: David Miller <davem@davemloft.net>
Cc: amit2030@gmail.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] [REVISED] net/ipv4/multipath_wrandom.c: check   kmalloc() return value.
Message-ID: <20070312115137.GA3270@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308.232908.92582631.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-03-2007 08:29, David Miller wrote:
> From: Amit Choudhary <amit2030@gmail.com>
> Date: Thu, 8 Mar 2007 23:22:15 -0800
> 
>> Description: Check the return value of kmalloc() in function wrandom_set_nhinfo(), in file net/ipv4/multipath_wrandom.c.
>>
>> Signed-off-by: Amit Choudhary <amit2030@gmail.com>
> 
> This kind of patch has been submitted several times before and it's
> never accepted because you have to do much more than this to recover
> from the allocation error.
> 
> There is no error status returned to the caller, so the callers assume
> the operation succeeded, and will either OOPS or crash in some other
> way.
> 
> Therefore, just adding some NULL pointer checks and returning is not
> going to fix this bug.
> 
> The whole cahce-multipath subsystem has to have it's guts revamped for
> proper error handling.

But until then it'll unnecessarily spoil linux opinion as regards
stability and waste time of developers to check error messages.
So, maybe it's less evil to check those NULLs where possible and add
some WARN_ONs here and there...

Regards,
Jarek P.
