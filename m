Return-Path: <linux-kernel-owner+w=401wt.eu-S2992659AbXDDFvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992659AbXDDFvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992665AbXDDFvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:51:04 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:35126 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992659AbXDDFvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:51:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=iSiOha7Aib50Oev0nV4lLAZJr0nS8o1ppLBkBZOyVIRMOoMWDensfe/iTKYnsGMc5qUyJv3FZ/ZkKz0731fEXQFFH1hIHgfz4FSAZScRLOa3V/pGAbgn4uMFuEXivHYrNtdSit2StvsBzUneJoWWtek26dDe8BKhbtbvLoaLVS8=  ;
X-YMail-OSG: ocZkKRIVM1kxlAq4C7.l5e7D6gujI6oH23cuJL2oY9LY7h27DtXAyNG7fZndbnHTTNjyCUvi3Sw8K6SBKHs2Te9KOnefkWCXKHGcrn9MX1AIaHVTuhHSSoF3UuzQEJFh9RdZJaD1RT2czPE-
Message-ID: <46133CC0.505@yahoo.com.au>
Date: Wed, 04 Apr 2007 15:50:56 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] maps: Move the page walker code to lib/
References: <7.486631555@selenic.com> <461320C9.5030601@yahoo.com.au> <20070404050857.GU4892@waste.org>
In-Reply-To: <20070404050857.GU4892@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Wed, Apr 04, 2007 at 01:51:37PM +1000, Nick Piggin wrote:
> 
>>Matt Mackall wrote:
>>
>>>Move the page walker code to lib/
>>>
>>>This lets it get shared outside of proc/ and linked in only when
>>>needed.
>>
>>I think it would be better in mm/.
> 
> 
> I originally was looking at putting it in mm/memory.c and possibly

Just put it in its own file in mm/ rather than its own file in lib.
lib should be for almost-standalone stuff, IMO (ie. only using basic
kernel functionality).

Yes, I think ioremap.c should be in mm/ as well.

> converting some users there. But I decided it ought to be
> conditionally linked until it had some core users and I wasn't quite
> ready to tackle the tricky mm/ bits.

Apart from these users outside mm/, I don't see much point in converting
things over. The page table walking API we have now is neat and simple.
It takes a few lines of code, but is it a big problem?

-- 
SUSE Labs, Novell Inc.
