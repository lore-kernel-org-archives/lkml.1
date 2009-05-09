Return-Path: <linux-kernel-owner+w=401wt.eu-S1751541AbZEIHa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbZEIHa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZEIHaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:30:18 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:32949 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZEIHaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:30:18 -0400
Date: Sat, 9 May 2009 09:32:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __setup_param(), unique_id and vdso_setup
Message-ID: <20090509073227.GA22397@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0905061519050.32023@localhost.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0905061519050.32023@localhost.lan>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 03:24:21PM -0400, Robert P. J. Day wrote:
> 
>   just going through my outstanding list of kernel cleanup pedantry,
> and i was reminded of this from include/linux/init.h:
> 
> =====
> ...
> #define __setup(str, fn)                                        \
>         __setup_param(str, fn, fn, 0)
> 
> /* NOTE: fn is as per module_param, not __setup!  Emits warning if fn
>  * returns non-zero. */
> #define early_param(str, fn)                                    \
>         __setup_param(str, fn, fn, 1)
> ...
> =====
> 
>   in short, both invocations of __setup_param() use identical second
> and third parameters, and a tree-wide grep shows:
> 
> $ grep -rw __setup_param *
> arch/x86/vdso/vdso32-setup.c:__setup_param("vdso=", vdso32_setup, vdso_setup, 0);
> include/linux/init.h:#define __setup_param(str, unique_id, fn, early)                   \
> include/linux/init.h:   __setup_param(str, fn, fn, 0)
> include/linux/init.h:   __setup_param(str, fn, fn, 1)
> include/linux/init.h:#define __setup_param(str, unique_id, fn)  /* nothing */
> $
> 
>   so apart from that single exception involving "vdso", that macro
> could be simplified to just get rid of that third parameter.  is there
> something special about the vdso boot-time parm that *requires* it to
> be the only boot-time parm in the entire kernel to have a different
> unique id?  just curious.  or does that have to be preserved for
> out-of-tree builds?
No - so please go ahead and clean it up.

Thanks,
	Sam
