Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbXFXTJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbXFXTJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXFXTJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:09:47 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:55297 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbXFXTJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:09:46 -0400
In-Reply-To: <20070624184449.GB21478@ftp.linux.org.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <b739fb9ad6e68bfe5d2a4b839abc8ea4@kernel.crashing.org> <20070624184449.GB21478@ftp.linux.org.uk>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <c18a28cc8094adeac7ff98652609a8cb@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Date: Sun, 24 Jun 2007 21:09:28 +0200
To: Al Viro <viro@ftp.linux.org.uk>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> If I understand correctly what bugs you are talking about,
>> most (all?) of those were solved in the dark ages already
>> (i.e., the 3.x series).
>
> Alas, no.  gcc is amazingly (and inconsistently) sloppy about the
> things it accepts as integer constant expressions.

Ah yes, now I see what you were talking about.  Most of this
is well-known, but feel free to file more PRs :-)

>>> It certainly is not a valid C
>>
>> Why not?  Nothing in the C standard says all your externs
>> have to be defined in some other translation unit you link
>> with AFAIK.
>
> It's not about externs.  It's about things like
>
> unsigned n;
> int a[] = {[n - n + n - n] = 1};
>
> And yes, gcc does eat that.

Yeah.

> With -pedantic -std=c99, at that.
> However,
>
> unsigned n;
> int a[] = {[n + n - n - n] = 1};
>
> gets you error: nonconstant array index in initializer
>
> And that's 4.1, not 3.x...

Why are you using such an ancient compiler? :-)
(Not that it is fixed in the current release though).


Segher

