Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671Ab0AZQ1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0AZQ1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567Ab0AZQ1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:27:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48715 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0AZQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:27:35 -0500
Date: Tue, 26 Jan 2010 16:27:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       "Serge E. Hallyn" <serue@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [RFC PATCH 1/2] Fix 1 untangling ima mess, part 2 with counters
Message-ID: <20100126162730.GI19799@ZenIV.linux.org.uk>
References: <cover.1264018123.git.zohar@linux.vnet.ibm.com> <4ad974923eae7a8f52be0786a630b6c64bee9d32.1264018123.git.zohar@linux.vnet.ibm.com> <20100123230735.GW19799@ZenIV.linux.org.uk> <1264447477.3696.30.camel@dyn9002018117.watson.ibm.com> <20100126130349.GH19799@ZenIV.linux.org.uk> <1264519015.3789.28.camel@dyn9002018117.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264519015.3789.28.camel@dyn9002018117.watson.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 10:16:55AM -0500, Mimi Zohar wrote:
> --- security-testing-2.6.orig/init/main.c
> +++ security-testing-2.6/init/main.c
> @@ -663,9 +663,9 @@ asmlinkage void __init start_kernel(void
>  	proc_caches_init();
>  	buffer_init();
>  	key_init();
> +	radix_tree_init();
>  	security_init();
>  	vfs_caches_init(totalram_pages);
> -	radix_tree_init();
>  	signals_init();
>  	/* rootfs populating might need page-writeback */
>  	page_writeback_init();

FWIW, I'd take radix_tree_init() much earlier than that; it's a common
infrastructure and if we have it early it'll mean less headache.

AFAICS, it can go right after mm_init().  Objections, anyone?

Other than that, I'm OK with that one.
