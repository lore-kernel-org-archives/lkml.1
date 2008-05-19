Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbYESTmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbYESTmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbYESTmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:42:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:34634 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYESTmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:42:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=waU6xKeKdv04bKZHyAKOtRr7PVfsDIyIW3VKY+3N7XUaZg10o9UXkPXcXbUoy7fMEzqTuyx3gFa29eiq3PTrwqT2+CSa673FzKguJWAdoqpXiBgiwKi6JbDCHcWRejEIBHP4iD0l4BHXnou6hbZaYlYUajyn23wyUKhOtnpZV8o=
Date: Tue, 20 May 2008 00:37:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4-mm-delalloc-ext4-lock-reverse-fix
Message-ID: <20080519203752.GA4967@martell.zuzino.mipt.ru>
References: <20080519002919.1f8f21f6.akpm@linux-foundation.org> <1211210687-4212-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211210687-4212-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 05:24:47PM +0200, Jiri Slaby wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Mon, 19 May 2008 15:15:09 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
> > 
> > > With 2.6.26-rc2-mm1 I need to sync frequently. It's not normal as my
> > > understanding.
> > > 
> > > 1. scp a big file from a lan server. Firstly the speed is about 8M/s,
> > > but the speed will slow down to 100K/s at last. After I exec "sync",
> > > the speed will restore.
> > > 
> > > Is this a known issue?
> > > 
> > 
> > Yes, probably related to the "mkfs takes forever" problem.  I haven't
> > looked into it yet.  Nor has anyone else afaik.
> 
> Absolutely not sure what this breaks in ext4, but fixes the problem for me:

This helps, thank you!

> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -881,7 +881,7 @@ int write_cache_pages(struct address_space *mapping,
>  	pagevec_init(&pvec, 0);
>  	if (wbc->range_cyclic) {
>  		index = mapping->writeback_index; /* Start from prev offset */
> -		end = wbc->range_end >> PAGE_CACHE_SHIFT;
> +		end = -1;
>  	} else {
>  		index = wbc->range_start >> PAGE_CACHE_SHIFT;
>  		end = wbc->range_end >> PAGE_CACHE_SHIFT;

