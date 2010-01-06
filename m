Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493Ab0AFHRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab0AFHRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384Ab0AFHRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:17:14 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:50095 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0AFHRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:17:13 -0500
Message-ID: <4B443695.5090301@gmail.com>
Date: Wed, 06 Jan 2010 08:07:01 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: O_* bit numbers uniqueness check
References: <20100106065526.GB11368@localhost>
In-Reply-To: <20100106065526.GB11368@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 06 Jan 2010 08:07:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 06/01/2010 07:55, Wu Fengguang a écrit :
> The O_* bit numbers are defined in 20+ arch/*, and hence can silently
> overlap. Add a boot time check to ensure the uniqueness as suggested
> by David Miller.
> 
> CC: David Miller <davem@davemloft.net>
> CC: Stephen Rothwell <sfr@canb.auug.org.au>
> CC: Al Viro <viro@zeniv.linux.org.uk>
> CC: Christoph Hellwig <hch@infradead.org>
> CC: Eric Paris <eparis@redhat.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  {
> +	/* please add new bits here to ensure allocation uniqueness */
> +	BUG_ON(20 != hweight32(
> +		O_RDONLY	| O_WRONLY	| O_RDWR	|
> +		O_CREAT		| O_EXCL	| O_NOCTTY	|
> +		O_TRUNC		| O_APPEND	| O_NONBLOCK	|
> +		O_SYNC		| FASYNC	| O_DIRECT	|
> +		O_LARGEFILE	| O_DIRECTORY	| O_NOFOLLOW	|
> +		O_NOATIME	| O_CLOEXEC	| O_RANDOM	|
> +		FMODE_EXEC	| FMODE_NONOTIFY));
> +

I cannot test it, but given O_RDONLY is 0, are you sure 20 bits are actually set ?
