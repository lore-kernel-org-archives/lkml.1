Return-Path: <linux-kernel-owner+w=401wt.eu-S2992628AbXCWXSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992628AbXCWXSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 19:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992617AbXCWXSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 19:18:55 -0400
Received: from twin.jikos.cz ([213.151.79.26]:52751 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992622AbXCWXSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 19:18:54 -0400
Date: Sat, 24 Mar 2007 00:18:10 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Eric Dumazet <dada1@cosmosbay.com>, Tomas M <tomas@slax.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] [bugfix] loop.c
In-Reply-To: <46042FA2.20303@tls.msk.ru>
Message-ID: <Pine.LNX.4.64.0703240011420.29565@twin.jikos.cz>
References: <4603DE86.1090009@slax.org> <20070323151956.1ac6a47b.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703231522200.5030@twin.jikos.cz> <20070323155115.89f86b3b.dada1@cosmosbay.com>
 <46042FA2.20303@tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, Michael Tokarev wrote:

> Speaking of which, I wonder...  Here, and in many other places.
> If some variable is marked as MODULE_PARAM (or whatever it is called 
> nowadays), used in module init routine, AND subsequently used for 
> various bound checks and loops...
[...]
> and so on.  Together with:
>   # modprobe foo n=10
>   # echo 20 > /sys/module/foo/parameters/n
> After that, we have 10 entries in mem[], and n is equal to 20, so the 
> for-loop above will be up to i=19.  Which will reference unallocated 
> memory.... Amd I dreaming?

This can be solved either by using module_param_call() in every module, 
and properly handling the "asynchronous" changes of module parameter, or 
by just disallowing the parameter from being tuned through sysfs 
completely (by setting the 'permissions' parameter of module_param() to 
zero ... which is what many drivers do anyway, I'd guess).

-- 
Jiri Kosina
