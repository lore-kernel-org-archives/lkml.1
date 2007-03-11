Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbXCKVr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbXCKVr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 17:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932860AbXCKVr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 17:47:28 -0400
Received: from twin.jikos.cz ([213.151.79.26]:45135 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840AbXCKVr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 17:47:27 -0400
Date: Sun, 11 Mar 2007 22:47:17 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <45F4770F.4090902@gmail.com>
Message-ID: <Pine.LNX.4.64.0703112243560.26904@twin.jikos.cz>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> 
 <45E996A0.6070700@gmail.com> <45E99A45.9030506@gmail.com> 
 <20070303094125.838ce04d.akpm@linux-foundation.org>  <45F13791.8040408@gmail.com>
 <d120d5000703090613v2923e9c1k8389b566257daa43@mail.gmail.com>
 <Pine.LNX.4.64.0703091531280.26904@twin.jikos.cz>
 <Pine.LNX.4.64.0703091658350.26904@twin.jikos.cz> <45F4770F.4090902@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2007, Jiri Slaby wrote:

> > -	/* make sure the unused bits in the last byte are zeros */
> > -	if (count > 0 && size > 0)
> > -		data[(offset+count*size-1)/8] = 0;
> > -
> No, this doesn't help -- -rc3-mm2 minus this behaves exactly the same. 
> -rc3 without this patch too.
> Going to try to revert the commits mentioned above.

Hmm, strange, I did bet that this would have solved the problem, as the 
code is for sure bogus and could be causing these kinds of problems (I 
have already scheduled it for removal in the HID tree as an upstream fix) 
- it could zero out even the bits which are used and have been previously 
set.

I would think that reverting the two commits I have mentioned is not going 
to help, if this did not help, but it's always worth trying.

Otherwise, would you care to bisect?

What is the keyboard in question, please? (vendor/product ids).

Thanks,

-- 
Jiri Kosina
