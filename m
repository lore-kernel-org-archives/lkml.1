Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbXJKOcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbXJKOcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 10:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbXJKOcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 10:32:31 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1786 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXJKOca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 10:32:30 -0400
Date: Thu, 11 Oct 2007 15:32:16 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: "Mike D. Day" <ncmike@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] fix minor problems in checkpatch.pl-next
Message-ID: <20071011143216.GD3376@shadowen.org>
References: <20071011122800.GA10216@silverwood.ncultra.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011122800.GA10216@silverwood.ncultra.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 08:28:00AM -0400, Mike D. Day wrote:
> When forming the prefix to output error msgs in gnu gcc format, the
> lack of a type ($ or @) when referencing ARGV causes error messages.
> 
> When invoked to check source files, the linenumber was off by +3 in
> the gcc format output.
> 
> Signed-off-by: Mike D. Day <ncmike@ncultra.org>
> 
> --- checkpatch.pl-next	2007-10-11 07:28:41.000000000 -0400
> +++ /home/mdday/bin/checkpatch	2007-10-11 08:16:07.000000000 -0400
> @@ -452,7 +452,6 @@
> 
> 		my $rawline = $line;
> 
> -		$prefix = "ARGV:$linenr: " if ($emacs);
> 
> #extract the filename as it passes
> 		if ($line=~/^\+\+\+\s+(\S+)/) {
> @@ -517,6 +516,9 @@
> 		my $herecurr = "$here\n$line\n";
> 		my $hereprev = "$here\n$prevline\n$line\n";
> 
> +		$prefix = "@ARGV:$realline: " if ($emacs && $file);
> +		$prefix = "@ARGV:$linenr: " if ($emacs && !$file);
> +
> #check the patch for a signoff:
> 		if ($line =~ /^\s*signed-off-by:/i) {
> 			# This is a signoff, if ugly, so do not double 
> 			report.

Hmmm, dunno how this one ever was visible?  Some error on my part.  That
line now shows $filename rather than ARGV.  

I see you have different line numbers depending on whether this is a
file or diff.  Would you ever pass in a plain diff in emacs mode, and
what would the line number mean.

-apw
