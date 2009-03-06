Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZCFIOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZCFIOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 03:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZCFIOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 03:14:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:51969 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZCFIOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 03:14:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JXW95krunlcr9gMzPYL1Jn3xCOVGKZ85aASNQ7KtvBM9oLHtkWGxauzoxfGRTJ/0MR
         jGxSWRLtbx39aIEAZHPpdLI+FArJtwBJoWlwJdpKWHcvl6aOuX7aZVxE9mTVn/S+oNwQ
         V7tV7Z9mpMoIiNfccyEIJtEoUMC2sVn6YZdFo=
Date: Fri, 6 Mar 2009 11:20:56 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] kmemdup_from_user(): introduce
Message-ID: <20090306082056.GB3450@x200.localdomain>
References: <49B0CAEC.80801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B0CAEC.80801@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 03:04:12PM +0800, Li Zefan wrote:
> I notice there are many places doing copy_from_user() which follows
> kmalloc():
> 
>         dst = kmalloc(len, GFP_KERNEL);
>         if (!dst)
>                 return -ENOMEM;
>         if (copy_from_user(dst, src, len)) {
> 		kfree(dst);
> 		return -EFAULT
> 	}
> 
> kmemdup_from_user() is a wrapper of the above code. With this new
> function, we don't have to write 'len' twice, which can lead to
> typos/mistakes. It also produces smaller code.

Name totally sucks, it mixes kernel idiom of allocation with purely
userspace function.

> A qucik grep shows 250+ places where kmemdup_from_user() *may* be
> used. I'll prepare a patchset to do this conversion.

250?

Let's not add wrapper for every two lines that happen to be used
together.

BTW, can we drop strstarts() and kzfree() on the same reasoning?
