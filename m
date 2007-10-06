Return-Path: <linux-kernel-owner+w=401wt.eu-S1765637AbXJFWVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765637AbXJFWVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 18:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763718AbXJFWU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 18:20:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35068 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbXJFWU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 18:20:56 -0400
Date: Sun, 7 Oct 2007 00:20:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: On text size and run time if config is "n", [PATCH 2/2] Colored
 kernel output (run3)
In-Reply-To: <20071006222825.GK22435@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0710070016340.30354@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710062209530.20637@fbirervta.pbzchgretzou.qr>
 <20071006212538.GH22435@flower.upol.cz> <Pine.LNX.4.64.0710062322240.30354@fbirervta.pbzchgretzou.qr>
 <20071006222825.GK22435@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7 2007 00:28, Oleg Verych wrote:
>
>I thought, i was talking about *write() functions, that got one
>additional unrelated, non config removable API change in face of
>`unsigned int loglevel'.

Documentation/stable_api_nonsense.txt ;-)

>Idea. Extend those macro defines before format string with one
>additional macro, that will be empty, if config is NO and having
>colour byte otherwise.
>
>In the *write() functions, have
>
> color = str[0];
> ++str;

This is just as "bad" as the loglevel parameter. Because you'd have
to parse str[0] in _every_ write() function. Furthermore, the string
that is being printed also goes to klogd/syslog, including the <N>
tag already. If you now add a color byte in the KERN_* macros, then
that color byte would also go to syslog. Not good.

>Sorry, i don't know much about stuff, you've presented:

(Paraphrased one paragraph above.)
