Return-Path: <linux-kernel-owner+w=401wt.eu-S965159AbZLGWEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965159AbZLGWEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965065AbZLGWEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:04:53 -0500
Received: from fieldses.org ([174.143.236.118]:49021 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010AbZLGWEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:04:53 -0500
Date: Mon, 7 Dec 2009 17:05:01 -0500
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       William Allen Simpson <william.allen.simpson@gmail.com>
Subject: Re: [PATCH] scripts/checkpatch.pl: Add warning about leading
	contination tests
Message-ID: <20091207220501.GF32454@fieldses.org>
References: <1260035884.11126.58.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260035884.11126.58.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05, 2009 at 09:58:04AM -0800, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index bc4114f..c35933a 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2064,6 +2064,11 @@ sub process {
>  			CHK("multiple assignments should be avoided\n" . $herecurr);
>  		}
>  
> +# Check use of leading logical continuation tests
> +		if ($line =~ /^.\s*(\|\||&&)/) {
> +			WARN("Continuation logic should be at end of previous line\n" . $herecurr);
> +		}
> +
>  ## # check for multiple declarations, allowing for a function declaration
>  ## # continuation.
>  ## 		if ($line =~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Ident.*/ &&

Where does this preference come from?

In

	excessivelylongcondition
	&& anotherreallylongcondition
	&& yetanotherunbelievablylongcondition
	&& yetanotherwellyougettheidea

I want to be able to keep the &&'s all justified.

Or look for well-typeset math or CS texts and try to find any that leave
operators dangling on the right.

I don't really care much about this particular point, but: the
checkpatch output is already getting too verbose to be useful, without
adding advice that's actually the opposite of what I'd normally want to
do....

--b.
