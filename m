Return-Path: <linux-kernel-owner+w=401wt.eu-S1764934AbYEVGaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764934AbYEVGaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 02:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbYEVG3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 02:29:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757232AbYEVG3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 02:29:51 -0400
Date: Wed, 21 May 2008 23:29:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/ver_linux use 'gcc -dumpversion'
Message-Id: <20080521232919.70f47341.akpm@linux-foundation.org>
In-Reply-To: <48346BA3.2050806@googlemail.com>
References: <48346BA3.2050806@googlemail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 20:36:19 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:

> 
> These magic greps and hacks in ver_linux to get the gcc version always break after some gcc releases.
> 
> Since now gcc >4.3 allows compiling with '--with-pkgversion' ( which can be everything 'My Cool Gcc' or something )
> ver_linux will report random junk for these.

gcc sometimes looks like an anti-Linux plot.

> Simply use 'gcc -dumpversion' to get the gcc version which should always work.
> 
> Signed-off-by: Gabriel C <nix.or.die@googlemail.com>
> ---
> 
> Andrew sorry to bug you about that but
> I have no clue how is maintaining scripts/*

Depends on the script, really.  Most of them are Sam stuff.

>  scripts/ver_linux |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/ver_linux b/scripts/ver_linux
> index ab69ece..7ac0e30 100755
> --- a/scripts/ver_linux
> +++ b/scripts/ver_linux
> @@ -12,12 +12,9 @@ echo ' '
>  uname -a
>  echo ' '
>  
> -gcc --version 2>&1| head -n 1 | grep -v gcc | awk \
> +gcc -dumpversion 2>&1| awk \
>  'NR==1{print "Gnu C                 ", $1}'
>  
> -gcc --version 2>&1| grep gcc | awk \
> -'NR==1{print "Gnu C                 ", $3}'
> -
>  make --version 2>&1 | awk -F, '{print $1}' | awk \
>        '/GNU Make/{print "Gnu make              ",$NF}'

including this one, I believe.
