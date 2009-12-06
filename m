Return-Path: <linux-kernel-owner+w=401wt.eu-S934123AbZLFSxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123AbZLFSxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933978AbZLFSxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:53:43 -0500
Received: from poutre.nerim.net ([62.4.16.124]:58038 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757113AbZLFSxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:53:42 -0500
Date: Sun, 6 Dec 2009 19:53:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Andy Whitcroft <apw@canonical.com>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       William Allen Simpson <william.allen.simpson@gmail.com>
Subject: Re: [PATCH] scripts/checkpatch.pl: Add warning about leading 
 contination tests
Message-ID: <20091206195345.0c7d188a@hyperion.delvare>
In-Reply-To: <1260121576.11126.83.camel@Joe-Laptop.home>
References: <1260035884.11126.58.camel@Joe-Laptop.home>
	<4B1B6CB8.7000107@gmail.com>
	<20091206131324.55436006@hyperion.delvare>
	<1260121576.11126.83.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Dec 2009 09:46:16 -0800, Joe Perches wrote:
> On Sun, 2009-12-06 at 13:13 +0100, Jean Delvare wrote:
> > Not fine with me. Placing the binary logic operator at the beginning
> > of a line can be a deliberate choice, either to make complex binary
> > expressions more readable, or to avoid long lines. I don't see much
> > point in banning this style, which BTW is used over 8000 times in the
> > current kernel tree.
> 
> Anyone that thinks that checkpatch is the
> last word on linux coding style and all of
> its pronouncements must be followed all the
> time is simply wrong.
> 
> It's not a ban.  It's neither a command nor
> an edict.  It's a warning.  It's a notice
> that leading logical continuations are not
> the preferred style and it can be ignored
> at will.

I don't disagree with that. However, adding more and more checks in
checkpatch.pl has its downsides. For example, I want to be able to tell
people who submit patches to me: "run checkpatch.pl on your patch and
solve every problem it reports before sending it to me again". If I
must instead tell them: "run checkpatch.pl on your patch and fix what
you want" then they might as well not fix anything, because they will
not know which warnings _I_ find relevant and which I don't. Then the
checkpatch.pl script becomes useless for that use case.

More generally, if checkpatch.pl starts reporting too many warnings
which people consider false positives, then developers may simply stop
using it. This especially holds for newcomers. If they check their
patch and they get 10 errors or warnings, they'll fix them. If they get
100 they may just give up. checkpatch.pl is a wonderful tool and I
don't want to lose that.

So if you are going to add checks which are icing on the cake, please
disable them by default and only show them if the user explicitly asks
for it by passing --strict or some such. As a matter of fact, the rule
you are trying to add is not in Documentation/CodingStyle, as Eric
noticed already, so it can't be that important, can it?

> I think it's rather like the long line, >80
> column warning.  There are a whole lot more
> than 8k long lines in kernel source and no
> one is suggesting reformatting all of them
> out of existence.

Lines longer than 8_k_? I hope not ;)

-- 
Jean Delvare
