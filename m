Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbXFDQI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbXFDQI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbXFDQIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:08:51 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35016 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbXFDQIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:08:50 -0400
Date: Mon, 4 Jun 2007 18:07:10 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: Re: [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long
 lines
In-Reply-To: <20070603204700.GH9240@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.61.0706041805560.20829@yvahk01.tjqt.qr>
References: <20070603204700.GH9240@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 3 2007 22:47, Sam Ravnborg wrote:
>
>Make the "cleanfile" and "cleanpatch" script warn about long lines,
>by default lines whose visual width exceeds 79 characters.

Nice, nice. But, am I asking too much if tabs and kernel codestyle
could be used? (/me hides..., but see scripts/checkpatch.pl :-)

>+# Compute the visual width of a string
>+sub strwidth($) {
>+    no bytes;			# Tab alignment depends on characters
>+
>+    my($li) = @_;
>+    my($c, $i);
>+    my $pos = 0;
>+    my $mlen = 0;
>+
>+    for ($i = 0; $i < length($li); $i++) {
>+	$c = substr($li,$i,1);
>+	if ($c eq "\t") {
>+	    $pos = ($pos+8) & ~7;
>+	} elsif ($c eq "\n") {
>+	    $mlen = $pos if ($pos > $mlen);
>+	    $pos = 0;
>+	} else {
>+	    $pos++;
>+	}
>+    }
>+
>+    $mlen = $pos if ($pos > $mlen);
>+    return $mlen;
>+}
>+


	Jan
-- 
