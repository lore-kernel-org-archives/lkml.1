Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZC1AOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZC1AOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZC1AOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:14:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55017 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbZC1AOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:14:30 -0400
Message-ID: <49CD6BCC.6080602@garzik.org>
Date: Fri, 27 Mar 2009 20:14:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Chris Mason <chris.mason@oracle.com>, Ric Wheeler <rwheeler@redhat.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 0/3] Ext3 latency improvement patches
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238187031.27455.212.camel@think.oraclecorp.com> <1238187818.27455.217.camel@think.oraclecorp.com> <20090327213052.GC5176@mit.edu> <20090327215454.GH31071@duck.suse.cz> <20090327230902.GG5176@mit.edu>
In-Reply-To: <20090327230902.GG5176@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> OTOH, the really big databases will tend to use direct I/O, so they
> won't be dirtying the page cache anyway.  So maybe it's not worth the

Not necessarily...  From what I understand, a lot of the individual 
low-level components in cloud storage, such as GoogleFS's chunk 
server[1] do not bypass the page cache, even though they do care about 
the details of data caching and data consistency.

I am looking at the same areas for my own distributed storage work, and 
am finding that the current crop of Linux-specific, 
database/server-friendly syscalls permit more application control over 
pagecache usage than in past years, decreasing the need for O_DIRECT. 
Things like readahead(2), sync_file_range(2), fadvise(3), really help.

	Jeff


[1] http://labs.google.com/papers/gfs-sosp2003.pdf

