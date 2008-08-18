Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYHRSLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYHRSLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYHRSLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:11:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58946 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753266AbYHRSL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:11:29 -0400
Date: Mon, 18 Aug 2008 18:53:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: davecb@sun.com
Cc: tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       capibara@xs4all.nl, Casey Schaufler <casey@schaufler-ca.com>,
       david@lang.hm, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, rmeijer@xs4all.nl
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to
 a linux interface for on access scanning
Message-ID: <20080818185332.202b32f0@lxorguk.ukuu.org.uk>
In-Reply-To: <48A97C42.4040103@sun.com>
References: <20080818142511.GC8184@mit.edu>
	<20080818153212.6A6FD33687F@pmx1.sophos.com>
	<20080818163148.0ef3e383@lxorguk.ukuu.org.uk>
	<48A97C42.4040103@sun.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   I suspect we're saying "on close" when what's really meant is
> "opened for write". In the latter case, the notification would tell
> the user-space program to watch for changes, possibly by something as
> simple as doing a stat now and another when it gets around to 

Or more precisely perhaps "on the file becoming dirty". A program that
opens for write, computes for an hour and writes out doesn't want to load
events down until it begins writing.

I agree "on close" is inaccurate for the scanner cases and that is why
we've been talking about events + a close time event.

> deciding if it should scan the file. I see lots of room for
> user-space alternatives for change detection, depending on how much
> state it keeps. Rsync-like, perhaps?

Agreed.
