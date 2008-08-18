Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYHRQdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYHRQdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYHRQdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:33:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35227 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751051AbYHRQdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:33:03 -0400
Date: Mon, 18 Aug 2008 17:15:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       david@lang.hm, Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro	to
 a linux interface for on access scanning
Message-ID: <20080818171500.78590801@lxorguk.ukuu.org.uk>
In-Reply-To: <1219076143.15566.39.camel@localhost.localdomain>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>
	<1219076143.15566.39.camel@localhost.localdomain>
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

> On async notification we fire a message to everything that registered
> 'simultaneously.' On blocking we fire a message to everything in
> priority order and block until we get a response.  That response should
> be of the form ALLOW/DENY and should include "mark result"/"don't mark
> result."

No can do - you get stuck with recursive events with the virus checker
trying to stop the indexer from indexing a worm.

> read -> we have the ALLOW/mark result bit in core set so just allow.

Don't think we need this - SELinux can do that bit

> mtime update -> clear ALLOW/"mark result" bit in core, send async
> notification to userspace

Why via the kernel ?

> The communication with userspace has a very specific need.  The scanning
> process needs to get 'something' that will give it access to the
> original file/inode/data being worked on.  My previous patch set does

file handle. Really you need to give the handle of the object because it
may not have a name or a meaningful inode number

