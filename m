Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbXGIKMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbXGIKMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbXGIKMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:12:36 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:39720 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751315AbXGIKMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:12:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=fXA9oXSs/RK7RS8M+zVhfNG6jNTwlyoTm8l1I1C3KbyRXdvQ8ZRet3S5S3whC8l72lqCZEnw4/QgxCE1J1rtzx3fZdGxDG8SqUVz9rqZDGSI0zwI2PoJYT2t4+MfOBGFES5Qve5fklNGbJ1fW7R5FgUVP3U/l9vb5hyUMk204jw=  ;
X-YMail-OSG: 3gcGUIsVM1kwz9YjmytmAq4B5.uwq3pfgwukJ3RnFjEJ5QhyaqQwp4fPFFW.4AI5NBavs1uXZg--
Message-ID: <46920A0C.3040400@yahoo.com.au>
Date: Mon, 09 Jul 2007 20:12:28 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-mm@kvack.org, Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] Use mmu_gather for fork() instead of flush_tlb_mm()
References: <1183952874.3388.349.camel@localhost.localdomain>	 <1183962981.5961.3.camel@localhost.localdomain>	 <1183963544.5961.6.camel@localhost.localdomain>	 <4691E64F.5070506@yahoo.com.au>	 <1183972349.5961.25.camel@localhost.localdomain>	 <4691FFDC.5020808@yahoo.com.au> <1183974458.5961.42.camel@localhost.localdomain>
In-Reply-To: <1183974458.5961.42.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Mon, 2007-07-09 at 19:29 +1000, Nick Piggin wrote:
> 
>>They could just #define one to the other though, there are only a
>>small
>>number of them. Is there a downside to not making them distinct? i386
>>for example probably would just keep doing a tlb flush for fork and
>>not
>>want to worry about touching the tlb gather stuff.
> 
> 
> But the tlb gather stuff just does ... a flush_tlb_mm() on x86 :-)

But it still does the get_cpu of the mmu gather data structure and
has to look in there and touch the cacheline. You're also having to
do more work when unlocking/relocking the ptl etc.


> I really think it's the right API



-- 
SUSE Labs, Novell Inc.
