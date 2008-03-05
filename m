Return-Path: <linux-kernel-owner+w=401wt.eu-S933677AbYCEXJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677AbYCEXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933219AbYCEXEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:04:51 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44556 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933214AbYCEXEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:04:49 -0500
Date: Thu, 6 Mar 2008 01:04:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 2/2] modules: Whine about suspicious return values from
	module's ->init() hook
Message-ID: <20080305230445.GB937@cs181133002.pp.htv.fi>
References: <200803042321.01683.rusty@rustcorp.com.au> <200803042322.26693.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200803042322.26693.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 11:22:26PM +1100, Rusty Russell wrote:
> Subject: Whine about suspicious return values from module's ->init() hook
> Date: Mon, 11 Feb 2008 01:09:06 +0300
> From: Alexey Dobriyan <adobriyan@gmail.com>
> 
> Return value convention of module's init functions is 0/-E. Sometimes, e.g.
> during forward-porting mistakes happen and buggy module created, where result
> of comparison "workqueue != NULL" is propagated all the way up to
> sys_init_module. What happens is that some other module created workqueue in
> question, our module created it again and module was successfully loaded.
> 
> Or it could be some other bug.
> 
> Let's make such mistakes much more visible. In retrospective, such messages
> would noticeably shorten some of my head-scratching sessions.
> 
> Note, that dump_stack() is just a way to get attention from user.
> Sample message:
> 
> sys_init_module: 'foo'->init suspiciously returned 1, it should follow 0/-E convention
> sys_init_module: loading module anyway...
>...

While I agree with Andrew that a BUG() would not be appropriate here I'm 
wondering why the module should be loaded?

We do know that something in the module is buggy.

And not loading the module also seems to be a good compromise between 
making the user notice the problem and not doing a panic().

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

