Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbXLBXPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbXLBXPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 18:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXLBXPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 18:15:07 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56355 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbXLBXPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 18:15:06 -0500
Date: Mon, 3 Dec 2007 00:15:04 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Valdis.Kletnieks@vt.edu, tvrtko.ursulin@sophos.com,
       Andi Kleen <andi@firstfloor.org>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
In-Reply-To: <20071202215634.GB2438@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0712022356460.24188@fbirervta.pbzchgretzou.qr>
References: <p738x4i9nyd.fsf@crumb.suse.de>
 <OFFB86F10D.D565B603-ON802573A2.005A558C-802573A2.005B85B0@sophos.com>
 <20071201084332.GB4446@ucw.cz> <17957.1196624688@turing-police.cc.vt.edu>
 <20071202202240.GB1625@elf.ucw.cz> <23463.1196629795@turing-police.cc.vt.edu>
 <20071202215634.GB2438@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 2 2007 22:56, Pavel Machek wrote:
>> 
>> We probably want to hear related usages as well - what *besides*
>> A/V would be interested? Indexing services?
>
Indexing services would probably benefit much more from a
recursive-aware inotify, though that has its own sort of problems to
solve first.

>Well... I'd really like to know what A/V people are trying to do.
>
>Indexing services are really different, and doable with recursive
>m-time Jan is preparing... 
>
m-time <=> modification time?
What am I preparing?

I am actually on a freeze, because I really do not know what to make
of the situation with the static LSM interface.

There is a grave problem with chaining, because you cannot specify
the activation order of one or more LSMs with compiled-in code!

Some kernel Makefiles even contain hints "this depends on link order"
(e.g. net/ipv6/netfilter/Makefile) - and I bet for sure that this
will also be the case for LSM. No thanks.

While we are at it, consider the hypothethical case of a production
server, and the boss tells you to switch to $ThatLSM, with no downtime.
After all, it worked when $Company switched to $ThisLSM with Linux
2.6.x &forall; x<24.
