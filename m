Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbYJYH60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbYJYH60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 03:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYJYH6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 03:58:17 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:56362 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYJYH6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 03:58:17 -0400
Date: Sat, 25 Oct 2008 09:59:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [pull request] getting rid of __cpuinit
Message-ID: <20081025075925.GA22805@uranus.ravnborg.org>
References: <20081024142056.6a2d082a@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024142056.6a2d082a@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 02:20:56PM -0700, Arjan van de Ven wrote:
> Hi Linus,
> 
> this is one of those pull requests for which the best timing is likely at the 
> end of the merge window due to touching a large number of files in a trivial way.
> In fact, 6 of the 8 patches were done via regexps:
> 
> find -name "*.c" | xargs sed -i "s/^__cpuinit //g"
> find arch/ -name "*.h" | xargs sed -i "s/ __cpuinit//g"
> find -name "*.c" | xargs sed -i "s/ __cpuinit$//g"
> find -name "*.c" | xargs sed -i "s/ __cpuinitdata//g"
> find -name "*.c" | xargs sed -i "s/ __cpuexit / /g"
> find -name "*.c" | xargs sed -i "s/ __cpuinit / /g"
> 
> (I suppose asking for a "git sed" is too much to do...)
> 
> The point of this series is to get rid of __cpuinit. (I'll be working on other __XXXXinit after this)
> __cpuinit is a NOOP for CONFIG_HOTPLUG_CPU, which on for just about anybody in practice 
> (in fact I had to disable 6 common options to even be ABLE to turn it off for size testing) 
> and all distros also ship with it enabled.
> 
> Yet it's a rather error prone construct since the rules of this sort of __XXXXinit thing are
> rather complex and convoluted.. better to just get rid of it entirely.
> 
> As for the code size effect, after I spent a bunch of time cursing and trying to find out
> how to disable HOTPLUG_CPU, I managed to get an x86-64 build that actually shows how much space 
> we ACTUALLY save with all the __cpuinit's in the tree... it's less than 2Kb. That is, if you manage
> to turn it actually off.
> 
>    text	   data	    bss	    dec	    hex	filename
> 4618096	1358684	 848588	6825368	 682598	vmlinux.before
> 4619965	1356908	 848716	6825589  682675	vmlinux.after

The interesting number here is the size of the cpuinit/cpuexit sections.
cpuinit sections are discarded after init and cpuexit sections are discarded
if you do not use modules.

Can you share these numbers with us?

	Sam
