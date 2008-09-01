Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbYIARdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbYIARdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYIARcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:32:54 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:44604 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYIARcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:32:53 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=JMnnF-g5AAAA:8 a=BAc8T9eJTx2-vJsIN1IA:9 a=2vicnz_o6cpw1vCx_YUA:7 a=36qO1hOtuJwRtHGoLu_ZvZrndDYA:4
Message-ID: <48BC2746.1090006@shaw.ca>
Date: Mon, 01 Sep 2008 11:32:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Michael Noisternig <mnoist@cosy.sbg.ac.at>
CC: linux-kernel@vger.kernel.org
Subject: Re: (more) epoll troubles
References: <fa.zt4K08zThcs3bS6QJSiWmdw4amQ@ifi.uio.no> <48BC26D9.1040300@shaw.ca>
In-Reply-To: <48BC26D9.1040300@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Michael Noisternig wrote:
>> Hello,
>>
>> and sorry again if this is the wrong place to ask (again, please hint 
>> to me to an appropriate place to ask in that case).
>>
>> After experimenting with epoll edge-triggered mode I am clueless why 
>> on a few occassions I seem to not get any input notification despite 
>> data is available.
>>
>> In detail: I have set up sockets with epoll events 
>> EPOLLET|EPOLLRDHUP|EPOLLIN. When I get EPOLLIN for a socket, I read() 
>> as long as I get what I asked for, i.e. whenever read() returns either 
>> EAGAIN or less data than I asked for I take this as indication that I 
>> must wait for another EPOLLIN notification. However, this does not 
>> seem to work always.
>>
>> Here is some log from my program:
>>
>> 0x9e6b8a8: read not avail (1460/2048 read)
>> i.e. tried to read 2048 bytes, got 1460 -> assume must wait for 
>> EPOLLIN for more data to read
>> (note that the fd is always in the epoll set with 
>> EPOLLET|EPOLLRDHUP|EPOLLIN)
> 
> It would likely be better to always continue trying to read until EAGAIN 
> is returned, even if the read returned less than the requested amount, 
> as implied here:
> 
> http://linux.die.net/man/7/epoll
> 
> "The function do_use_fd() uses the new ready file descriptor until 
> EAGAIN is returned by either read(2) or write(2). An event driven state 
> machine application should, after having received EAGAIN, record its 
> current state so that at the next call to do_use_fd() it will continue 
> to read(2) or write(2) from where it stopped before. "

Though, this is somewhat contradicted by the FAQ section:

"the condition that the read/write I/O space is exhausted can be 
detected by checking the amount of data read/write from/to the target 
file descriptor. For example, if you call read(2) by asking to read a 
certain amount of data and read(2) returns a lower number of bytes, you 
can be sure to have exhausted the read I/O space for such file descriptor."
