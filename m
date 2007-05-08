Return-Path: <linux-kernel-owner+w=401wt.eu-S967325AbXEHLUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967325AbXEHLUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967311AbXEHLUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:20:11 -0400
Received: from mail.z-net.ru ([89.113.80.10]:1298 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966707AbXEHLUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:20:10 -0400
Date: Tue, 8 May 2007 15:19:24 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: akpm@linux-foundation.org
Cc: Greg KH <gregkh@suse.de>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: + git-battery-fix.patch added to -mm tree
Message-ID: <20070508111924.GA16785@zarina>
Reply-To: cbou@mail.ru
References: <200705081001.l48A1KUK020833@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200705081001.l48A1KUK020833@shell0.pdx.osdl.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 03:01:20AM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      git-battery-fix
> has been added to the -mm tree.  Its filename is
>      git-battery-fix.patch

Andrew, much thanks for fixing that. That error triggered by some
refactors in drivers/base/... I suppose I have to setup -mm tree in
addition to Linus', to test -mm builds from time to time for the
purpose of catching these changes myself.

Though, this error happened indeed because nobody cares about
find_bus function nowdays...

I want ask Greg KH and Evgeniy Polyakov: could you together settle
preferred way of accessing bus types? Should we really use
find_bus/bus_find, or Evgeniy would just export w1 bus type? In
later case, I'll remove un-"if 0" find_bus patch, and will
prepare another which will export w1 bus type.

I do not have any preference, both solutions will work.

Thanks,

> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: git-battery-fix
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Cc: Anton Vorontsov <cbou@mail.ru>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/base/bus.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/base/bus.c~git-battery-fix drivers/base/bus.c
> --- a/drivers/base/bus.c~git-battery-fix
> +++ a/drivers/base/bus.c
> @@ -740,7 +740,7 @@ void put_bus(struct bus_type * bus)
>  
>  struct bus_type * find_bus(char * name)
>  {
> -	struct kobject * k = kset_find_obj(&bus_subsys.kset, name);
> +	struct kobject * k = kset_find_obj(&bus_subsys, name);
>  	return k ? to_bus(k) : NULL;
>  }
>  EXPORT_SYMBOL_GPL(find_bus);
> _
> 

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
