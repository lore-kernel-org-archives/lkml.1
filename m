Return-Path: <linux-kernel-owner+w=401wt.eu-S1030900AbXDJPuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030900AbXDJPuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030906AbXDJPuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:50:12 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38488 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030900AbXDJPuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:50:10 -0400
Message-ID: <461BB1C1.5050709@zytor.com>
Date: Tue, 10 Apr 2007 08:48:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Theodore Tso <tytso@mit.edu>, Trond Myklebust <trond.myklebust@fys.uio.no>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
References: <20070407233037.GA16508@infradead.org>	 <20070408184129.GA20871@lazybastard.org>	 <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com>	 <20070409014426.GA18580@thunk.org>	 <20070409110927.GA23240@lazybastard.org>	 <1176121897.6210.8.camel@heimdal.trondhjem.org>	 <20070409131918.GC18580@thunk.org>	 <1176127395.6210.34.camel@heimdal.trondhjem.org>	 <20070410135641.GG13650@thunk.org> <a36005b50704100710i28d5681fsdab6deb1d5161e28@mail.gmail.com>
In-Reply-To: <a36005b50704100710i28d5681fsdab6deb1d5161e28@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 4/10/07, Theodore Tso <tytso@mit.edu> wrote:
>> That might work.  But if in the long term we want to separate out what
>> we can send back via telldir/seekdir, and some future new Posix
>> interface, [...]
> 
> With all these discussions about fixes for telldir, do we want to
> persue an alternative interface where the user can explicitly specify
> that no telldir/seekdir will ever be used?  From what I know so far it
> would make technical sense since we could speed up/reduce the memory
> footprint of readdir in 99% of most programs.  But is the benefit
> large enough to warrant a second interface?

The real problem sounds like NFS is, in effect, doing telldir/seekdir on 
every directory reference.

It rather makes any user space accesses irrelevant.  The main question 
seems to be if we can realistically increase the cookie size even to 64 
bits.

	-hpa
