Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbYIJUDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbYIJUDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYIJUDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:03:00 -0400
Received: from outbound-mail-124.bluehost.com ([67.222.38.24]:49763 "HELO
	outbound-mail-124.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751986AbYIJUC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:02:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=bqpeH2JG+RBplcO/d3eghWbTBlp1SWj2kAIVDCdm8rkkejM7XL0Dx7Lw6Q44nhPYpbKVfvYng6vQIyj8mmR4VdrrrbfS7Jr7JHDpv8tBmXfJgcmLNf4MNVq+khQdP9uM;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH 2.6.27-rc6] pci: fix resource_size_t type errors
Date: Wed, 10 Sep 2008 13:02:51 -0700
User-Agent: KMail/1.9.9
Cc: yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, johfel@users.sourceforge.net
References: <200809101942.m8AJgoXx029414@harpo.it.uu.se>
In-Reply-To: <200809101942.m8AJgoXx029414@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101302.52206.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 10, 2008 12:42 pm Mikael Pettersson wrote:
> Fix type errors introduced by commits
> 9bf8a1a79d549a0cf3b26c88d1ac8cdf07deafee and
> 76fbc263ff7e42ce8b21b8aee176e3c74b45f81a, "pci: debug extra pci resources
> range" and "pci: debug extra pci bus resources".
>
> These commits added printks of resource_size_t values using "%llx" formats.
> This is wrong for two reasons:
> - resource_size_t may be u32 or u64, depending on arch and config options,
>   but "%llx" only works with 64-bit integers; if there is a size mismatch,
>   printk's argument pointer will move past the corresponding parameters on
>   the stack (undefined behaviour)
> - even if resource_size_t is u64, that type may be unsigned long or
>   unsigned long long, depending on arch; if resource_size_t isn't unsigned
>   long long, the compiler will generate type mismatch warnings
>
> On my 32-bit x86 laptop, the first problem is visible in obviously bogus
> kernel messages:

Thanks Mikael, but I already integrated patches from Johann to fix this issue 
(53bc88701be91e7f631ad31418b32392aa952e9b and 
4ca8a7726fb0e8094fdb56f2ae2d69fcf9254eae in my for-linus tree).  I've queued 
it up for 2.6.27.

Thanks,
Jesse
