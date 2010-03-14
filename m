Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0CNQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 12:56:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33929 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624Ab0CNQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 12:56:19 -0400
X-Authority-Analysis: v=1.0 c=1 a=p90UYjOZQT8A:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=GwQ5eddd2rYqzY1P88sA:9 a=uOb313ZhXQ1xEUwFBGYZLupgZAoA:4 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 08/10] ARM: ftrace: fix and update dynamic ftrace
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <1268462987-8271-9-git-send-email-rabin@rab.in>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
	 <1268462987-8271-9-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Mar 2010 12:56:16 -0400
Message-ID: <1268585776.13400.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-13 at 12:19 +0530, Rabin Vincent wrote:
> This adds mcount recording and updates dynamic ftrace for ARM to work
> with the new ftrace dyamic tracing implementation.  It also adds support
> for the mcount format used by newer ARM compilers.
> 
> With dynamic tracing, mcount() is implemented as a nop.  Callsites are
> patched on startup with nops, and dynamically patched to call to the
> ftrace_caller() routine as needed.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.i


> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index f3c9c0a..319af1e 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -268,6 +268,8 @@ if ($arch eq "x86_64") {
>  } elsif ($arch eq "arm") {
>      $alignment = 2;
>      $section_type = '%progbits';
> +    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_ARM_(CALL|PC24)" .
> +			"\\s+(__gnu_mcount_nc|mcount)\$";
>  
>  } elsif ($arch eq "ia64") {
>      $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve



