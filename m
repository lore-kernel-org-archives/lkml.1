Return-Path: <linux-kernel-owner+w=401wt.eu-S938901AbXHNBzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938901AbXHNBzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 21:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758437AbXHNBzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 21:55:37 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:40311 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbXHNBzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 21:55:35 -0400
Message-ID: <46C10AA8.3090505@gmail.com>
Date: Tue, 14 Aug 2007 03:51:36 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -	scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost>	 <200708131933.10125.m.kozlowski@tuxland.pl>	 <1187026955.2688.4.camel@laptopd505.fenrus.org>	 <1187037445.6628.98.camel@heimdal.trondhjem.org> <1187054366.2757.0.camel@laptopd505.fenrus.org>
In-Reply-To: <1187054366.2757.0.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2007 03:19 AM, Arjan van de Ven wrote:

> On Mon, 2007-08-13 at 16:37 -0400, Trond Myklebust wrote:
>> On Mon, 2007-08-13 at 10:42 -0700, Arjan van de Ven wrote:

>>> The maintainer info should be in the source file itself! That's the only
>>> reasonable way to keep it updated; now I'm all for having it machine
>>> parsable so that tools can use it, but it still really should be in the
>>> code itself, not in some central file that will always just go out of
>>> data, and will be a huge source of needless patch conflicts.
>> 
>> If the problem is to do with people failing to update the MAINTAINERS 
>> file, why would moving the same data into 20 or 30 source files
>> motivate them to keep it up to date? As far as I can see, that would
>> just serve to multiply the amount of stale data...
> 
> if each .c file has a MODULE_MAINTAINER() tag... 
> 
> people tend to update .c files a lot better than way off-the-side other
> files.

MODULE_MAINTAINER() was discussed a while ago but embedding information into 
the binary has the problem you can't ever change deployed systems, meaning 
it lags by design. If a maintainer changes, people would still be using the 
information from their old binaries, meaning a replaced maintainer might get 
contacted for potentially years still (and the new one not).

(you could avoid that by placing not a name/address in the maintainer tag 
but a pointer to somewhere else but at that point this gets to be about 
solving something else).

Keeping it in the source alone is fine. C files could just embed their 
MAINTAINERS entry as a header:

/*
  * P: Maintainer
  * M: Mail patches to
  * L: Mailing list that is relevant to this area
  * W: Web-page with status/info
  * T: SCM tree type and location.  Type is one of: git, hg, quilt.
  * S: Status, one of the following:
  */

And probably adding fields:

  * I: Info/Summary (for index files and the like)
  * A: Author
  * G: License

and such. Yes, while we're at it, we can pick better letters or full word 
tags ;-)

Rene.

