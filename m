Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYIHWSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYIHWSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYIHWSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:18:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbYIHWSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:18:10 -0400
Date: Mon, 8 Sep 2008 15:17:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: adobriyan@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       sfr@canb.auug.org.au, Johannes Berg <johannes@sipsolutions.net>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH -mm] Fix dev_load() compilation again
Message-Id: <20080908151707.21cd1c6c.akpm@linux-foundation.org>
In-Reply-To: <48C18E8B.9050201@ct.jp.nec.com>
References: <20080904224004.d3dd3076.akpm@linux-foundation.org>
	<20080905193244.GD11569@x200.localdomain>
	<48C18E8B.9050201@ct.jp.nec.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Sep 2008 12:54:51 -0700
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Alexey Dobriyan wrote:
> > dev_load() doesn't exist if MODULES=n.
> 
> Hi,
> 
> in -next tree, this patch fixes the compilation error instead of
> my patch. So, there is a conflict.
> 
> commit 9b90dc7bc3079376567fc501e2e84751fa4040fd
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Wed Aug 27 14:45:37 2008 +1000
> 
>     rr: build fix for remove CONFIG_KMOD from net
> 
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 

Give that there's already a fix in linux-next, I can't do anything here.

Rusty, the regression was introduced by

commit 4cb9da6ecc2b0e25056b45981239475f8509d59d
Author:     Johannes Berg <johannes@sipsolutions.net>
AuthorDate: Wed Jul 9 10:28:42 2008 +0200
Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
CommitDate: Tue Aug 26 10:19:47 2008 +1000

    remove CONFIG_KMOD from net
    
    Some code here depends on CONFIG_KMOD to not try to load
    protocol modules or similar, replace by CONFIG_MODULES
    where more than just request_module depends on CONFIG_KMOD
    and and also use try_then_request_module in ebtables.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Cc: netdev@vger.kernel.org
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Could you please take care of getting it fixed up?

Thanks.
