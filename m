Return-Path: <linux-kernel-owner+w=401wt.eu-S1764398AbXETLAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764398AbXETLAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbXETLAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:00:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47540 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758358AbXETLAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:00:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <465029F1.6090301@s5r6.in-berlin.de>
Date: Sun, 20 May 2007 12:58:57 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: Satyam Sharma <satyam.sharma@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>
Subject: Re: RFC: kconfig select warnings bogus?
References: <20070519151523.GA26724@uranus.ravnborg.org>  <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com>  <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com>  <20070519230940.GJ6291@stusta.de>  <a781481a0705191617v901ac64nfa7040ff302d2da1@ma <a781481a0705191719u5234b248v8d36af6a368a5119@mail.gmail.com> <Pine.LNX.4.58.0705200228360.1671@shell4.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0705200228360.1671@shell4.speakeasy.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho wrote:
> config ATARI_KBD_CORE
> 	bool
> 	default y if KEYBOARD_ATARI
> 	default y if MOUSE_ATARI
> 
> Basically a line "config A \n select B" is transformed into "config B \n
> default y if A".  It's the same number of lines, they're just in a new place.

Basically you replace

	A... depends on B

by

	B... serves A

The latter variant is a pain to maintain.  Dependencies change over
time, therefore we should note the dependency always at the dependent
option, not at the serving option.

Iterating upwards and downwards the dependency graph is the duty of
"make snafuconfig", not of the maintainers.

Besides, the "serves" form cannot stand in for constructs like

	A... depends on (B && C) || D
-- 
Stefan Richter
-=====-=-=== -=-= =-=--
http://arcgraph.de/sr/
