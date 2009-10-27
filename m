Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbZJ0UZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbZJ0UZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932182AbZJ0UZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:25:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46726 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbZJ0UZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:25:29 -0400
Subject: Re: [PATCH 8/9] tracing: recordmcount.pl We won't use weak
 function as reference, remove the check
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091027070421.GH22032@uhli>
References: <20091027065421.GA22032@uhli>  <20091027070421.GH22032@uhli>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 16:25:25 -0400
Message-Id: <1256675125.26028.442.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 15:04 +0800, Li Hong wrote:
> >From 4433c78ca3c0319fd75d1fd6d64929fa101e38a4 Mon Sep 17 00:00:00 2001
> From: Li Hong <lihong.hi@gmail.com>
> Date: Tue, 27 Oct 2009 13:25:39 +0800
> Subject: [PATCH] tracing: recordmcount.pl We won't use weak function as reference, remove the check
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 490b4cd..867c24a 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -352,17 +352,6 @@ sub update_funcs
>  {
>      return unless ($ref_func and @offsets);
>  
> -    # A section only had a weak function, to represent it.
> -    # Unfortunately, a weak function may be overwritten by another
> -    # function of the same name, making all these offsets incorrect.
> -    # To be safe, we simply print a warning and bail.
> -    if (defined $weak{$ref_func}) {
> -	print STDERR
> -	    "$inputfile: WARNING: referencing weak function" .
> -	    " $ref_func for mcount\n";
> -	return;
> -    }
> -

I consider this a sanity check. It may be triggered if someone modifies
the rest of the script and somehow a weak function gets through. I'd
like to keep it. It does not hurt to have it. Maybe we should make it
"die" instead of just returning.

-- Steve

>      # is this function static? If so, note this fact.
>      if (defined $locals{$ref_func}) {
>  

