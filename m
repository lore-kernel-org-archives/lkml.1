Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbXGYDpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbXGYDpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 23:45:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbXGYDow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 23:44:52 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:37441 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755994AbXGYDow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 23:44:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=IPwB1/bHMJSB7RlcIgCvoQ1ijUKVe8DLhcD/3eLrDr9vm+zANftmBk5b5zC3m+g7FD5CaNwhGRt4Zs02GL8LOrsrdnHvecq9WGA1T/JjeAgYC30xYXtpN1lCVgL9cWxbHCx8mC/LTFdxnTg+5EzJq7r0EEh2OjQ8L0/cF2/fGpo=  ;
X-YMail-OSG: GkPcvu8VM1mD1Mby7oqErVcVd8JY9xSJKVd8ZaipnxW6s_mZ
Message-ID: <46A6C72A.9020801@yahoo.com.au>
Date: Wed, 25 Jul 2007 13:44:42 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Bret Towe <magnade@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: mm: fix fault vs invalidate race for linear
 mappings
References: <dda83e780707241027k369c2f01j6d16b21266df3a05@mail.gmail.com>
In-Reply-To: <dda83e780707241027k369c2f01j6d16b21266df3a05@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bret Towe wrote:
> for a while in -git I've had an issue that on boot when gdm loads the
> screen stays black
> using ctrl-f1 doesn't return to a console and killing X doesn't help any
> ssh'ing into the box does work top only shows 100% io-wait
> dmesg shows nothing odd
> 
> the work around I have is at the moment is to just move the radeon drm 
> module
> out of the way so it doesn't load on boot and X works just fine like that
> I did some bisecting which took a few days and tracked it down to
> commit d00806b183152af6d24f46f0c33f14162ca1262a
> 
> its way to complex for me to revert it on top of -rc1 to verify that's
> the issue tho
> I keep forgetting to get a trace of what its waiting on when I'm in that 
> kernel
> I assume that would be of use and Ill get that later
> 
> the box this is happening on is a g4 mac mini the built in card is a 
> radeon 9200
> I'm not seeing any issues on an amd64 box with radeon card it's also a 
> 9600 tho

Is this with a binary-only module? We saw an issue with that in SLES9
where the module is returning a locked page from its nopage handler
when it isn't really supposed to. It might be fixed in latest drivers,
have you tried them?

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
