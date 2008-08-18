Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYHRPue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYHRPue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYHRPuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:50:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58944 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752099AbYHRPuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:50:24 -0400
Date: Mon, 18 Aug 2008 16:31:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tvrtko.ursulin@sophos.com
Cc: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Adrian Bunk <bunk@kernel.org>, capibara@xs4all.nl,
       Casey Schaufler <casey@schaufler-ca.com>, davecb@sun.com, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, rmeijer@xs4all.nl
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro	to
 a linux interface for on access scanning
Message-ID: <20080818163148.0ef3e383@lxorguk.ukuu.org.uk>
In-Reply-To: <20080818153212.6A6FD33687F@pmx1.sophos.com>
References: <20080818142511.GC8184@mit.edu>
	<20080818153212.6A6FD33687F@pmx1.sophos.com>
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

> Huh? I was never advocating re-scan after each modification and I even 
> explicitly said it does not make sense for AV not only for performance but 
> because it will be useless most of the time. I thought sending out 
> modified notification on close makes sense because it is a natural point, 
> unless someone is trying to subvert which is out of scope. Other have 
> suggested time delay and lumping up.

You need a bit more than close I imagine, otherwise I can simply keep the
file open forever. There are lots of cases where that would be natural
behaviour - eg if I was to attack some kind of web forum and insert a
windows worm into the forum which was database backed the file would
probably never be closed. That seems to be one of the more common attack
vectors nowdays.

> 
> Also, just to double-check, you don't think AV scanning would read the 
> whole file on every write?

So you need the system to accumulate some kind of complete in memory set
of 'dirty' range lists on all I/O ? That is going to have pretty bad
performance impacts and serialization.
