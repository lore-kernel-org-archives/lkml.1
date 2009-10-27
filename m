Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZJ0UTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZJ0UTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbZJ0UTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:19:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37882 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbZJ0UTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:19:52 -0400
Subject: Re: [PATCH 3/9] tracing: recordmcount.pl Support absolute path
 check on $inputfile
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091027065858.GC22032@uhli>
References: <20091027065421.GA22032@uhli>  <20091027065858.GC22032@uhli>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 16:12:49 -0400
Message-Id: <1256674369.26028.433.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 14:58 +0800, Li Hong wrote:
> >From fdf89709ddf4a6ff2f2d21ff8a964e949a069fe4 Mon Sep 17 00:00:00 2001
> From: Li Hong <lihong.hi@gmail.com>
> Date: Tue, 27 Oct 2009 12:32:18 +0800
> Subject: [PATCH] tracing: recordmcount.pl Support absolute path check on $inputfile
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 0850b83..94daf9e 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -122,9 +122,7 @@ my ($arch, $bits, $objdump, $objcopy, $cc,
>      $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
>  
>  # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
> -if ($inputfile eq "kernel/trace/ftrace.o") {
> -    exit(0);
> -}
> +exit (0) if ($inputfile =~ "kernel/trace/ftrace.o");

I prefer to keep the C like notation for error paths. Less to scare C
programers from perl the better.

Also, if you are using a regular expression to match, might as well do
it fully:

if ($inputfile =~ m,kernel/tracel/ftrace\.o$,) {
	exit(0);
}

-- Steve


