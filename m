Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbXFZCel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbXFZCel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 22:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbXFZCec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 22:34:32 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:45640 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752384AbXFZCeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 22:34:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=xcypboBmtdoA8XGFZfxSqV5CiJPx/jy8Y30ITUyE/ypjSpeY5iDulERlypLLeq25wOQMeJsYn8HN28SVQCeukI/4+WiJhzN5EGr5qEO43sMb7ZaG7WFeAUd4cby3Cj9cS3+gnkatiNdN9yHQ8bWLOzYie7XNQz50WOvbf7Fhrvg=  ;
X-YMail-OSG: lkNNx8QVM1nUTLL1zLAO.UnfOmYWQkmauPv_hLnKMcOzjI79jteWHZZde9vQTbJIOujtSyneSQ--
Message-ID: <46807B32.6050302@yahoo.com.au>
Date: Tue, 26 Jun 2007 12:34:26 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/3] add the fsblock layer
References: <20070624014528.GA17609@wotan.suse.de> <20070624014613.GB17609@wotan.suse.de> <18046.63436.472085.535177@notabene.brown> <467F71C6.6040204@yahoo.com.au> <20070625122906.GB12446@think.oraclecorp.com>
In-Reply-To: <20070625122906.GB12446@think.oraclecorp.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> On Mon, Jun 25, 2007 at 05:41:58PM +1000, Nick Piggin wrote:
> 
>>Neil Brown wrote:

>>>Why do you think you need PG_blocks?
>>
>>Block device pagecache (buffer cache) has to be able to accept
>>attachment of either buffers or blocks for filesystem metadata,
>>and call into either buffer.c or fsblock.c based on that.
>>
>>If the page flag is really important, we can do some awful hack
>>like assuming the first long of the private data is flags, and
>>those flags will tell us whether the structure is a buffer_head
>>or fsblock ;) But for now it is just easier to use a page flag.
> 
> 
> The block device pagecache isn't special, and certainly isn't that much
> code.  I would suggest keeping it buffer head specific and making a
> second variant that does only fsblocks.  This is mostly to keep the
> semantics of PagePrivate sane, lets not fuzz the line.

That would require a new inode and address_space for the fsblock
type blockdev pagecache, wouldn't it? I just can't think of a
better non-intrusive way of allowing a buffer_head filesystem and
an fsblock filesystem to live on the same blkdev together.

-- 
SUSE Labs, Novell Inc.
