Return-Path: <linux-kernel-owner+w=401wt.eu-S1758515AbZKKS4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbZKKS4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 13:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758498AbZKKS4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 13:56:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35229 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758437AbZKKS4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 13:56:37 -0500
Date: Wed, 11 Nov 2009 19:56:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Jeff Garzik <jeff@garzik.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091111185628.GA17720@elte.hu>
References: <20091025225342.007138f5@infradead.org>
 <20091111020108.GA11423@localhost>
 <20091110223456.01ef355f@infradead.org>
 <4AFA6AEF.5060306@garzik.org>
 <20091111074542.GB25132@elte.hu>
 <20091111182925.GH13262@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111182925.GH13262@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Nov 11, 2009 at 08:45:42AM +0100, Ingo Molnar wrote:
> > Without an inode->vfs-name lookup/matching service it's of limited 
> > utility though to developers and users. So inode numbers are fine (as 
> > nicely unique physical identifiers)- as long as corresponding vfs name 
> > string is available too.
> 
> Inode numbers are quite usable for me; but I'm not afraid to do
> 
>       debugfs /dev/sdb -R "ncheck 12345"
> 
> :-)
> 
> If you really want to avoid that, one relatively lightweight thing we 
> could do, which would avoid needing to dump the entire pathname out, 
> would be to print out the triple (devno, dir_ino, file_ino), and then 
> provide a privileged syscall which translates this to a user-visible 
> pathname.  It won't be necessarily the pathname which the user used to 
> open the file (since there might be links, and bind mounts, et. al), 
> but if the goal is to give one of the user-friendly names of the inode 
> (as opposed to _the_ pathname used to open the file), it's quite 
> sufficient.

Hm, why add a new syscall to retrieve the name we already had when the 
event happened?

Also, why add a new syscall to retrieve something that might not exist 
anymore? (the VFS namespace is quite dynamic - post-processing to 
retrieve names is fundamentally racy)

What matters most for analysis is the 'name of the moment' - the thing 
that the app used at that point.

Arjan isnt doing this just randomly, he's one of the few people trying 
to speed up Linux booting - and this is the info he finds useful. We 
should give that information in a reasonable way, and the tracepoint he 
proposed looks pretty reasonable.

	Ingo
