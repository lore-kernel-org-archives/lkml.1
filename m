Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbXFDQ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbXFDQ2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbXFDQ2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:28:24 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:49788 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbXFDQ2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:28:23 -0400
Date: Mon, 4 Jun 2007 18:25:37 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
In-Reply-To: <0a25fd03117c678f17006c5fcefaaed0@pinky>
Message-ID: <Pine.LNX.4.61.0706041812150.20829@yvahk01.tjqt.qr>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 4 2007 10:46, Andy Whitcroft wrote:
>
>  - catch use of volatile

Speaking of volatile, "register" is probably just as unwanted.
Then, "extern inline" is one thing to catch (does not happen
that often, but it does not cost too much either).

>  - warn about #ifdef's in c files

Really? There are a lot of ifdefs in existing code, and it is
probably inevitable to add some in newer code ... overall
leading to more false positives and cluttering the output.
Or am I gone wrong somewhere?

>+
>+		} elsif (/^Funcs:\s+(.*\S)/) {
>+			for my $func (split(/[, ]+/, $1)) {
>+				push(@dep_functions, $func);
>+			}

for -> foreach, although it does not functionally change anything.
Yeah, Perl is funny, for(one arg) is actually foreach().
Quite confusing to for(three args).

>+sub line_stats {
                ^ = \n ?

>+		last if (scalar(@o) == scalar(@c));

Or last if $#o == $#c. Again, personal taste (=do it your way).
I do not think $#a is any cheaper than scalar(@a) anyway.

>+sub has_non_quoted {
>+	return ($_[0] =~ m{$_[1]} and $_[0] !~ m{\".*$_[1].*\"});
>+}

Safe? Or intended? Did you want to allow regexes?
Otherwise...

	return $_[0] =~ /\Q$_[1]\E/ && $_[0] !~ /".*\Q$_[1]\E.*"/;

> 			if (!($line =~ /^\s*Signed-off-by:/)) {
                            ^       ^^
 => if($line !~ /.../)
Gotta love perl. Perhaps one language where you'll always find a
way to circumvent any CodingStyle ever written :p

> #80 column limit
>-		if (!($prevline=~/\/\*\*/) && length($lineforcounting) > 80) {
>+		if (!($prevline=~/\/\*\*/) && $length > 80) {

I say thee 79. But we had that more or less already.

>+			for my $ctx (@ctx) {

>-			while ($remaining > 0 && scalar @opened > scalar @closed) {
>+			while ($remaining > 1 && scalar @opened > scalar @closed) {

Although scalar might bind as hard as sizeof in C, I suggest parentheses.
(Or $#)

	while ($remaining > 1 && scalar(@opened) > scalar(@closed))

>+# warn about #ifdefs in C files
>+		if ($line =~ /^.#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {

save a capture operation:	/^.#\s*ifn?def/



	Jan
-- 
