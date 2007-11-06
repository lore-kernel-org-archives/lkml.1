Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbXKFI1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbXKFI1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbXKFI06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:26:58 -0500
Received: from smtpoutm.mac.com ([17.148.16.71]:50459 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbXKFI05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:26:57 -0500
In-Reply-To: <20071106063305.GA26163@stusta.de>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu> <20071106063305.GA26163@stusta.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <C1C917F8-57EA-434C-9FD8-CB5A4EAF2653@mac.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org,
       torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Date: Tue, 6 Nov 2007 03:26:12 -0500
To: Adrian Bunk <bunk@kernel.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 06, 2007, at 01:33:05, Adrian Bunk wrote:
> Can you limit this to 7bit ASCII and use isascii() somewhere?
>
> Otherwise I'd expect funny things to happen when you e.g. use  
> isspace() on the UTF-8 encoded character à.

Actually, you don't need to.  You tell them it expects UTF-8 encoded  
strings and be done with it.  All US-ASCII characters from 0 through  
127 (IE: high bit clear) are exactly the same in UTF-8, and UTF-8  
special characters have the high bit set in all bytes.  Therefore you  
just assume that anything with the high bit set is part of a word and  
you can handle basic UTF-8.  (It doesn't work on special UTF-8 space  
characters like nonbreaking space and similar, but handling those is  
significantly more complicated).

Cheers,
Kyle Moffett

