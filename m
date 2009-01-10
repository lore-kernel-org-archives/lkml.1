Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZAJVuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZAJVuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZAJVuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:50:10 -0500
Received: from thunk.org ([69.25.196.29]:58085 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbZAJVuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:50:08 -0500
Date: Sat, 10 Jan 2009 16:50:02 -0500
From: Theodore Tso <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       ltt-dev@lists.casi.polymtl.ca,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [ltt-dev] Fw: [PATCH] ext4: Add markers for better
	debuggability
Message-ID: <20090110215002.GG31579@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	ltt-dev@lists.casi.polymtl.ca,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <20090109170408.75C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090109144901.GA7262@Krystal> <20090109185840.GD23869@mit.edu> <20090110161906.GB20526@Krystal> <20090110184240.GA31579@mit.edu> <alpine.DEB.1.10.0901101539230.32218@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901101539230.32218@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 03:40:16PM -0500, Steven Rostedt wrote:
> 
> Actually, that's one of the things ftrace is suppose to do, and is on my 
> todo list. To track all trace points, and be able to hook into any one and 
> print them out to the trace.

As a feature request, can this include actually printing the data
which gets captured at a tracepoint, and not just the fact that we hit
a particular tracepoint?

One nice thing about the markers infrastructure was it included a
printk format strong, so this would have been very easy.  The current
tracepoints insertion hook, while convenient in that you can just pass
it a data structure like this:

+       trace_ext4_sync_file(file, dentry, datasync);

....instead of this...

-       trace_mark(ext4_sync_file, "dev %s datasync %d ino %ld parent %ld",
-                  inode->i_sb->s_id, datasync, inode->i_ino,
-                  dentry->d_parent->d_inode->i_ino);


Has as its downside the fact that it's going to be difficult for
ftrace to be able to pretty-print the contents of data structure.
Where as with the trace_mark() format string, it would be trivially
easy for ftrace to print the information captured at the trace point.

For the bulk of the ext4 tracepoints, merely logging the fact that we
hit the "ext4_sync_file" tracepoint isn't going to be particularly
interesting; it's the data associated with hitting that particular
tracepoint which I really want to be able to get access to.

(And why I decided to use markers instead of tracepoints.  With
systemtap, I can access the markers *today* looks like being able to
do something useful with tracepoints is still a work in progress....
But as I said, I've been warning the Systemtap folks for a while now
that they don't get their act together, there will be replacements
written by kernel developers that will be designed to be useful for
kernel developers --- but they chose not to believe James Bottomley or
myself, and blew us off --- so when there is a functional equivalent
ready, I'm happy to switch; it just doesn't seem quite there yet.)


   	     	    	 	     	      - Ted
