Return-Path: <linux-kernel-owner+w=401wt.eu-S1765833AbXHOBqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765833AbXHOBqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 21:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758154AbXHOBpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 21:45:55 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:35814 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763994AbXHOBpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 21:45:49 -0400
Message-ID: <46C2548D.80605@gmail.com>
Date: Wed, 15 Aug 2007 03:19:09 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Perches <joe@perches.com>, git@vger.kernel.org,
       Junio C Hamano <gitster@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
References: <1187026955.2688.4.camel@laptopd505.fenrus.org> <1187037445.6628.98.camel@heimdal.trondhjem.org> <1187054366.2757.0.camel@laptopd505.fenrus.org> <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu> <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost> <46C1EE6F.2080807@gmail.com> <1187116082.32555.122.camel@localhost> <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org> <20070814193333.GI21089@ftp.linux.org.uk>
In-Reply-To: <20070814193333.GI21089@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2007 09:33 PM, Al Viro wrote:

> FWIW, I suspect that we are looking at that from the wrong POV.  If
> that's about "who ought to be Cc'd on the issues dealing with <list
> of pathnames>", why does it have to be tied to "who is maintainer for
> <pathname>"?
> 
> I'm not suggesting something like fs.ext2@kernel.org with something
> like majordomo allowing to add yourself to those, but something less
> extreme in that direction might be worth thinking about...  Hell,
> even simple
> $ finger fs/minix/dir.c@cc.kernel.org
> with majordomo-like interface for adding yourself to such lists
> might solve most of those problems...

It mostly is just about that it seems. However, this would not also allow 
the other information currently in the MAINTAINERS file to be queried in 
similar ways.

Git could grow a generic file meta data implementation through the use of 
tags, sort of like tags on multimedia files although while with multimedia 
files the tags are in fact stored as a file header, here you'd keep them 
just in git. Any project using git would be free to define its own set of 
info tags and you'd supply them to git simply as a list of

<tag>=<value>

pairs:

$ git info --add drivers/ide/ide-cd.c <<EOF
CC="Alan Cox <alan@lxorguk.ukuu.org.uk>", linux-ide@vger.kernel.org
EOF

Or as a more expansive example, with the tags set on a directory (and the 
output shown this time):

$ git info drivers/infiniband/
CC="Roland Dreier <rolandd@cisco.com>"
CC="Sean Hefty <mshefty@ichips.intel.com>"
CC="Hal Rosenstock <halr@voltaire.com>"
CC=openib-general@openib.org
W=http://www.openib.org/
T=git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git

$ git info --type="W" drivers/infiniband/
http://www.openib.org/

The project can link the actual tags such as CC, W and T to --options for 
the "info" command in the git configuration file for the tree (and/or just 
define a few upfront I guess) making it look nicer:

$ git info --cc drivers/infiniband/
"Roland Dreier <rolandd@cisco.com>"
"Sean Hefty <mshefty@ichips.intel.com>"
"Hal Rosenstock <halr@voltaire.com>"
openib-general@openib.org

$ git info --website drivers/infiniband/
http://www.openib.org/

$ git info --tree drivers/infiniband/
git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git

Extra: when you have such an implementation, you can use it for other 
purposes as well such as the summary Documentation/ files want for the 
00-INDEX files:

$ git info --summary Documentation/BUG-HUNTING
brute force method of doing binary search of patches to find bug.

And importantly -- when queuried for a file that itself doesn't have the 
requested info tag:

$ git info --cc drivers/infiniband/core/addr.c

git looks for the tag on the drivers/infiniband/core/ directory next, and 
then on drivers/infiniband/, where it finds it. linux-kernel@vger.kernel.org 
would be the final fallback, being set on the project root.

I'd really like something like this. As long as projects are both free to 
use and not use them and free to define their own set of tags I believe this 
would work very nicely.

Once you have these tags, you can basically use them for anything.

Rene.

