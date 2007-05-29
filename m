Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbXE2B1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbXE2B1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 21:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXE2B10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 21:27:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:37601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbXE2B10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 21:27:26 -0400
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
References: <9a1288909c10f2935af82ec5cea0c46b@pinky>
From: Andi Kleen <andi@firstfloor.org>
Date: 29 May 2007 04:23:45 +0200
In-Reply-To: <9a1288909c10f2935af82ec5cea0c46b@pinky>
Message-ID: <p738xb8fjv2.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft <apw@shadowen.org> writes:
> +
> +# no BUG() or BUG_ON()
> +		if ($line =~ /\b(BUG|BUG_ON)\b/) {
> +			print "Try to use WARN_ON & Recovery code rather than BUG() or BUG_ON()\n";

Just outlawing BUG_ON doesn't seem like a good idea to me. We'll just end
up with lots of untested and likely buggy recovery code or no asserts. Both
would be bad.

> +#need space before brace following if, while, etc
> +		if($line=~/\(.*\){/) {
> +			print ("need a space before the brace\n");
> +			print "$herecurr";
> +			$clean = 0;		
> +		}
> +
> +#gotos aren't indented

You mean goto labels? Surely goto statements are to be indented.
Confusing message

> +		if($line=~/^\s*[A-Za-z\d_]+:/ and !($line=~/^\s*default:/)){
> +			print "Gotos should not be indented\n";
> +			print "$herecurr";
> +			$clean = 0;
> +		}

emacs generates one space label in front of a goto label. I wouldn't
outlaw this.

> +# don't include <linux/video_decoder.h>

It would be probably better to define some syntax that makes it possible
to auto extract those from feature-removal-schedule.txt. Otherwise
long term this will become messy.

Possible further checks that might make sense:
- panic() anywhere in drivers/* 
- externs in .c files without asmlinkage
- general checking that everything in a fully visible {} block is the right 
indentation

-Andi
