Return-Path: <linux-kernel-owner+w=401wt.eu-S1751329AbZKOFLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbZKOFLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 00:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbZKOFLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 00:11:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:64604 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbZKOFLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 00:11:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GwqSa2XGcNZtfQ57xDq0PFoBCmteJvAKQrH93hQ9K1XKB4txwXKIIzTwAkYDGVqoAU
         VVXcldzuQ6dtBUDTALLoC+7nHglGNl2jZeBa4mgnvCMCGpoFwH9QLB09YTclt+ldg1dK
         zedPWr2tvL0sqxG92ykMG8HodqvR3yn1TVFX8=
Date: Sun, 15 Nov 2009 06:11:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tools: New function to parse string representing
	size in bytes
Message-ID: <20091115051155.GB5427@nowhere>
References: <1258257045-1363-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258257045-1363-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 15, 2009 at 12:50:45PM +0900, Hitoshi Mitake wrote:
> This patch modifies util/string.[ch] to add new function: bytesexp2int()
> to parse string representing size in bytes.
> 
> Below is the description of bytesexp2int().
> 
> Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB) (e.g. "256MB")
> and return its numeric value. (e.g. 268435456)
> 
> The parameter str is not changed before and after calling,
> but it changed temporally and internally for atoi().
> So type of str is char *, not const char *.
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  tools/perf/util/string.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/string.h |    1 +
>  2 files changed, 90 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
> index 04743d3..bbedb06 100644
> --- a/tools/perf/util/string.c
> +++ b/tools/perf/util/string.c
> @@ -1,4 +1,5 @@
>  #include <string.h>
> +#include <stdlib.h>
>  #include "string.h"
>  
>  static int hex(char ch)
> @@ -43,3 +44,91 @@ char *strxfrchar(char *s, char from, char to)
>  
>  	return s;
>  }
> +
> +static int digit(char ch)
> +{
> +	if ('0' <= ch && ch <= '9')
> +		return 1;
> +	return 0;
> +}



We have a "isdigit" macro in util.h already, despite the even already
existing isdigit from the libc. I don't know why we have that. I guess
it comes from git sources but I'm not sure why it has been reimplemented.

