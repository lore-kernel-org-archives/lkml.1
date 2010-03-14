Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab0CNQ4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 12:56:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33725 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624Ab0CNQ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 12:56:13 -0400
X-Authority-Analysis: v=1.0 c=1 a=o9jgRAe6v1AA:10 a=IkcTkHD0fZMA:10 a=IRaZ24leWvIJTbl_QnIA:9 a=q2nghwuwuxMpq6iUHE9alzRhEGoA:4 a=QEXdDO2ut3YA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 07/10] ftrace: pass KBUILD_CFLAGS to record_mcount.pl
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <1268462987-8271-8-git-send-email-rabin@rab.in>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
	 <1268462987-8271-8-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Mar 2010 12:56:11 -0400
Message-ID: <1268585771.13400.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-13 at 12:19 +0530, Rabin Vincent wrote:
> On ARM, we have two ABIs, and the ABI used is controlled via a config
> option.  Object files built with one ABI can't be merged with object
> files built with the other ABI.  So, record_mcount.pl needs to use the
> same compiler flags as the kernel when generating the object file with
> the mcount locations.  Ensure this by passing CFLAGS to the script.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  scripts/Makefile.build |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 0b94d2f..2535c11 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -209,7 +209,8 @@ ifdef CONFIG_FTRACE_MCOUNT_RECORD
>  cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
>  	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
>  	"$(if $(CONFIG_64BIT),64,32)" \
> -	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> +	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
> +	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \

Again, I'll have to test this on other archs, just to make sure its does
not cause any side effects. Oh, I forgot I now have a MIPS board I can
test on too. I'll probably do this on Monday.

Thanks,

-- Steve

>  	"$(if $(part-of-module),1,0)" "$(@)";
>  endif
>  



