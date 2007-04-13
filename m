Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbXDMCMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbXDMCMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXDMCMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:12:00 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:43093 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751473AbXDMCMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:12:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=JAuuTCV85dmaBqOq1CKkrtBQ4Aafav5AVgGjaSlbdqqawBcEtk2UlxdI/Xg6F1tSpDLM7vgCwPoYIPKAODCu5kaDMTEgag23YoV0FiqTO2pA6heTPyodwyS9Z+qH7Gp2rOxidiHuTa4uBWvYm7LsCkXXF07QC3a9iJXGpAGQs5g=  ;
X-YMail-OSG: ZysOpyEVM1lbdveGG4XWBsM1kdKPnpJ14ow0vzFFGxYPUEGc4G84kSU1Hy6uZNorl75lsrl_fA--
Message-ID: <461EE6E9.3070104@yahoo.com.au>
Date: Fri, 13 Apr 2007 12:11:53 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070413002538.GJ11115@waste.org> <461ED675.3060909@yahoo.com.au> <20070413013840.GK11115@waste.org>
In-Reply-To: <20070413013840.GK11115@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Fri, Apr 13, 2007 at 11:01:41AM +1000, Nick Piggin wrote:
> 
>>>Basically: to show what the hell's going on in the VM.
>>
>>kprobes / systemtap isn't good enough?
> 
> 
> It's not really a good match to the kprobes model. I'm not interested
> in events, per se. I don't want to need to know about every single
> alloc/free of N different varieties integrated from boot onward to
> build up an image of the state of the system. Instead, I want to take
> snapshots of the state of the VM.

Systemtap can't output a large set of values?

Why can't you attach a kprobe to a dummy syscall, and from there
iterate over pgdat/zone/memmap and output what you want?

Actually I'm surprised that kind of data querying facility isn't
already in there (I haven't used it seriously though).


> The main goal here is to be able to answer the question "where's my
> memory going?". Currently you can't really give a good answer to that
> question from userspace because of shared mappings, etc.
> 
> There are lots of secondary questions that follow on very quickly from
> that, like "what parts of my shared mappings are or aren't shared, and
> why?", "what's actually in my application's working set?" and "how much
> of this crap can I ditch?".

I understand roughly what you want, and that you can't easily get
it from /proc currently. My question at this point is just why can
we not use systemtap.

-- 
SUSE Labs, Novell Inc.
