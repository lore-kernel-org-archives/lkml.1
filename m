Return-Path: <linux-kernel-owner+w=401wt.eu-S1030914AbXDXAO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030914AbXDXAO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030894AbXDXAO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:14:58 -0400
Received: from ns1.suse.de ([195.135.220.2]:48984 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030914AbXDXAO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:14:56 -0400
From: Neil Brown <neilb@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 24 Apr 2007 10:14:38 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17965.19438.292138.959036@notabene.brown>
Cc: Theodore Tso <tytso@mit.edu>, Eric Hopper <hopper@omnifarious.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
In-Reply-To: message from H. Peter Anvin on Monday April 23
References: <462C2E5B.1080008@redhat.com>
	<Pine.LNX.4.64.0704230353000.25153@server.thyself>
	<462C4858.3050006@redhat.com>
	<Pine.LNX.4.64.0704230555020.25153@server.thyself>
	<462C4D32.4000909@redhat.com>
	<Pine.LNX.4.64.0704230611430.25153@server.thyself>
	<462C5034.9090403@redhat.com>
	<Pine.LNX.4.64.0704230640540.25153@server.thyself>
	<20070423010445.454eda63.akpm@linux-foundation.org>
	<20070423135216.GA2744@omnifarious.org>
	<20070423225640.GA1663@thunk.org>
	<462D46DF.4090802@zytor.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday April 23, hpa@zytor.com wrote:
> Theodore Tso wrote:
> > 
> > One of the big problems of using a filesystem as a DB is the system
> > call overheads.  If you use huge numbers of tiny files, then each
> > attempt read an atom of information from the DB takes three system
> > calls --- an open(), read(), and close(), with all of the overheads in
> > terms of dentry and inode cache.
> > 
> 
> Now, to be fair, there are probably a number of cases where 
> open/lseek/readv/close and open/lseek/writev/close would be worth doing 
> as a single system call.  The big problem as far as I can see involves 
> EINTR handling; such a system call has serious restartability implications.
> 
> Of course, there are Ingo's syslets...

Our you could think outside the circle:
Store all your "small files" as symlinks, then use "symlink" to create
them and "readlink" to read them. (You would probably end up use
symlinkat and readlinkat).
Only one system call instead of three.
I guess you don't get meaningful permission bits then... I wonder if
that really matters.

NeilBrown
