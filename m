Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbYBWFwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbYBWFwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 00:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYBWFwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 00:52:41 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:52448 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYBWFwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 00:52:40 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Sat, 23 Feb 2008 06:48:12 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Greg KH" <greg@kroah.com>, "Alexey Zaytsev" <zaytsev.a@protei.ru>,
       linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru> <20080222221233.GC9510@kroah.com> <f19298770802221445p21cedad5yd20864cfd3e36b3@mail.gmail.com>
In-Reply-To: <f19298770802221445p21cedad5yd20864cfd3e36b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802230648.12908.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008, Alexey Zaytsev wrote:
> Well, it looks like Michael is not the bcm43xx maintaner. I sent the
> patch to him,
> because it was his code that broke the driver, and I thought it would
> be easy for him to review my patch, as it touches his code.

See? I'm tired of this "how dare can you break my kernel!?" bullshit.
That's exactly the reason why I NACKed this patch.
I do _not_ understand the KConfig SELECT logic. And I do think almost
nobody does understand how that all works together.
In the past people came with similiar patches like yours that looked
obviously OK. They said sentences like "it is trivial to get the SELECT
logics right". But it turned out they were wrong and it introduced
other regressions that I was made responsible for.

SELECT is _extremely_ difficult to get right, as it completely ignores
dependencies. See all this FOOBAR_POSSIBLE select logic that we use
in SSB to get SELECT working correctly with dependencies.

So my solution for this particular breakage you are seeing here is
to wait for the bcm43xx removal, which will happen soon. That will
fix it and will have almost zero chance to introduce new bugs.

> Well, if you read my first email, that is exactly what I intended to
> do, but even if
> Michael would be able to fix the b43 driver to work with my hardware, the code
> will only show up in 2.6.25, leaving some 2.6.24 users with broken
> wifi. So I thought

Blah. The people with a bcm4311 revision 1 wireless card plus a bcm44xx ethernet card.
You can count those people on two fingers.

> it would be a good thing to add my simple fix that enabled the old driver to the
> -stable tree, so that we could have working wifi soon.
> 
> This is still my intension, I'll resend to the proper maintainters.

Ok thanks. We'll see if it really was a simple fix then.
If it turns out to break something you will get mail. :)
You can send this patch to a netdev maintainer or the wireless maintainer.
Maybe one of those will sign it off. Good luck.
