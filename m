Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbXLUSMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbXLUSMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 13:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXLUSMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 13:12:12 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:2371 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbXLUSMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 13:12:12 -0500
Date: Fri, 21 Dec 2007 18:12:02 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: bbpetkov@yahoo.de, rdunlap@xenotime.net, jschopp@austin.ibm.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: add a check for the patch level (patch -p<num>)
Message-ID: <20071221181202.GU13186@shadowen.org>
References: <20071217071105.GA10869@gollum.tnic> <20071218054641.GA15994@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218054641.GA15994@gollum.tnic>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 06:46:41AM +0100, Borislav Petkov wrote:
> On Mon, Dec 17, 2007 at 08:11:05AM +0100, Borislav Petkov wrote:
> 
> A slightly microoptimized version 1.1:
> 
> ---
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> 
> Check the patch level of the single hunks in a patch file, however only when
> checkpatch.pl is called from within the kernel tree.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> --
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 579f50f..3eda27b 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -653,6 +653,18 @@ sub CHK {
>  	}
>  }
>  
> +sub check_patchlevel {
> +
> +	if ($tree) {
> +		my ($path) = @_;
> +		$path =~ s![^/]*/!!;
> +
> +		if (!stat($path)) {
> +			WARN("Check the patchlevel (hint: patch option -p)");
> +		}
> +	}

Hmmm that will trigger on all patches which create new files if I am
grokking you correctly.

I would have thought this would pretty easy to check from the form of
the names.  Hmmm.

> +}
> +
>  sub process {
>  	my $filename = shift;
>  	my @lines = @_;
> @@ -713,10 +725,16 @@ sub process {
>  #extract the filename as it passes
>  		if ($line=~/^\+\+\+\s+(\S+)/) {
>  			$realfile=$1;
> +
> +			if ($realfile) {
> +				check_patchlevel($realfile);
> +			}
> +
>  			$realfile =~ s@^[^/]*/@@;
>  			$in_comment = 0;
>  			next;
>  		}
> +
>  #extract the line range in the file after the patch is applied
>  		if ($line=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
>  			$is_patch = 1;

-apw
