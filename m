Return-Path: <linux-kernel-owner+w=401wt.eu-S965381AbXAZMAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965381AbXAZMAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 07:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965386AbXAZMAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 07:00:22 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:24485 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965381AbXAZMAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 07:00:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ETfsLRGOU1Iya3wWaZfufH6Ep/YS51KTTRrPeZQRLLrGSNZZQ1seboZ0W4RGgbRNuIuAzaRt1E338VJYYcg3lGZG4fNDoZjSLJUpJBomQ1jkjin0KDHRZGMPknqUkuD7miYneVSkA7X8xJrt3wyfGDucON2lp/MBPRk/yXLOihM=  ;
X-YMail-OSG: t_o1sA4VM1n8TkXSRGcXajhXcXFznaK19nZCnU0C7GSkXssTI1E9mbLvIAQ0omIv6IP5uJenStk64sjOMR6Wzsz_tCYp.4bUXuK1Fko0ArQDqfDXWmo-
Message-ID: <45B9ED45.5090002@yahoo.com.au>
Date: Fri, 26 Jan 2007 23:00:05 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Track mlock()ed pages
References: <Pine.LNX.4.64.0701252141570.10629@schroedinger.engr.sgi.com>	<45B9A00C.4040701@yahoo.com.au>	<Pine.LNX.4.64.0701252234490.11230@schroedinger.engr.sgi.com> <20070126031300.59f75b06.akpm@osdl.org>
In-Reply-To: <20070126031300.59f75b06.akpm@osdl.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 25 Jan 2007 22:36:17 -0800 (PST)
> Christoph Lameter <clameter@sgi.com> wrote:
> 

>>>I can't think of an easy way to do this without per-page state. ie.
>>>another page flag.
>>
>>Thats what I am trying to avoid.
> 
> 
> You could perhaps go for a walk across all the other vmas which presently
> map this page.  If any of them have VM_LOCKED, don't increment the counter.
> Similar on removal: only decrement the counter when the final mlocked VMA
> is dropping the pte.

Can't do with un-racily because you can't get that information
atomically, AFAIKS. When / if we ever lock the page in fault handler,
this could become easier... but that seems nasty to do in fault path,
even if only for VM_LOCKED vmas.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
