Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbXFQRQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbXFQRQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 13:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbXFQRQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 13:16:26 -0400
Received: from mail.tmr.com ([64.65.253.246]:35445 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbXFQRQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 13:16:25 -0400
Message-ID: <46756C6E.1070106@tmr.com>
Date: Sun, 17 Jun 2007 13:16:30 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: david@lang.hm
CC: Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Sat, 16 Jun 2007, Neil Brown wrote:
>
>> It would be possible to have a 'this is not initialised' flag on the
>> array, and if that is not set, always do a reconstruct-write rather
>> than a read-modify-write.  But the first time you have an unclean
>> shutdown you are going to resync all the parity anyway (unless you
>> have a bitmap....) so you may as well resync at the start.
>>
>> And why is it such a big deal anyway?  The initial resync doesn't stop
>> you from using the array.  I guess if you wanted to put an array into
>> production instantly and couldn't afford any slowdown due to resync,
>> then you might want to skip the initial resync.... but is that really
>> likely?
>
> in my case it takes 2+ days to resync the array before I can do any 
> performance testing with it. for some reason it's only doing the 
> rebuild at ~5M/sec (even though I've increased the min and max rebuild 
> speeds and a dd to the array seems to be ~44M/sec, even during the 
> rebuild)
>
> I want to test several configurations, from a 45 disk raid6 to a 45 
> disk raid0. at 2-3 days per test (or longer, depending on the tests) 
> this becomes a very slow process.
>
I've been doing stuff like this, but I just build the array on a 
partition per drive so the init is livable. For the stuff I'm doing a 
total of 500-100GB is ample to do performance testing.
> also, when a rebuild is slow enough (and has enough of a performance 
> impact) it's not uncommon to want to operate in degraded mode just 
> long enought oget to a maintinance window and then recreate the array 
> and reload from backup.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

