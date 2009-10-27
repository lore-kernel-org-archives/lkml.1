Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbZJ0UZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbZJ0UZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932228AbZJ0UZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:25:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbZJ0UZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:25:27 -0400
Subject: Re: [PATCH 7/9] tracing: recordmcount.pl Combine the condition
 validation in update_funcs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091027070322.GG22032@uhli>
References: <20091027065421.GA22032@uhli>  <20091027070322.GG22032@uhli>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 16:22:56 -0400
Message-Id: <1256674976.26028.440.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 15:03 +0800, Li Hong wrote:
> >From d0aa9b99e4ffd13fada96bfe1651055b459e9988 Mon Sep 17 00:00:00 2001
> From: Li Hong <lihong.hi@gmail.com>
> Date: Tue, 27 Oct 2009 13:20:48 +0800
> Subject: [PATCH] tracing: recordmcount.pl Combine the condition validation in update_funcs
> 
> Move all the condition validation into function update_funcs. Also
> update_funcs shouldn't die if $ref_func is undefined for there may be
> more than one valid sections in an object file.
> 

Nice clean up!

-- Steve

> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index d750da8..490b4cd 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -350,9 +350,7 @@ my $offset = 0;		# offset of ref_func to section beginning
>  #
>  sub update_funcs
>  {
> -    return if ($#offsets < 0);
> -
> -    defined($ref_func) || die "No function to reference";
> +    return unless ($ref_func and @offsets);
>  
>      # A section only had a weak function, to represent it.
>      # Unfortunately, a weak function may be overwritten by another
> @@ -426,7 +424,7 @@ while (<IN>) {
>  	    $read_function = 0;
>  	}
>  	# print out any recorded offsets
> -	update_funcs() if (defined($ref_func));
> +	update_funcs();
>  
>  	# reset all markers and arrays
>  	$text_found = 0;
> @@ -463,7 +461,7 @@ while (<IN>) {
>  }
>  
>  # dump out anymore offsets that may have been found
> -update_funcs() if (defined($ref_func));
> +update_funcs();
>  
>  # If we did not find any mcount callers, we are done (do nothing).
>  if (!$opened) {

