Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbXKEQV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbXKEQV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 11:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXKEQVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 11:21:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47905 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbXKEQVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 11:21:51 -0500
Date: Mon, 5 Nov 2007 08:21:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Pavel Machek <pavel@ucw.cz>, Casey Schaufler <casey@schaufler-ca.com>,
       akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
In-Reply-To: <20071105094007.GA19367@ubuntu>
Message-ID: <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
 <20071104122848.GC3921@ucw.cz> <20071105094007.GA19367@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Nov 2007, Ahmed S. Darwish wrote:

> On Sun, Nov 04, 2007 at 12:28:48PM +0000, Pavel Machek wrote:
> > 
> > Can we avoid string parsers in the kernel?
> > 
> 
> Ok, Could someone suggest a better idea please ?. 

I personally think string parsers are *much* better than the alternatives 
(which basically boil down to nasty binary interfaces)

> I thought about packing the rules in a structure and sending
> it over an ioctl() command. Is this applicable ?

That's *MUCH* worse.

Strings are nice. They aren't that complex, and as long as it's not a 
performance-critical area, there are basically no downsides.

Binary structures and ioctl's are *much* worse. They are totally 
undebuggable with generic tools (think "echo" or "strace"), and they are a 
total nightmare to parse across architectures and pointer sizes.

So the rule should be: always use strings if at all possible and relevant. 
If the data is fundamentally binary, it shouldn't be re-coded to ascii (no 
real advantage), but if the data is "stringish", and there aren't big 
performance issues, then keep it as strings.

			Linus
