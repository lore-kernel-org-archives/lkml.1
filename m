Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbZJ0Uvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbZJ0Uvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932252AbZJ0Uvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:51:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42057 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248AbZJ0Uvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:51:43 -0400
Subject: Re: [PATCH 9/9] tracing: recordmcount.pl Remove the redundant code
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091027070540.GI22032@uhli>
References: <20091027065421.GA22032@uhli>  <20091027070540.GI22032@uhli>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 16:51:41 -0400
Message-Id: <1256676701.26028.465.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 15:05 +0800, Li Hong wrote:
> >From d0aa71d523b6315fd3ea0ee66fddb020a625856f Mon Sep 17 00:00:00 2001
> From: Li Hong <lihong.hi@gmail.com>
> Date: Tue, 27 Oct 2009 13:28:53 +0800
> Subject: [PATCH] tracing: recordmcount.pl Remove the redundant code
> 
> If an object file has some local symbols and objcopy doesn't support local
> reference, we have exited before the real work starts. So remove the redundant
> check in update_funcs.

Are you sure? Where does it exit? Even if I add patch 6, you can still
have a section that does not have any globals in it.

-- Steve

> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 867c24a..ff3a9eb 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -353,14 +353,7 @@ sub update_funcs
>      return unless ($ref_func and @offsets);
>  
>      # is this function static? If so, note this fact.
> -    if (defined $locals{$ref_func}) {
> -
> -	# only use locals if objcopy supports globalize-symbols
> -	if (!$can_use_local) {
> -	    return;
> -	}
> -	$convert{$ref_func} = 1;
> -    }
> +    $convert{$ref_func} = 1 if $locals{$ref_func}; 
>  
>      # Loop through all the mcount caller offsets and print a reference
>      # to the caller based from the ref_func.

