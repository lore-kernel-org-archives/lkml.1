Return-Path: <linux-kernel-owner+w=401wt.eu-S1764751AbYJJXCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764751AbYJJXCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 19:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYJJXC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 19:02:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659AbYJJXC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 19:02:27 -0400
Date: Fri, 10 Oct 2008 16:01:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ashutosh Naik" <ashutosh@chelsio.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, rusty@rustcorp.com.au,
       kxie@chelsio.com, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Prevent modpost from looking for a .cmd file for a
 static library linked into a module
Message-Id: <20081010160129.1159a2ef.akpm@linux-foundation.org>
In-Reply-To: <8A71B368A89016469F72CD08050AD334038D52CF@maui.asicdesigners.com>
References: <8A71B368A89016469F72CD08050AD334038D52CF@maui.asicdesigners.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008 11:26:15 -0700
"Ashutosh Naik" <ashutosh@chelsio.com> wrote:

> 
> This patch prevents modpost to look for a .cmd file when a module is
> linked with a static library
> 
> Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>

What is the reason for this change?

Presumably there is some user-observeable behaviour which it corrects? 
What is it, and under what circumstances does it occur?


> diff -ruN linux-2.6.26.5/scripts/mod/sumversion.c
> linux-2.6.26.5-mod/scripts/mod/sumversion.c
> --- linux-2.6.26.5/scripts/mod/sumversion.c	2008-09-08
> 10:40:20.000000000 -0700
> +++ linux-2.6.26.5-mod/scripts/mod/sumversion.c	2008-10-07
> 09:32:24.000000000 -0700
> @@ -290,6 +290,15 @@
>  	release_file(file, len);
>  	return 1;
>  }
> +/* Check whether the file is a static library or not */
> +static int is_static_library(const char *objfile)
> +{
> +	int len = strlen(objfile);
> +	if((objfile[len -2]=='.') && (objfile[len - 1]=='a'))
> +		return 1;
> +	else
> +		return 0;	
> +}
>  
>  /* We have dir/file.o.  Open dir/.file.o.cmd, look for deps_ line to
>   * figure out source file. */
> @@ -420,7 +429,7 @@
>  	while ((fname = strsep(&sources, " ")) != NULL) {
>  		if (!*fname)
>  			continue;
> -		if (!parse_source_files(fname, &md))
> +		if (!(is_static_library(fname)) &&
> !parse_source_files(fname, &md))
>  			goto release;
>  	}

The patch was wordwrapped.  I fixed that and queued it for sending to
Sam.  Please send me an updated, complete changelog, thanks.

