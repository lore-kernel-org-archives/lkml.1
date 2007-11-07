Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbXKGELP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbXKGELP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 23:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbXKGELA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 23:11:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887AbXKGEK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 23:10:59 -0500
Date: Tue, 6 Nov 2007 20:09:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
In-Reply-To: <20071107015912.GT26163@stusta.de>
Message-ID: <alpine.LFD.0.999.0711061959250.15101@woody.linux-foundation.org>
References: <20071105094007.GA19367@ubuntu>
 <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
 <20071106080637.GB26163@stusta.de> <alpine.LFD.0.999.0711060738270.15101@woody.linux-foundation.org>
 <20071106230044.GO26163@stusta.de> <alpine.LFD.0.999.0711061506550.15101@woody.linux-foundation.org>
 <20071107000705.GQ26163@stusta.de> <alpine.LFD.0.999.0711061626410.15101@woody.linux-foundation.org>
 <20071107004350.GS26163@stusta.de> <alpine.LFD.0.999.0711061705340.15101@woody.linux-foundation.org>
 <20071107015912.GT26163@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Nov 2007, Adrian Bunk wrote:
> 
> Users are used to work on characters, not on bytes.

Adrian, stop this idiocy. I'm not interested in listening to your 
soliloqui about irrelevant stuff.

The kernel works on bytes. Deal with it. Stop whining. 

You've been told several times that all the examples you showed were 
irrelevant, and tomoyo worked on bytes too. 

You have been told several times that the VFS layer works on bytes, and 
has done so since day 1.

You have *also* been told that there is no real other option ("you can 
work with bytes, or you can go mad"). The normal kernel interfaces have to 
be locale-independent (parly because it doesn't even KNOW the locale, 
partly because locale is just totally irrelevant).

And your statement above is a TOTAL AND UTTER LIE.

More people are used to work with bytes (the C language calls them "char") 
than with what _you_ call "characters". The fact is, people are very very 
very used to working with 8-bit bytes, and there are a lot more people who 
understand them than people who understand UTF-8 (never mind any of the 
other million possible stupid and insane locales).

So can you stop your inane whining now? You can either:

 - accept that the kernel works on bytes (*) and that when we talk about 
   parsing strings, we're talking the very _traditional_ C meaning, which 
   is locale-independent, because locales DO NOT WORK in the kernel!

 - or you can continue your irrelevant ranting that has nothing to do with 
   anything, but please don't cc me any more. People already pointed out 
   to you that your assumption that "character" means something else than 
   "byte" was wrong.

Please stop this. The absolute *last* thing you want is a kernel that 
cares about locales. You *also* don't want a kernel that enforces some 
idiotic UTF-8 rules, since not everybody is using UTF-8. That way lies 
madness, not to mention totally unnecessary complexity.

		Linus

(*) With some *very* rare special cases, notably in the console driver, 
and for filesystems that are forced by idiot designers to be compatible 
with crap like OS X and Windows that think that filesystems should be 
case-insensitive, which is a fundamental problem exactly because of its 
dependence on locales)

