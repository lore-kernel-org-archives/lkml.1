Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715Ab0AFNXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab0AFNXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 08:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202Ab0AFNXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 08:23:50 -0500
Received: from mga10.intel.com ([192.55.52.92]:62569 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754824Ab0AFNXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 08:23:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,226,1262592000"; 
   d="scan'208";a="761806165"
Message-ID: <4B448EE3.5060200@linux.intel.com>
Date: Wed, 06 Jan 2010 05:23:47 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Hui Zhu <teawater@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-15?Q?Ozan_=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix markup_oops.pl get error in x86
References: <daef60381001060123vbb09aecy7943d72fcb8278a@mail.gmail.com>
In-Reply-To: <daef60381001060123vbb09aecy7943d72fcb8278a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/6/2010 1:23, Hui Zhu wrote:
>   	}
> $func_offset will get a number like "0x2"
> But in follow code:
> my $decodestart = Math::BigInt->from_hex("0x$target") -
> Math::BigInt->from_hex("0x$func_offset");
> It add other ox to ox2.
> Then this value will be set to NaN.
>
> So I make a small patch to fix it.

> -	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
> +	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/[a-f0-9]/) {

I think this makes sense, but would you not also need to add "x" to the list of allowed characters?
so   [a-f0-9x]
?

