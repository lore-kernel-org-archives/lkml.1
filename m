Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbXKFPyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbXKFPyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 10:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXKFPxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 10:53:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752208AbXKFPxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 10:53:54 -0500
Date: Tue, 6 Nov 2007 07:53:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
In-Reply-To: <46B300CD-7A35-4E81-A0AE-EC2BB72016DD@mac.com>
Message-ID: <alpine.LFD.0.999.0711060742100.15101@woody.linux-foundation.org>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
 <20071106063305.GA26163@stusta.de> <C1C917F8-57EA-434C-9FD8-CB5A4EAF2653@mac.com>
 <20071106085651.GC26163@stusta.de> <20071106113359.GA6041@ubuntu>
 <20071106114738.GH26163@stusta.de> <1865922a0711060423ue81dbdct413b993e727f6f9@mail.gmail.com>
 <46B300CD-7A35-4E81-A0AE-EC2BB72016DD@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Nov 2007, Kyle Moffett wrote:
> 
> Personally I think that isspace() accepting character 0xA0 is a bug

I think I agree with you. As far as the kernel is concerned, "isspace()" 
should just accept the obvious spaces (hardspace, tab, newline), and 
*perhaps* the VT/FF kind of things.

You should realize that the kernel <ctype.h> thing is *ancient*. It's 
basically there from v0.01, and while the really original one (I just 
checked) had all the non-ascii characters not trigger anything, it was 
converted to be latin1 in the 2.1.x timeframe.

That's a *loong* time ago. Way before UTF-8 and other things were really 
common.

So we should probably just make all the upper 128 bytes go back to "don't 
trigger anything in ctype.h" - they'd not be spaces, but they'd not be 
control characters or anything else either.

			Linus
