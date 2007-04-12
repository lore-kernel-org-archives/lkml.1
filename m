Return-Path: <linux-kernel-owner+w=401wt.eu-S1161483AbXDLClu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161483AbXDLClu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161489AbXDLClu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:41:50 -0400
Received: from lazybastard.de ([212.112.238.170]:35692 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161483AbXDLClt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:41:49 -0400
Date: Thu, 12 Apr 2007 04:37:12 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Neil Brown <neilb@suse.de>
Cc: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070412023712.GA8175@lazybastard.org>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <17947.65165.569482.976343@notabene.brown> <20070411144252.GB17778@thunk.org> <17949.25061.739035.688232@notabene.brown> <20070411232224.GF17778@thunk.org> <17949.36737.701327.104172@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17949.36737.701327.104172@notabene.brown>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 April 2007 11:46:41 +1000, Neil Brown wrote:
> 
> I could argue that nfs came before ext3+dirindex, so ext3 should have
> been designed to work properly with NFS.  You could argue that fixing
> it in nfsd fixes it for all filesystems.  But I'm not sure either of
> those arguments are likely to be at all convincing...

Caring about a non-ext3 filesystem, I sure would like an nfs solution as
well. :)

> Hmmm. I wonder.  Which is more likely?
>   - That two 64bit hashes from some set are the same
>   - or that 65536 48bit hashes from a set of equal size are the same.

The former.  Each bit going from hash strength to collision chain length
reduces the likelihood of an overflow.  In the extreme case of a 0bit
hash and 64bit collision chain, you need 2^64 entries compared to 2^32
for the other extreme.

However, the collision chain gives me quite a bit of headache.  One
would have to store each entry's position on the chain, deal with older
entries getting deleted, newer entries getting removed, etc.  All this
requires a lot of complicated code that basically never gets tested in
the wild.

Just settling for a 64bit hash and returning -EEXIST when someone causes
a collision an creat() sounds more appealing.  Directories with 4
billion entries will cause problems, but that is hardly news to anyone.

Jörn

-- 
Fantasy is more important than knowledge. Knowledge is limited,
while fantasy embraces the whole world.
-- Albert Einstein
