Return-Path: <linux-kernel-owner+w=401wt.eu-S1763784AbXGVS4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763784AbXGVS4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762415AbXGVSz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:55:57 -0400
Received: from Kiwi.CS.UCLA.EDU ([131.179.128.19]:55191 "EHLO kiwi.cs.ucla.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761524AbXGVSzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:55:55 -0400
X-Greylist: delayed 1016 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jul 2007 14:55:55 EDT
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Matthew Wilcox <matthew@wil.cx>, Denis Cheng <crquan@gmail.com>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: diffutils: C labels misdetected as functions
References: <1184489571313-git-send-email-crquan@gmail.com>
	<4699EEA9.6070709@simon.arlott.org.uk>
	<20070720170743.GF14791@parisc-linux.org>
	<46A0F282.8070103@simon.arlott.org.uk>
	<20070720180019.GJ14791@parisc-linux.org>
	<46A1A375.3020900@simon.arlott.org.uk>
	<20070721135200.GQ14791@parisc-linux.org>
	<46A25BE0.7000104@simon.arlott.org.uk>
From: Paul Eggert <eggert@CS.UCLA.EDU>
Date: Sun, 22 Jul 2007 11:38:33 -0700
In-Reply-To: <46A25BE0.7000104@simon.arlott.org.uk> (Simon Arlott's message of "Sat\, 21 Jul 2007 20\:17\:52 +0100")
Message-ID: <87abtogu6u.fsf@penguin.cs.ucla.edu>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott <simon@fire.lp0.eu> writes:

> The patch below stops diffutils treating C labels starting in column 1 as function names.

That patch alone wouldn't suffice, since -p is documented as implying
-F '^[[:alpha:]$_]'.  If the behavior changes, we'd also have to
change the documentation to match.

I'm not sure the change is a good idea.  It would complicate the
documentation and therefore the user interface, without that much
benefit.  And it wouldn't suffice in general, since it would still
mishandle labels followed by comments or by white space.

Also, for long C functions some people might rather see a top-level
(unindented) label highlighted than the function name highlighted, so
they might prefer the current behavior.

Anyway, to work around your problem without changing "diff", you can
use "diff -u -F '^[[:alpha:]$_](|.*[^:])$'" instead of "diff -u -p".
Or you can put a single space before the labels in question: they'll
still stand out plenty.
