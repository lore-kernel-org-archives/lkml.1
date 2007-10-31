Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbXJaWZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbXJaWZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbXJaWZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:25:16 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:47065 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbXJaWZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:25:13 -0400
Message-ID: <47290096.7080207@oracle.com>
Date: Wed, 31 Oct 2007 15:24:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] eradicate bashisms in scripts/patch-kernel
References: <20071031211321.GA8363@rhlx01.hs-esslingen.de>
In-Reply-To: <20071031211321.GA8363@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> Hello,
> 
> I was non-mildly horrified to find that the rather widely used patch-kernel
> script seems to rely on bash despite specifying the interpreter as #!/bin/sh,
> since my dash-using Debian install choked on it.
> 
> Thus I'm delivering a first, preliminary, non-reviewed change to make
> patch-kernel (a little bit more?) POSIX-compatible. It now survives both
> a dash and a bash run.
> 
> If this mail goes through relatively unscathed, then it might be a good
> idea to plant it into -mm via a follow-up mail.
> 
> Comments?
> 
> - replaced "==" by "="

Those are OK.

> - the "source" statement most likely needs the ./ prepended, as can be
> gathered from e.g. http://osdir.com/ml/colinux.devel/2005-12/msg00036.html

That email isn't very convincing to me.

http://www.opengroup.org/onlinepubs/009695399/utilities/dot.html just says that
if <filename> does not contain a slash, the search PATH shall be used (searched).
If you want to prevent that, it's OK to use ./, but at least say that in the
patch description, please.


> - the newly replaced sed expression below: is it ok? correct? strict enough?
> 
> Thanks,
> 
> Andreas Mohr
> 
> (who's strongly hoping that submitting a patch for this thingy doesn't
> automatically equal becoming "maintainer for life" for it ;)

Be careful.

> --- linux-2.6.23/scripts/patch-kernel	2007-10-31 21:55:26.000000000 +0100
> +++ linux-2.6.23/scripts/patch-kernel.dash	2007-10-31 21:58:37.000000000 +0100


> @@ -202,13 +202,7 @@
>  EXTRAVER=
>  if [ x$EXTRAVERSION != "x" ]
>  then
> -	if [ ${EXTRAVERSION:0:1} == "." ]; then
> -		EXTRAVER=${EXTRAVERSION:1}
> -	else
> -		EXTRAVER=$EXTRAVERSION
> -	fi
> -	EXTRAVER=${EXTRAVER%%[[:punct:]]*}
> -	#echo "$PNAME: changing EXTRAVERSION from $EXTRAVERSION to $EXTRAVER"

What's the problem above?

> +	EXTRAVER=`echo $EXTRAVERSION|sed -s 's/^[\.]\?\([^[:punct:]]*\).*/\1/'`
>  fi
>  
>  #echo "stopvers=$stopvers"
> @@ -251,16 +245,16 @@
>  do
>      CURRENTFULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
>      EXTRAVER=

>  
> -    SUBLEVEL=$((SUBLEVEL + 1))
> +    SUBLEVEL=$(( $SUBLEVEL + 1 ))

Why are the added spaces needed?

Did you look at
http://www.opengroup.org/onlinepubs/000095399/utilities/xcu_chap02.html ?

>      FULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
>      #echo "#___ trying $FULLVERSION ___"
>  
> -    if [ $((SUBLEVEL)) -gt $((STOPSUBLEVEL)) ]; then
> +    if [ $SUBLEVEL -gt $STOPSUBLEVEL ]; then

What's the problem here?

>  	echo "Stopping since sublevel ($SUBLEVEL) is beyond stop-sublevel ($STOPSUBLEVEL)"
>  	exit 1
>      fi


-- 
~Randy
