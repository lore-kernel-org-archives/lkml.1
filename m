Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbYHRSeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbYHRSeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbYHRSeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:34:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbYHRSeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:34:12 -0400
Subject: Re: [malware-list] scanner interface proposal was:
	[TALPA]	Intro	to a linux interface for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: davecb@sun.com, david@lang.hm, Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1219082097.15566.82.camel@localhost.localdomain>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>
	 <1219076143.15566.39.camel@localhost.localdomain>
	 <20080818171500.78590801@lxorguk.ukuu.org.uk>
	 <1219080504.15566.65.camel@localhost.localdomain>
	 <20080818182556.13ced58f@lxorguk.ukuu.org.uk>
	 <1219082097.15566.82.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 14:30:46 -0400
Message-Id: <1219084246.15566.86.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 13:54 -0400, Eric Paris wrote:
> On Mon, 2008-08-18 at 18:25 +0100, Alan Cox wrote:
> > > I think I'm going to stick with my special file in securityfs since it
> > > makes it some simple to install the fd in the scanning process (as
> > > opposed to netlink where I don't even know how it would be possible...)
> > 
> > AF_UNIX passes file handles just fine. I'm not sure netlink will help you
> > here anyway - isn't it lossy under load ?
> 
> But the file being installed needs to be at least RD for AV/Indexer.
> Particularly of interest to people here would be a file opened O_WRONLY
> and then the indexer wouldn't have the ability to read the data that was
> just written.  So we need a new FD, can't just send the old one.

Also not knowing much about sending FD's over AF_UNIX sockets, do they
share the same seek offsets or does the new process get a new fd which
points to the same data?  I wouldn't want to have to count on the
indexer to not move the offset around on the bittorrent client.  Like I
said, haven't never used sendmsg to pass a socket I don't know what you
get on the other end.

-Eric

