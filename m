Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYGaEUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYGaEUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 00:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbYGaEUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 00:20:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:49232 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbYGaEUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 00:20:32 -0400
Message-ID: <f73f7ab80807302120h44e17babp17fd876788dddc37@mail.gmail.com>
Date: Thu, 31 Jul 2008 00:20:31 -0400
From: "Kyle Moffett" <kyle@moffetthome.net>
To: davids@webmaster.com
Subject: Re: 463 kernel developers missing!
Cc: alan@lxorguk.ukuu.org.uk, "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKMEHLOJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080730233229.5ebe4465@lxorguk.ukuu.org.uk>
	 <MDEHLPKNGKAHNMBLJOLKMEHLOJAC.davids@webmaster.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

STOP!!!  This is seriously just getting silly...

If people *really* care about the privacy of information they placed
in publicly accessible databases via agreement with the DCO, then
there is a workaround:

Instead of a "mailmap" file, use a "mailhash" file like this:

[...lines...]
4db83f457ca750b3ed0bb7db2375cfd41846fb43 Kyle Moffett <kyle@moffetthome.net>
[...more lines...]


That SHA1 checksum is of the name-and-email you are mapping *from* and
the value on the right is the string to replace it with.  For all the
people who don't like their emails being displayed when somebody looks
at logs, you can just get your entries in that file changed to
"anonymous".  Then the people who want useful statistics will ignore
your commits and people who want to look at logs will just use the
newly-added --no-mailhash option to see the
"<jranodmuser@my-typod-domian.cmo>" that you happened to put in the
Signed-off-by.

Alternatively people could realize it's not worth it and just go write
real code or something.

PS.  Just to show how easy it was, I converted the mailmap file that
was sent out into the above mailhash file with a perl one-liner
(WARNING: probably linewrapped):

perl -MDigest::SHA1=sha1_hex -n -e 'chomp; s/\s+/ /g; s/^ //; s/ $//;
print sha1_hex($_)." $_\n";' <mailmap >mailhash

Once you have the mailhash file, to convert from a "Name <email>" to
the actual desired representation you can run:

value="Name <email>"
sha1="$(echo -n "${value}" | sha1sum - | awk '{print $1}')"
line="$(sed -ne "/^${sha1} /{ s/^${sha1} //; p }" mailhash | head -n 1)"

Cheers,
Kyle Moffett
