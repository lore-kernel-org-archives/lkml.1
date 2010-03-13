Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934890Ab0CMRnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 12:43:05 -0500
Received: from cpe-74-67-89-75.stny.res.rr.com ([74.67.89.75]:39475 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933453Ab0CMRnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 12:43:01 -0500
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
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Mar 2010 12:42:42 -0500
Message-ID: <1268502162.3366.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
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

