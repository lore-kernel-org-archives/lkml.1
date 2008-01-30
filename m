Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbYA3I4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbYA3I4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbYA3IxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:53:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52432 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758044AbYA3IxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:53:05 -0500
Date: Wed, 30 Jan 2008 19:52:20 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Theodore Tso <tytso@MIT.EDU>
cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 update
In-Reply-To: <20080130071123.GF21944@mit.edu>
Message-ID: <alpine.LFD.1.00.0801301947540.3426@www.l.google.com>
References: <E1JJjMo-00011j-EU@closure.thunk.org> <20080129125307.GF6774@mit.edu> <Pine.LNX.4.64.0801292250110.14907@fbirervta.pbzchgretzou.qr> <20080130071123.GF21944@mit.edu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jan 2008, Theodore Tso wrote:
> 
> That's because you are doing a diff stat of changes that haven't been
> checked in yet.  I was doing a "git log -p origin.. | diffstat -p1",
> and in that incantation you definitely do need the -p1 to diffstat.

You should *always* use "-p1" to diffstat, because if you don't, diffstat 
just makes up the paths totally (the same way you should always use "-p1" 
to GNU 'patch').

The fact is, diffstat just guesses, based on the prefix. But those guesses 
will be totally bogus at times, especially if you have newly created files 
(I _think_ that is because one of the pathnames in the diff is /dev/null, 
and that will apparently throw off the guesses).

So if you don't use an explicit "-p1", diffstat will guess the -p level 
from the longest common path prefix, _but_ get that wrong for some paths 
anyway, so sometimes you'll see the "a/" prefix etc.

Of course, rather than using diffstat at all, just do something like

	git diff --stat origin..

instead.

		Linus
