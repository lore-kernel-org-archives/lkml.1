Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbXKLWIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbXKLWIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXKLWIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:08:16 -0500
Received: from mailout11.sul.t-online.de ([194.25.134.85]:45141 "EHLO
	mailout11.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbXKLWIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:08:15 -0500
Message-ID: <4738CEBB.8000501@t-online.de>
Date: Mon, 12 Nov 2007 23:07:55 +0100
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070810)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] add -fno-tree-scev-cprop to KBUILD_CFLAGS
References: <20071111064829.GG21669@stusta.de> <47387E32.4050206@t-online.de> <20071112164023.GL9771@stusta.de>
In-Reply-To: <20071112164023.GL9771@stusta.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ID: TWwpJEZGghXPdq-7LWtxlp7iOLk1okho7cM6uihjC4R7MsarIPiunyfQ1GN2W1zwnS
X-TOI-MSGID: d16c5c6d-aad3-461d-8b06-be7ef3757ac4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> It can be a performance regression, but there are also cases where it 
> can improve performance. If gcc produces lower performance code that
> would be a bug in gcc that should be reported, but using a division is 
> not generally wrong.
> 
> A more clearer example might be:
> 
> <--  snip  -->
> 
> void foo(u64 ns)
> {
> 	if (ns < 10000)
> 		return;
> 
> 	while(ns >= 3) {
> 		ns -= 3;
> #ifdef DEBUG
> 		bar(ns);
> #endif
> 	}
> }
> 
> <--  snip  -->
> 
> With DEBUG not defined you can hardly argue gcc should be fixed to not 
> use a division for performance reasons.

Absent any clear information about the possible values of ns, IMO this
is a case where the compiler should just assume that the programmer
knows best whether to use a loop or a division.  Principle of least
surprise, and all that...


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
