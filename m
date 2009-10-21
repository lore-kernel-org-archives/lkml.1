Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbZJUP0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbZJUP0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZJUP0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:26:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZJUP0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:26:48 -0400
Subject: Re: [PATCH -v4 6/9] tracing: add an endian argument to
 scripts/recordmcount.pl
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>, Wu Zhangjin <wuzj@lemote.com>
In-Reply-To: <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	 <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>
	 <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 21 Oct 2009 11:26:52 -0400
Message-Id: <1256138812.18347.3043.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 22:35 +0800, Wu Zhangjin wrote:
> MIPS architecture need this argument to handle big/little endian
> respectively.
> 
> Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
> ---
>  scripts/Makefile.build  |    1 +
>  scripts/recordmcount.pl |    6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 341b589..0b94d2f 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -207,6 +207,7 @@ endif
>  
>  ifdef CONFIG_FTRACE_MCOUNT_RECORD
>  cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
> +	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \

I thought I added this already??

/me goes and looks

Hmm, not there. Did a patch get lost?

Thanks,

-- Steve

>  	"$(if $(CONFIG_64BIT),64,32)" \
>  	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
>  	"$(if $(part-of-module),1,0)" "$(@)";
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 090d300..daee038 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -99,13 +99,13 @@ $P =~ s@.*/@@g;
>  
>  my $V = '0.1';
>  
> -if ($#ARGV < 7) {
> -	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
> +if ($#ARGV < 8) {
> +	print "usage: $P arch endian bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
>  	print "version: $V\n";
>  	exit(1);
>  }
>  
> -my ($arch, $bits, $objdump, $objcopy, $cc,
> +my ($arch, $endian, $bits, $objdump, $objcopy, $cc,
>      $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
>  
>  # This file refers to mcount and shouldn't be ftraced, so lets' ignore it

