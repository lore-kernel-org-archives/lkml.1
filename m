Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbXFYHma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbXFYHma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXFYHmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:42:05 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:20634 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751882AbXFYHmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:42:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=FxOpVTPX5hPycywpgzAOy72OP+zYnzfdk1yhaWLBj1a7d68GYefg4hMQr7iCBZwREil0g/nIKQBN6F2Js+p/gVTnR0VNhLWk5tkhKomf7Ot4b8L6bOmkL6jyJW08TAV1q9L2jGo0f4u14WzTReblgMOngY8saGSfv8eVDPytAww=  ;
X-YMail-OSG: g6J._nUVM1nVxQucbkNUAem_ha2iWzVfsvU1IBKlHgXhmQpbibUpRefEMU1asLFSmeSjnLzmKw--
Message-ID: <467F71C6.6040204@yahoo.com.au>
Date: Mon, 25 Jun 2007 17:41:58 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/3] add the fsblock layer
References: <20070624014528.GA17609@wotan.suse.de>	<20070624014613.GB17609@wotan.suse.de> <18046.63436.472085.535177@notabene.brown>
In-Reply-To: <18046.63436.472085.535177@notabene.brown>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Sunday June 24, npiggin@suse.de wrote:
> 
>> 
>>+#define PG_blocks		20	/* Page has block mappings */
>>+
> 
> 
> I've only had a very quick look, but this line looks *very* wrong.
> You should be using PG_private.
> 
> There should never be any confusion about whether ->private has
> buffers or blocks attached as the only routines that ever look in
> ->private are address_space operations  (or should be.  I think 'NULL'
> is sometimes special cased, as in try_to_release_page.  It would be
> good to do some preliminary work and tidy all that up).

There is a lot of confusion, actually :)
But as you see in the patch, I added a couple more aops APIs, and
am working toward decoupling it as much as possible. It's pretty
close after the fsblock patch... however:


> Why do you think you need PG_blocks?

Block device pagecache (buffer cache) has to be able to accept
attachment of either buffers or blocks for filesystem metadata,
and call into either buffer.c or fsblock.c based on that.

If the page flag is really important, we can do some awful hack
like assuming the first long of the private data is flags, and
those flags will tell us whether the structure is a buffer_head
or fsblock ;) But for now it is just easier to use a page flag.

-- 
SUSE Labs, Novell Inc.
