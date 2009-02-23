Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZBWOn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZBWOn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZBWOnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:43:18 -0500
Received: from adelie.canonical.com ([91.189.90.139]:55248 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZBWOnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:43:17 -0500
Date: Mon, 23 Feb 2009 14:43:12 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch --file warns about p0 patch
Message-ID: <20090223144312.GC22617@shadowen.org>
References: <49A2B0A5.8050905@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A2B0A5.8050905@compulab.co.il>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 04:20:21PM +0200, Mike Rapoport wrote:
> When running checkpatch.pl with --file option it warns about -p0 patch:
> 
> ./scripts/checkpatch.pl --file ./drivers/rtc/rtc-v3020.c
> WARNING: patch prefix '.' exists, appears to be a -p0 patch
> 
> total: 0 errors, 1 warnings, 263 lines checked
> 
> ./drivers/rtc/rtc-v3020.c has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 
> I hope this is the fix that'll work:
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 45eb0ae..1869388 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1240,7 +1240,7 @@ sub process {
>  			$realfile =~ s@^([^/]*)/@@;
> 
>  			$p1_prefix = $1;
> -			if ($tree && $p1_prefix ne '' && -e "$root/$p1_prefix") {
> +			if (!$file && $tree && $p1_prefix ne '' && -e "$root/$p1_prefix") {
>  				WARN("patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
>  			}
> 
> 
> 
> -- 

Hmm, that should already be fixed in the version Andrew Morton has.
Could you test with v0.28 and confirm its already fixed?


  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-v0.28

-apw
