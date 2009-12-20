Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZLTUMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZLTUMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 15:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbZLTUMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 15:12:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40050 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbZLTUMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 15:12:20 -0500
Date: Sun, 20 Dec 2009 21:10:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       peterz@infradead.org, efault@gmx.de, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: [PATCH] scripts/checkpatch.pl: Add WARN on printk format split
 on multiple lines
Message-ID: <20091220201052.GA5665@elte.hu>
References: <1261315437.4314.6.camel@laptop>
 <tip-3df0fc5b2e9d8092dcaeb5ae0b6753d85c851d66@git.kernel.org>
 <1261335300.30458.209.camel@Joe-Laptop.home>
 <20091220191531.GA17878@elte.hu>
 <1261338255.30458.222.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261338255.30458.222.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Sun, 2009-12-20 at 20:15 +0100, Ingo Molnar wrote:
> > Checkpatch should warn about printk 
> > lines that end with a '"', those are almost always a sign of some ill-advised 
> > break-the-string artifact.
> 
> Perhaps something like this:
> 
> diff from Andy Whitcroft's testing script,
> where logFunctions is defined.
> http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing
> 
> --- a/scripts/checkpatch.pl-testing	2009-12-20 11:35:28.000000000 -0800
> +++ b/scripts/checkpatch.pl-testing	2009-12-20 11:35:46.000000000 -0800
> @@ -1398,6 +1398,11 @@
>  			WARN("line over 80 characters\n" . $herecurr);
>  		}
>  
> +#Logging function format split over multiple lines
> +		if ($line =~ /^\+\s*$logFunctions.*"\s*$/) {
> +			WARN("Don't split logging function format\n" . $herecurr);
> +		}
> +

Havent tested it but this check would be lovely to have.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
