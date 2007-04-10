Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbXDJVrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbXDJVrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXDJVrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:47:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:45321 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbXDJVrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:47:35 -0400
From: Neil Brown <neilb@suse.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Date: Wed, 11 Apr 2007 07:15:57 +1000
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <17947.65165.569482.976343@notabene.brown>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
	<20070407203633.GA21555@thunk.org>
	<20070407233037.GA16508@infradead.org>
	<46193048.6000606@zytor.com>
	<20070408184129.GA20871@lazybastard.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday April 8, joern@lazybastard.org wrote:
> On Sun, 8 April 2007 11:11:20 -0700, H. Peter Anvin wrote:
> > 
> > Well, the question is if you can keep the seekdir/telldir cookie around 
> > as a pointer -- preferrably in userspace, of course.  You would 
> > presumably garbage-collect them on closedir() -- there is no other point 
> > at which you could.
> 
> Garbage-collecting them on closedir() does not work.  It surprised me as
> well, but there seem to be applications that keep the telldir() cookie
> around after closedir().  Iirc, "rm -r" was one of them.
> 
> Neil, is this correct?

It's just NFS.  nfsd does open/getdents/close on every readdir
request.
"rm -r" is the application that tends to detect any problems with
cookie handling between the NFS client and server.

(I'm sure there was once an 'rm -r' that used telldir/seekdir, but I
cannot find it.  Maybe it was level-7 UNIX :-)

NeilBrown
