Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbYKLNzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbYKLNzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYKLNz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:55:26 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:48292 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbYKLNzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:55:25 -0500
Date: Wed, 12 Nov 2008 13:55:22 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] checkpatch: Add warning for p0-patches
Message-ID: <20081112135522.GD8302@shadowen.org>
References: <1225467370-19143-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225467370-19143-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 04:36:10PM +0100, Wolfram Sang wrote:
> Some people work internally with -p0-patches which has the danger that
> one forgets to convert them to -p1 before mainlining. Bitten myself and
> seen p0-patches in mailing lists occasionally, this patch adds a warning
> to checkpatch.pl in case a patch is -p0. If you really want, you can
> fool this check to generate false positives, this is why it just spits a
> warning. Making the check 100% proof is trickier than it looks, so let's
> start with a version which catches the cases of real use.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  scripts/checkpatch.pl |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index f88bb3e..dae5854 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1051,6 +1051,7 @@ sub process {
>  	my $in_comment = 0;
>  	my $comment_edge = 0;
>  	my $first_line = 0;
> +	my $p1_prefix = '';
>  
>  	my $prev_values = 'E';
>  
> @@ -1196,7 +1197,12 @@ sub process {
>  		# extract the filename as it passes
>  		if ($line=~/^\+\+\+\s+(\S+)/) {
>  			$realfile = $1;
> -			$realfile =~ s@^[^/]*/@@;
> +			$realfile =~ s@^([^/]*)/@@;
> +
> +			$p1_prefix = $1;
> +			if ($tree && -e "$root/$p1_prefix") {
> +				WARN("Patch prefix '$p1_prefix' exists. Is it maybe a p0-patch?\n");
> +			}
>  
>  			if ($realfile =~ m@^include/asm/@) {
>  				ERROR("do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");

Looks reasonable.  Committed this with a few mods to my tree.  Will be
in the next batch of updates.

-apw
