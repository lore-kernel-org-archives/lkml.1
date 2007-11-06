Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbXKFLei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbXKFLei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 06:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbXKFLea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 06:34:30 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:9850 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbXKFLe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 06:34:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=awo8ThpaCATPGI2fUwjc2F9hqXWEMnQfIPXy5OkI8bsiFSm1xr6sjCIAiStseu84fNC554Sfa8yHCZk7mH6b4llgEIbjvdLHTseoTlQlhri6VVu/soCDV/8J8VU0YODe1uo6gCS9OUp3qcsfjEIHRFsTVw/LcpeCsnGxBcViZh4=
Date: Tue, 6 Nov 2007 13:34:05 +0200
To: Adrian Bunk <bunk@kernel.org>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org,
       torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071106113359.GA6041@ubuntu>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu> <20071106063305.GA26163@stusta.de> <C1C917F8-57EA-434C-9FD8-CB5A4EAF2653@mac.com> <20071106085651.GC26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106085651.GC26163@stusta.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 06, 2007 at 09:56:51AM +0100, Adrian Bunk wrote:
> On Tue, Nov 06, 2007 at 03:26:12AM -0500, Kyle Moffett wrote:
> > On Nov 06, 2007, at 01:33:05, Adrian Bunk wrote:
> >> Can you limit this to 7bit ASCII and use isascii() somewhere?
> >>
> >> Otherwise I'd expect funny things to happen when you e.g. use isspace() on 
> >> the UTF-8 encoded character ??.
> >
> > Actually, you don't need to.  You tell them it expects UTF-8 encoded 
> > strings and be done with it.  All US-ASCII characters from 0 through 127 
> > (IE: high bit clear) are exactly the same in UTF-8, and UTF-8 special 
> > characters have the high bit set in all bytes.  Therefore you just assume 
> > that anything with the high bit set is part of a word and you can handle 
> > basic UTF-8.  (It doesn't work on special UTF-8 space characters like 
> > nonbreaking space and similar, but handling those is significantly more 
> > complicated).
> 
> The documentations says:
> "Smack labels cannot contain unprintable characters or the "/" (slash) 
>  character."
> 
> What you propose might contain unprintable characters, and it might even 
> be invalid UTF-8.
> 

As far as I understand the problem now, isspace() accepts the 0xa0
character which might collide with some of UTF-8 encoded characters
cause the high bit is set.

I used "if (!isspace(c) && !isgraph(c)) return -EINVAL;" to test 
rules' characters validity which seems not enough. I'll add !isascii(c)
in the condition and ask Casey to change the documentation to be
something like:

Smack labels are represented in ASCII characters, they cannot contain
unprintable characters or the '/' (slash) character.

and in write():
if (!isascii(c) return -EINVAL;
if (!isspace(c) && !isgraph(c)) return -EINVAL;

This satisfy above customized labels rule, right ?

Regards,

--
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
