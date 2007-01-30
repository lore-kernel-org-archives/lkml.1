Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbXA3CCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbXA3CCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 21:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbXA3CCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 21:02:50 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:20320 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751825AbXA3CCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 21:02:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=x1BAz34vYGtnY6/6mv1I/DaILUkb7DJWY2WzA5FgT1/Bwhh9z8D6cEIaV2VtGaDheoIXp6XuUJynjw+eG9HNaYDd8LP2ZAkmlM8Ra1dNk5HyOV55zD5dS/H148sSRWa2oKMidBiMaPxpgBj9nlBhAWBXIVQUgo0J8uIMSHLTuF0=  ;
X-YMail-OSG: MPxRv8IVM1mMGhPB9v__TuGvPTR3jwl5sDe4JOd36O3_jjrn8jtjs8H0zdv3inJnliuJLDUzcQ--
Message-ID: <45BEA73C.5030809@yahoo.com.au>
Date: Tue, 30 Jan 2007 13:02:36 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@osdl.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
References: <1169993494.10987.23.camel@lappy> <20070128142925.df2f4dce.akpm@osdl.org> <20070129190806.GA14353@elte.hu>
In-Reply-To: <20070129190806.GA14353@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> For every 64-bit Fedora box there's more than seven 32-bit boxes. I 
> think 32-bit is going to live with us far longer than many thought, so 
> we might as well make it work better. Both HIGHMEM and HIGHPTE is the 
> default on many distro kernels, which pushes the kmap infrastructure 
> quite a bit.

I don't think anybody would argue against numbers, but just that there
are not many big 32-bit SMPs anymore. And if Bill Irwin didn't fix the
kmap problem back then, it would be interesting to see a system and
workload where it actually is a bottleneck.

Not that I'm against any patch to improve scalability, if it doesn't
hurt single-threaded performance ;)

> the problem is that everything that was easy to migrate was migrated off 
> kmap() already - and it's exactly those hard cases that cannot be 
> converted (like the pagecache use) which is the most frequent kmap() 
> users.

Which pagecache use? file_read_actor()?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
