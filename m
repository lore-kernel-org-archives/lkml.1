Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXKGAHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXKGAHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 19:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbXKGAHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 19:07:30 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41752 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754263AbXKGAH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 19:07:29 -0500
Date: Wed, 7 Nov 2007 01:07:05 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071107000705.GQ26163@stusta.de>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu> <20071104122848.GC3921@ucw.cz> <20071105094007.GA19367@ubuntu> <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org> <20071106080637.GB26163@stusta.de> <alpine.LFD.0.999.0711060738270.15101@woody.linux-foundation.org> <20071106230044.GO26163@stusta.de> <alpine.LFD.0.999.0711061506550.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0711061506550.15101@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 03:08:08PM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 7 Nov 2007, Adrian Bunk wrote:
> > 
> > You were the one who suggested to _parse_ strings in the kernel.
> 
> So?
> 
> We do that for lots of things.
> 
> What do you think a filename is? And yes, we parse it. Things like '/' and 
> '.' and '..' have magic meaning.
> 
> You don't need to bring up idiotic things like character sets. You can see 
> it as a byte string. You're done with it.

We have the following properties in the character sets we handle:
- every ASCII character is encoded with the same byte as in ASCII
- if the eighth bit is 0, the byte can't be part of a multi-byte character
- no ASCII character can be encoded in a different way

This (plus most likely some other properties I've missed to mention) 
allows some parsing based on ASCII characters.

But if you want to match "one character" (like TOMOYO does) or want to 
check for printable characters except space (like Smack does) you must 
know whether the byte string 0xC3 0xA0 is the character à or a sequence 
of two characters with the second one being NBSP.

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

