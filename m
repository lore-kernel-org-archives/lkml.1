Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbYA0HAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbYA0HAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 02:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYA0HAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 02:00:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbYA0HAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 02:00:04 -0500
Date: Sat, 26 Jan 2008 23:00:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Michael K?hn <breiteseite1337@googlemail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] 2.6.24, net/bluetooth/hci_sysfs.c, cleaned code
 remove compiler warning
In-Reply-To: <479BF21B.8070104@googlemail.com>
Message-ID: <alpine.LFD.1.00.0801262256070.3222@www.l.google.com>
References: <479BF21B.8070104@googlemail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Jan 2008, Michael K?hn wrote:
> 
> the attached Patch will remove a compiler warning in
> net/bluetooth/hci_sysfs.c:

Please don't do this. I realize that gcc suggests just adding parenthesis, 
and yes, it makes the warning go away, but it's not sensible from a human 
semantic standpoint.

So if the warning bothers you, please change

	while (dev = device_find_child(..)) {

into something like

	while ((dev = device_find_child(..)) != NULL) {

which also gets rid of the warning, but now does it with something that 
makes sense to a human too.

Just arbitrarily adding another set of parentheses never made much sense 
to me. It's semantically still the exact same expression, just the fact 
that gcc suddenly doesn't warn about the assignment because it's "hidden" 
by the extra parenthesis is just odd.

		Linus
