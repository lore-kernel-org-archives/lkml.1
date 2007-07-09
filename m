Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbXGIJ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbXGIJ3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbXGIJ3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:29:06 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:26541 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755414AbXGIJ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:29:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Z/Tjz3W6hj/wUHH6/qIsdBKr35uUtDKc0C1LvmUa3lPanW9L+R7/CJuLk8okLy2eczvHvK0UnqlcSKZRFxlrQGMwokg+bZ+nSo1kx7ORybOS1KGOmnCPDOtDnKb6R8nlTLEDxZ4PjdcLY5pAg43plDiRQrPGvqoWkMdwE7vdb80=  ;
X-YMail-OSG: Rb5oIHwVM1m.G21RUZxXDUbdcXnBycK8tRAAGAos2YpO1Uul3tnAUO7LZyVo8OlDF.7kY4BS6g--
Message-ID: <4691FFDC.5020808@yahoo.com.au>
Date: Mon, 09 Jul 2007 19:29:00 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-mm@kvack.org, Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] Use mmu_gather for fork() instead of flush_tlb_mm()
References: <1183952874.3388.349.camel@localhost.localdomain>	 <1183962981.5961.3.camel@localhost.localdomain>	 <1183963544.5961.6.camel@localhost.localdomain>	 <4691E64F.5070506@yahoo.com.au> <1183972349.5961.25.camel@localhost.localdomain>
In-Reply-To: <1183972349.5961.25.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Mon, 2007-07-09 at 17:39 +1000, Nick Piggin wrote:
> 
> 
>>Would it be better off to start off with a new API for this? The
>>mmu gather I think is traditionally entirely for dealing with
>>page removal...
> 
> 
> It would be weird because the new API would mostly duplicate this one,
> and we would end up with duplicated hooks..

They could just #define one to the other though, there are only a small
number of them. Is there a downside to not making them distinct? i386
for example probably would just keep doing a tlb flush for fork and not
want to worry about touching the tlb gather stuff.

-- 
SUSE Labs, Novell Inc.
