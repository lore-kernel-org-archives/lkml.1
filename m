Return-Path: <linux-kernel-owner+w=401wt.eu-S1030959AbXDJQDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030959AbXDJQDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030960AbXDJQDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:03:24 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:34939 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030959AbXDJQDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:03:23 -0400
Date: Tue, 10 Apr 2007 17:54:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
In-Reply-To: <1176215836.14442.37.camel@heimdal.trondhjem.org>
Message-ID: <Pine.LNX.4.61.0704101750420.21664@yvahk01.tjqt.qr>
References: <20070407233037.GA16508@infradead.org>  <46193048.6000606@zytor.com>
 <20070408184129.GA20871@lazybastard.org>  <20070408191955.GD29180@thunk.org>
 <46194260.3050900@zytor.com>  <20070409014426.GA18580@thunk.org>
 <20070409110927.GA23240@lazybastard.org>  <1176121897.6210.8.camel@heimdal.trondhjem.org>
  <20070409131918.GC18580@thunk.org>  <1176127395.6210.34.camel@heimdal.trondhjem.org>
  <20070410135641.GG13650@thunk.org> <1176215836.14442.37.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 10 2007 10:37, Trond Myklebust wrote:
>
>NFS, OTOH, simply could not work without that requirement, since there
>exists no file pointer to tell you where you are in a stream beyond
>whatever the server manages to encode inside the opaque cookie+verifier.
>
>> But the fact of the matter is that if NFS protocols demands that a
>> per-directory entry cookie can be uniquely and permanently (including
>> across server reboots) identified with a small integer number, it's
>> dreaming.  Filesystem authors will cheat one way or another, because
>> there's nothing else for them to do.  
>
>Few people in the NFS community would disagree that the design of
>READDIR sucks (personally, I consider it to be one of the biggest
>scalability issues we have).
>The problem is that it is extremely hard to come up with an alternative
>that doesn't impose new conditions on what filesystems you can support.

I had a thought, but I think it's not quite ripe..

NFS server sends the whole directory contents on NFS client opendir,
so that the whole readdir/telldir/seekdir magic can happen on the
client only... which would perhaps also enable a cheap telldir/seekdir,
and would also give a 'fixed view' when adding/deleting files
during readdir.


Jan
-- 
