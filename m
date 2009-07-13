Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZGMPGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZGMPGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbZGMPGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:06:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:35077 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbZGMPGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:06:51 -0400
Date: Mon, 13 Jul 2009 08:08:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix markup_oops to work with 32-bit userspace on a
 64-bit kernel
Message-ID: <20090713080822.60e3eb3a@infradead.org>
In-Reply-To: <20090713141819.GG24310@parisc-linux.org>
References: <20090713141819.GG24310@parisc-linux.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 08:18:19 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> 
> A 32-bit perl can't handle 64-bit addresses without using the BigInt
> package.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

looks sane enuogh to me


Acked-by: Arjan van de Ven <arjan@linux.intel.com>


Andrew, can you pull this into -mm patch-logistics wise please?


> 
> diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
> index 528492b..8977401 100644
> --- a/scripts/markup_oops.pl
> +++ b/scripts/markup_oops.pl
> @@ -1,6 +1,7 @@
>  #!/usr/bin/perl
>  
>  use File::Basename;
> +use Math::BigInt;
>  
>  # Copyright 2008, Intel Corporation
>  #
> @@ -172,8 +173,8 @@ while (<STDIN>) {
>  	parse_x86_regs($line);
>  }
>  
> -my $decodestart = hex($target) - hex($func_offset);
> -my $decodestop = hex($target) + 8192;
> +my $decodestart = Math::BigInt->from_hex("0x$target") -
> Math::BigInt->from_hex("0x$func_offset"); +my $decodestop =
> Math::BigInt->from_hex("0x$target") + 8192; if ($target eq "0") {
>  	print "No oops found!\n";
>  	print "Usage: \n";
> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
