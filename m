Return-Path: <linux-kernel-owner+w=401wt.eu-S1033425AbXEIDEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033425AbXEIDEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032831AbXEIDEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:04:20 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:41298 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1032629AbXEIDES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:04:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=eGmdzIahscDP41H6MP+4NOoFkEaF2LaNFdsay8WS9lJ3V4jq2xuh1LS3fRX6KZZiUCkGbekWp0I3hQ/lft2+Jm4OyqQJsBXpbxbfipvdeGfTGlW2rCW1t1rw3/bKL/Q2vXQaMiIBaqmjo54/F0MDyU5gvXVrvKdLSOgXntu4lO8=  ;
X-YMail-OSG: L1Da8KkVM1lZk5DoFDyyc6xQCFU8HbTfMt19NmpEzuKdJ.eJYoOAyE7MA8s.jKeTO8AjfIBJkA--
Message-ID: <46413A29.1000506@yahoo.com.au>
Date: Wed, 09 May 2007 13:04:09 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Matt Mackall <mpm@selenic.com>, akpm@linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net> <20070509002307.GV11115@waste.org> <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com> <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com> <20070509021911.GB11115@waste.org> <Pine.LNX.4.64.0705081920250.17931@schroedinger.engr.sgi.com> <4641353F.2000408@yahoo.com.au> <Pine.LNX.4.64.0705081954300.19976@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705081954300.19976@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 9 May 2007, Nick Piggin wrote:

>>For small systems, I would not be surprised if that was less space
>>efficient, even just looking at kmalloc caches in isolation. Or do you
>>have numbers to support your conclusion?
> 
> 
> No I do not have any number beyond the efficiency calculations based on 
> whole slabs. We would have to do some experiments to figure out how much 
> space is actually wasted through partial slabs.
> 
> If you just do straight allocation on a UP system then there is at maximum 
> one partial slab per slabcache with SLUB.
> 
> The situation becomes different with allocation and frees. Then we may 
> have lots of partial slabs that we allocate from.

Yeah, but even then I think the SLUB approach is a very nice one for a
general purpose system. Don't get me wrong, SLOB definitely is not good
for that :)


> But the SLOB approach 
> also will have holes to manage. So I do not see how this could be a 
> benefit unless you only have a few precious pages and you need to put 
> multiple object sizes into it. A 4M system still has 1000 pages.

Right, and it takes a long long time to do anything on my 4G system ;)

But that 4MB system might not even have 50 pages that you'd want to
use for slab.

-- 
SUSE Labs, Novell Inc.
