Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYGKPDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYGKPDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYGKPDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:03:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59002 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbYGKPDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:03:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Fix try_to_freeze_tasks()'s use of do_div()
Date: Fri, 11 Jul 2008 17:05:49 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: akpm@linux-foundation.org, pavel@ucw.cz, linux-kernel@vger.kernel.org
References: <20080711132146.31912.76254.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080711132146.31912.76254.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111705.49840.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 of July 2008, David Howells wrote:
> Fix try_to_freeze_tasks()'s use of do_div() on an s64 by making elapsed_csecs64
> a u64 instead and dividing that.
> 
> Possibly this should be guarded lest the interval calculation turn up negative,
> but the possible negativity of the result of the division is cast away anyway.
> 
> This was introduced by patch 438e2ce68dfd4af4cfcec2f873564fb921db4bb5.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
> 
>  kernel/power/process.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 5fb8765..278946a 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -149,7 +149,7 @@ static int try_to_freeze_tasks(bool sig_only)
>  	unsigned long end_time;
>  	unsigned int todo;
>  	struct timeval start, end;
> -	s64 elapsed_csecs64;
> +	u64 elapsed_csecs64;
>  	unsigned int elapsed_csecs;
>  
>  	do_gettimeofday(&start);
> 
> 
> 


