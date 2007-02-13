Return-Path: <linux-kernel-owner+w=401wt.eu-S1030606AbXBMETT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030606AbXBMETT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 23:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030636AbXBMETT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 23:19:19 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:37393 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030606AbXBMETS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 23:19:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=u27tYU3Z/kuGIlNK6hd5oxAGogVYoIFko+bIMT8V6uJd94f4m5I/TkvANZu8BE6mr1w4eeABI2LLhKgLGwlodW+eH4Z92xouANfvOtMp2YYQekYEUhh2WWmeeyfkEztCsPWImJNSqjds8BxLah8lqUBkSLE0w1kKxMgpMZWG6vs=  ;
X-YMail-OSG: c2GMrwwVM1mmi31S_93fg7j3VNBcslBIOql0YXneQR0Nqn9S.aJZ1dc0sPLOOhCD9gehJOrkq78MTqxwyBHAGTUfklWbqgnJ8pKWANOKiucK.c3.W9dvmxIdvawMX6PCbOPNHE8EUh3NA8Y-
Message-ID: <45D13C34.2040400@yahoo.com.au>
Date: Tue, 13 Feb 2007 15:19:00 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Ben Nizette <ben.nizette@iinet.net.au>, linux-kernel@vger.kernel.org
Subject: Re: Coding style RFC: convert "for (i=0;i<ARRAY_SIZE(array);i++)"
 to "array_for_each(index, array)"
References: <1171324070.1528.25.camel@localhost>	 <45D10460.6000903@iinet.net.au> <1171327648.1528.30.camel@localhost>
In-Reply-To: <1171327648.1528.30.camel@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Tue, 2007-02-13 at 11:20 +1100, Ben Nizette wrote:
> 
>>  #define array_for_each(element, array) \
>>	for (int __idx = 0; __idx < ARRAY_SIZE((array)); \
>>		__idx++, (element) = &(array[__idx]))
> 
> 
> This requires all interior loop code be changed.

Ben is right though. Making this thing confusing to use is going
to be worse than sticking with the very simple and unconfusing
loops.

If you really wanted to introduce your loop, then please call it
array_for_each_idx, or something to distinguish it.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
