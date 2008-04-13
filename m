Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYDMSzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYDMSzk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYDMSzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:55:31 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:18748 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYDMSza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RtgT0znYOvqk3B40AmxY38irZt8NUeelWGtUEQvUV63zZ3FeVG/ubY61aF+dRwvY6I65jSfAW4pj28JahCPAq5jFJB4yzPlvSjh6Jfb9qzVocAvFbNdFhHrEaDwNd8uVPTApxVPH5oFWnd98Znkc9R0ICUsAXX9oiAWzeJde/tI=
Message-ID: <9a8748490804131155g3df93ba7s9c2131a957391ee3@mail.gmail.com>
Date: Sun, 13 Apr 2008 20:55:21 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] mfd/sm501.c: #if 0 unused functions
Cc: "Ben Dooks" <ben@simtec.co.uk>, "Vincent Sanders" <vince@simtec.co.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080413181531.GD2182@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080413181531.GD2182@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/04/2008, Adrian Bunk <bunk@kernel.org> wrote:
> This patch #if 0's the following unused functions:
>  - sm501_find_clock()
>  - sm501_gpio_get()
>  - sm501_gpio_set()
>

Hi Adrian,

I know we've discussed this before, but I have to comment on this once more.

Why is it that you seem to prefer adding '#if 0' around blocks of
unused code instead of removing it outright?

Last time we discussed this your argument went something along the
lines of "it'll be used again soon, so we can reinstate it then". As I
recall I commented on that but never got a reply, so I'll try again.

My position is;
A) If the code is unused and will never be used again in the future,
we should just remove it outright.
B) If the code is currently unused but will be used soon (definition
of 'soon' left as an exercise for the reader), then we should either
a) remove the code now and reinstate it later along with the code that
uses it, or b) just leave it alone so we don't have pointless churn of
two patches, one that just comments out the code and then later
another that just uncomments it.
C) If the code is currently unused and may or may not be used in the
future, do the same as in 'B'.

We currently have over two thousand instances of code inside '#if 0'
blocks in the source tree

juhl@dragon:~/kernel/linux-2.6$ pwd
/home/juhl/kernel/linux-2.6
juhl@dragon:~/kernel/linux-2.6$ egrep -R "^ *# *if +0" . | wc -l
2168

A lot of that code is years old and should never have been commented
out, it should just have been removed. We are just leaving a lot of
junk around this way that we'll never get around to cleaning out.
Janitors will be afraid to remove it since "it might be needed soon
and we can't tell" and maintainers seem reluctant to submit cleanup
patches of their own to remove it (for reasons I won't pretend to
know), so the unused code just sits there and rots.

When I removed some unused code from floppy.c a while back, one of the
blocks I removed was within '#if 0' and had been that way for years -
it should just have been removed back then instead of being commented
out.

So why exactly is it you (and others) keep doing this?


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
