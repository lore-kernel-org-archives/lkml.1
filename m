Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbYBEAHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbYBEAHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757352AbYBEAH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:07:28 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38348 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064AbYBEAH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:07:27 -0500
Date: Tue, 5 Feb 2008 00:06:39 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: yi.y.yang@intel.com, greg@kroah.com, rdunlap@xenotime.net,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1: module params broken
In-Reply-To: <20080204150638.512f46ea.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802042357470.4513@blonde.site>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0802042140250.8210@blonde.site> <20080204150638.512f46ea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008, Andrew Morton wrote:
> 
> Takashi found a bug in it:

Bless him.

> --- a/lib/vsprintf.c~add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2
> +++ a/lib/vsprintf.c
> @@ -234,7 +234,7 @@ int strict_strto##type(const char *cp, u
>  		if (ret != 0)						\
>  			*res = -(*res);					\
>  	} else								\
> -		ret = strict_strtou##type(cp+1, base, res);		\
> +		ret = strict_strtou##type(cp, base, res);		\
>  									\
>  	return ret;							\
>  }									\
> _
> 
> and I was very bad and didn't immediately prepare and upload the fix and
> hence probably wasted a lot of your time, for which I apologise.  In my
> defense, it was 4:00AM Sunday and I had lost eye control by then.

Please don't even begin to think of apologizing to me:
that's so much the wrong way round it's embarrassing.

It's scary to think of how much of your time gets wasted
on knocking these -mms into some kind of shape that's
then ready for the rest of us to start attacking them.

> Does that fix fix it?  If not: patch overboard.

Reprieve!  Indeed that precisely fixes it: numerous
modules now working again with that fix.  Thanks a lot.

Hugh
