Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZLIHc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZLIHc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbZLIHc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:32:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58672 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbZLIHc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:32:57 -0500
Date: Wed, 9 Dec 2009 08:32:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <herrmann.der.user@googlemail.com>
Subject: Re: [PATCH] checkpatch.pl: Warn on pr_<level> or dev_<level> with
 KERN_<level>
Message-ID: <20091209073255.GB8187@elte.hu>
References: <200912082259.nB8Mx2ih008207@hera.kernel.org>
 <1260313613.27677.169.camel@Joe-Laptop.home>
 <20091209060538.GD2512@elte.hu>
 <1260341479.27677.193.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260341479.27677.193.camel@Joe-Laptop.home>
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

> On Wed, 2009-12-09 at 07:05 +0100, Ingo Molnar wrote:
> > ( Andy: i suspect checkpatch could also grow a new warning perhaps, the
> >   '\<pr_.*(KERN_.*' pattern will i suspect pinpoint something fishy in 
> >   most cases. )
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index bc4114f..ffd8210 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1832,6 +1832,12 @@ sub process {
>  			}
>  		}
>  
> +# pr_<level> and dev_<level> should not use KERN_* levels
> +
> +		if ($line =~ /\b(pr_|dev_)[a-z]+.*KERN_/) {

putting \( into the pattern would further reduce the chance of false 
positives.

	Ingo
