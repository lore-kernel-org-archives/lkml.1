Return-Path: <linux-kernel-owner+w=401wt.eu-S1764531AbXHPJWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764531AbXHPJWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 05:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbXHPJW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 05:22:26 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4924 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbXHPJWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 05:22:25 -0400
Message-ID: <46C41730.3060009@shadowen.org>
Date: Thu, 16 Aug 2007 10:21:52 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Eugene Teo <eugeneteo@kernel.sg>
CC: linux-kernel@vger.kernel.org, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] Make checkpatch rant about trailing ; at the end of "if"
 expr
References: <20070816052215.GA3857@kernel.sg>
In-Reply-To: <20070816052215.GA3857@kernel.sg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eugene Teo wrote:
> Make checkpatch rant about trailing ; at the end of "if" expression.
> 
> Thanks to Auke for the regexp.
> 
> Signed-off by: Eugene Teo <eugeneteo@kernel.sg>
> 
> --- checkpatch.pl-0.09.default	2007-08-03 23:31:40.000000000 +0800
> +++ checkpatch.pl-0.09	2007-08-16 13:18:40.000000000 +0800
> @@ -1091,6 +1091,12 @@ sub process {
>  				CHK("__setup appears un-documented -- check Documentation/kernel-parameters.txt\n" . $herecurr);
>  			}
>  		}
> +
> +# checks for trailing ; at the end of "if" expression
> +		if ($line =~ /\bif\s*\([^\)]*\)\s*\;/) {
> +			my $herevet = "$here\n" . cat_vet($line) . "\n";
> +			ERROR("trailing ;\n" . $herevet);
> +		}
>  	}
>  
>  	if ($chk_patch && !$is_patch) {

Heh, you are the second person to suggest this check today, do I detect
some ripped out hair due to one of these!

I've taken this idea and expanded it to cover if, for and while which
can all suffer from this.  Using the relative indent to work out which
are valid combinations:

WARNING: Trailing semicolon indicates no statements, indent implies
otherwise
#28: FILE: Z17.c:25:
+       if (foo);
+               return 10;
WARNING: Trailing semicolon indicates no statements, indent implies
otherwise
#31: FILE: Z17.c:28:
+       for (a; b; c);
+               a += *b;

Thanks for the patch.

-apw
