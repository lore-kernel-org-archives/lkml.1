Return-Path: <linux-kernel-owner+w=401wt.eu-S938323AbXG3GMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938323AbXG3GMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 02:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932909AbXG3GL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 02:11:57 -0400
Received: from colo.lackof.org ([198.49.126.79]:48887 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932720AbXG3GL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 02:11:56 -0400
X-Greylist: delayed 1960 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 02:11:56 EDT
Date: Sun, 29 Jul 2007 23:39:09 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: kernel-janitors@vger.kernel.org, matthew@wil.cx, grundler@parisc-linux.org,
       kyle@parisc-linux.org, parisc-linux@parisc-linux.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/68] 0 -> NULL, for arch/parisc
Message-ID: <20070730053909.GF21206@colo.lackof.org>
References: <200707270945.LAA17250@ifs.emn.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707270945.LAA17250@ifs.emn.fr>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 11:45:05AM +0200, Yoann Padioleau wrote:
> 
> When comparing a pointer, it's clearer to compare it to NULL than to 0.
...
> diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
> index 04c7e1d..16fccbe 100644
> --- a/arch/parisc/kernel/smp.c
> +++ b/arch/parisc/kernel/smp.c
> @@ -333,7 +333,7 @@ smp_call_function (void (*func) (void *i
>  
>  	if (retry) {
>  		spin_lock (&lock);
> -		while (smp_call_function_data != 0)
> +		while (smp_call_function_data != NULL)
>  			barrier();
>  	}
>  	else {

Yoann,
Thanks!
I like comparing pointers to NULL since it makes it explicit we
are dealing with a pointer and is consistent with the assignment to NULL
later in the code.

But I'd like the later comparisons of smp_call_function_data to be
consistent with your suggestion above.
Patch below adds another "!= NULL".

thanks
grant

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>


diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 04c7e1d..c9ce659 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -333,12 +333,12 @@ smp_call_function (void (*func) (void *info), void *info, int retry, int wait)
 
 	if (retry) {
 		spin_lock (&lock);
-		while (smp_call_function_data != 0)
+		while (smp_call_function_data != NULL)
 			barrier();
 	}
 	else {
 		spin_lock (&lock);
-		if (smp_call_function_data) {
+		if (smp_call_function_data != NULL) {
 			spin_unlock (&lock);
 			return -EBUSY;
 		}
