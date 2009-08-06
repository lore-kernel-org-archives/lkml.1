Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZHFMB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZHFMB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZHFMB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:01:59 -0400
Received: from lider.uludag.org.tr ([193.140.100.216]:54298 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZHFMB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:01:58 -0400
Message-ID: <4A7AC6FD.6080600@pardus.org.tr>
Date: Thu, 06 Aug 2009 15:05:17 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.22 (X11/20071115)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix markup_oops to work with 32-bit userspace on a 64-bit
 kernel
References: <20090713141819.GG24310@parisc-linux.org>
In-Reply-To: <20090713141819.GG24310@parisc-linux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote On 13-07-2009 17:18:
> A 32-bit perl can't handle 64-bit addresses without using the BigInt package.
>
>  
> -my $decodestart = hex($target) - hex($func_offset);
> -my $decodestop = hex($target) + 8192;
> +my $decodestart = Math::BigInt->from_hex("0x$target") - Math::BigInt->from_hex("0x$func_offset");
> +my $decodestop = Math::BigInt->from_hex("0x$target") + 8192;
>  if ($target eq "0") {
>  	print "No oops found!\n";
>  	print "Usage: \n";
>   

$func_offset has already "0x" so this commit prepends another "0x"
causing decodestart to be NaN.

Regards,
Ozan
