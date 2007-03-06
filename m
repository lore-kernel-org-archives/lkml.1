Return-Path: <linux-kernel-owner+w=401wt.eu-S966015AbXCFSmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966015AbXCFSmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966001AbXCFSlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:41:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51748 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966010AbXCFSln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:41:43 -0500
Date: Tue, 6 Mar 2007 10:41:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order()
In-Reply-To: <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com>
Message-ID: <Pine.LNX.4.64.0703061040260.5963@woody.linux-foundation.org>
References: <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2007, David Howells wrote:
> @@ -159,8 +175,8 @@ unsigned long __roundup_pow_of_two(unsigned long n)
>  #define roundup_pow_of_two(n)			\
>  (						\
>  	__builtin_constant_p(n) ? (		\
> -		(n == 1) ? 0 :			\
> -		(1UL << (ilog2((n) - 1) + 1))	\
> +		(n == 1) ? 1 :			\
> +		(1UL << ilog2_up(n))		\
>  				   ) :		\
>  	__roundup_pow_of_two(n)			\

That seems bogus. "n == 1" should give "0", no?

		Linus
