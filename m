Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZJZR1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZJZR1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZJZR1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:27:42 -0400
Received: from mail.perches.com ([173.55.12.10]:1052 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbZJZR1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:27:41 -0400
Subject: Re: [RFC] scripts/get_maintainer.pl: also find maintainers from
 Mercurial (hg log)
From: Joe Perches <joe@perches.com>
To: Marti Raudsepp <marti@juffo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1256573044.7754.20.camel@localhost>
References: <1256573044.7754.20.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 10:27:44 -0700
Message-ID: <1256578064.1865.96.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 18:04 +0200, Marti Raudsepp wrote:
> Hi!

Hi Marti.

> Given that there are official hg repositories available from kernel.org,
> Mercurial seems to be an acceptable alternative to git.
> Does this patch have any chance?

The idea is fine by me.

Here are a couple of things to consider:

There are a few outstanding patches to get_maintainer
so this doesn't apply to latest, but it's not problem
to fix it up.

What about using hg annotate for the git blame?
	hg annotate -c $file
and
	hg annotate --template="{desc}\n" -r $rev

Is there an hg annotate select line range capability?

I'm not a user of hg. I did:
	hg clone http://www.kernel.org/hg/linux-2.6/
and
	hg annotate -c -l README
and the output line numbering style isn't clear to me.

Maybe it's better not to introduce more arguments.

Would it be acceptable to use --git instead of --hg
and just execute hg if .git wasn't available but .hg
was?  Basically just consider --git the equivalent of
--vcs and execute whatever vcs system was supported?

Or maybe just add --vcs instead of --hg so that
the perforce/cvs/svn/darcs/VisualSourceSafe/etc users
could be happy in the future too...

What do you think?

cheers, Joe

