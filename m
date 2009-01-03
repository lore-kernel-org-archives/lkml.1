Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbZACB7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbZACB7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 20:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZACB6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 20:58:53 -0500
Received: from mail.crca.org.au ([67.207.131.56]:55032 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423AbZACB6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 20:58:52 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2009 20:58:52 EST
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH] headers_check.pl: disallow extern's
From: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Reply-To: ncunningham-lkml@crca.org.au
To: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1230363816-24097-1-git-send-email-vapier@gentoo.org>
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 12:51:46 +1100
Message-Id: <1230947506.7675.32.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2008-12-27 at 02:43 -0500, Mike Frysinger wrote:
> Since prototypes with "extern" refer to kernel functions, they make no
> sense in userspace, so reject them automatically.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  scripts/headers_check.pl |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
> index 488a3b1..15b9bc6 100644
> --- a/scripts/headers_check.pl
> +++ b/scripts/headers_check.pl
> @@ -33,6 +33,7 @@ foreach my $file (@files) {
>  	while ($line = <FH>) {
>  		$lineno++;
>  		check_include();
> +		check_prototypes();
>  	}
>  	close FH;
>  }
> @@ -54,3 +55,11 @@ sub check_include
>  		}
>  	}
>  }
> +
> +sub check_prototypes
> +{
> +	if ($line =~ m/^\s*extern\b/) {
> +		printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";

s/extern's/externs/

> +		$ret = 1;
> +	}
> +}

Regards,

Nigel

