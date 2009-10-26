Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZJZLQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZJZLQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZJZLQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:16:41 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47078 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbZJZLQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:16:40 -0400
Date: Mon, 26 Oct 2009 11:16:42 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch.pl: Allow > 80 char lines for logging
 functions not just printk
Message-ID: <20091026111642.GE12089@shadowen.org>
References: <1254528604.1799.185.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254528604.1799.185.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 05:10:04PM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 87bbb8b..ae74ab1 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -186,6 +186,14 @@ our $typeTypedefs = qr{(?x:
>  	atomic_t
>  )};
>  
> +our $logFunctions = qr{(?x:
> +	printk|
> +	pr_(debug|dbg|vdbg|devel|info|warning|err|notice|alert|crit|emerg|cont)|
> +	dev_(printk|dbg|vdbg|info|warn|err|notice|alert|crit|emerg|WARN)|
> +	WARN|
> +	panic
> +)};
> +
>  our @typeList = (
>  	qr{void},
>  	qr{(?:unsigned\s+)?char},
> @@ -1367,7 +1375,7 @@ sub process {
>  #80 column limit
>  		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
>  		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
> -		    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
> +		    $line !~ /^\+\s*$logFunctions\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
>  		    $length > 80)
>  		{
>  			WARN("line over 80 characters\n" . $herecurr);

Yep that looks reasonable to me.  I have a slightly modified version in
my tree.  Will be in the next batch to akpm.

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
