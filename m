Return-Path: <linux-kernel-owner+w=401wt.eu-S1761242AbXKAP0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242AbXKAP0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbXKAP0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:26:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62620 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbXKAP0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:26:40 -0400
Date: Thu, 1 Nov 2007 08:24:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] eradicate bashisms in scripts/patch-kernel
Message-Id: <20071101082457.ff9a5d67.randy.dunlap@oracle.com>
In-Reply-To: <20071101121133.GA14807@rhlx01.hs-esslingen.de>
References: <20071031211321.GA8363@rhlx01.hs-esslingen.de>
	<47290096.7080207@oracle.com>
	<20071101121133.GA14807@rhlx01.hs-esslingen.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 13:11:33 +0100 Andreas Mohr wrote:

> On Wed, Oct 31, 2007 at 03:24:22PM -0700, Randy Dunlap wrote:
> > Andreas Mohr wrote:
> > >- the "source" statement most likely needs the ./ prepended, as can be
> > >gathered from e.g. http://osdir.com/ml/colinux.devel/2005-12/msg00036.html
> > 
> > That email isn't very convincing to me.
> 
> Actually that place simply was where I found how the
> 
> .: 188: .tmpver.eC4856.1: not found
> 
> dash error that happened when I replaced the bash-specific "source"
> statement with its "." counterpart could be ""fixed"".
> 
> > http://www.opengroup.org/onlinepubs/009695399/utilities/dot.html just says 
> > that
> > if <filename> does not contain a slash, the search PATH shall be used 
> > (searched).
> > If you want to prevent that, it's OK to use ./, but at least say that in the
> > patch description, please.
> 
> So this part seems to indicate that merely prepending ./ is problematic,
> since ./ implies relative path resolution whereas $TMPFILE.1 could
> theoretically be an absolute path already.
> It would probably be best to add the ./ to mktemp already, to make sure
> we source *exactly* the filename expression we originally mktemp'd.
> 
> OTOH prepending ./ to mktemp by default would deny mktemp any
> "search for a temporary-capable directory and create the file there"
> capabilities. Hmm. I should investigate POSIX shell sourcing
> mechanisms more.

As I indicated, I don't object to this part of the patch or to
the s/==/=/ part either.  The ./ just needs better patch description.


> > >@@ -202,13 +202,7 @@
> > > EXTRAVER=
> > > if [ x$EXTRAVERSION != "x" ]
> > > then
> > >-	if [ ${EXTRAVERSION:0:1} == "." ]; then
> > >-		EXTRAVER=${EXTRAVERSION:1}
> > >-	else
> > >-		EXTRAVER=$EXTRAVERSION
> > >-	fi
> > >-	EXTRAVER=${EXTRAVER%%[[:punct:]]*}
> > >-	#echo "$PNAME: changing EXTRAVERSION from $EXTRAVERSION to $EXTRAVER"
> > 
> > What's the problem above?
> 
> The variable manipulation seems bash-specific, the resulting dash error was:
> 
> linux-2.6.23/scripts/patch-kernel: 205: Syntax error: Bad substitution
> 
> which pointed at the
> 
> 	if [ ${EXTRAVERSION:0:1} == "." ]; then
> 
> line.
> 
> > > 
> > >-    SUBLEVEL=$((SUBLEVEL + 1))
> > >+    SUBLEVEL=$(( $SUBLEVEL + 1 ))
> > 
> > Why are the added spaces needed?
> 
> They weren't strictly needed, what was needed was to add the missing $ sign
> (you could perhaps say that I added the spaces to emphasize the $ sign).
> Maybe they're best removed.
> 
> > Did you look at
> > http://www.opengroup.org/onlinepubs/000095399/utilities/xcu_chap02.html ?
> 
> No. I should have started by looking at the opengroup.org site when
> looking for POSIX specs...
> 
> > 
> > >     FULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
> > >     #echo "#___ trying $FULLVERSION ___"
> > > 
> > >-    if [ $((SUBLEVEL)) -gt $((STOPSUBLEVEL)) ]; then
> > >+    if [ $SUBLEVEL -gt $STOPSUBLEVEL ]; then
> > 
> > What's the problem here?
> 
> I got 
> 
> linux-2.6.23/scripts/patch-kernel: 270: arith: syntax error: "SUBLEVEL"
> 
> thus I simply removed braces since that "fixed" the issue.
> May be incorrect, though...
> 
> 
> I'll think a bit more about these couple changed places (and whether
> this still truly works as intended) and mail a patch then.
> 
> (and a big NOTE: I'm no POSIX vs. non-POSIX shell guru at all, only a
> semi-versed shell script writer, thus these changes should be reviewed
> quite thoroughly)

Neither am I.  I read those web pages quickly yesterday, so after
you read them, we can discuss more and/or review more patches.

Thanks.

---
~Randy
