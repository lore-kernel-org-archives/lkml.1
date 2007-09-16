Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbXIQNCC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbXIQNCC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:02:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbXIQNBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:01:10 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:39643 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753737AbXIQNBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:01:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pYu8SWJEDvAbSZqP5epLo4s8C4cpHz8qlQS0XOkitDQ8TPNKgVHuJSm1kq5b9g73K1Lh5MmvtGeZNbWGiBR+SmfgECZf13xerADN5L28OyCDeVhbNeKkzo4YqJW5S1qkhnTm36Lw4WP9HWIOAStWOpKscmyzJAKmMyJ/NPeUSts=  ;
X-YMail-OSG: 5T1YErIVM1moPR6ANVLXGwY3t1_oYQyNYKnYaIpOpjUm.1QgJ1QVJabzop9tKgcz54o4R3e1MQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@skynet.ie>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Sun, 16 Sep 2007 19:03:36 +1000
User-Agent: KMail/1.9.5
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, Christoph Lameter <clameter@sgi.com>,
       andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
References: <20070911060349.993975297@sgi.com> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070916181313.GA16406@skynet.ie>
In-Reply-To: <20070916181313.GA16406@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709161903.37295.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2007 04:13, Mel Gorman wrote:
> On (15/09/07 14:14), Goswin von Brederlow didst pronounce:

> > I keep coming back to the fact that movable objects should be moved
> > out of the way for unmovable ones. Anything else just allows
> > fragmentation to build up.
>
> This is easily achieved, just really really expensive because of the
> amount of copying that would have to take place. It would also compel
> that min_free_kbytes be at least one free PAGEBLOCK_NR_PAGES and likely
> MIGRATE_TYPES * PAGEBLOCK_NR_PAGES to reduce excessive copying. That is
> a lot of free memory to keep around which is why fragmentation avoidance
> doesn't do it.

I don't know how it would prevent fragmentation from building up
anyway. It's commonly the case that potentially unmovable objects
are allowed to fill up all of ram (dentries, inodes, etc).

And of course,  if you craft your exploit nicely with help from higher
ordered unmovable memory (eg. mm structs or unix sockets), then
you don't even need to fill all memory with unmovables before you
can have them take over all groups.
