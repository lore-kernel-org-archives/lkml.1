Return-Path: <linux-kernel-owner+w=401wt.eu-S1161659AbXDXLcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161659AbXDXLcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 07:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161707AbXDXLcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 07:32:43 -0400
Received: from amhost.net ([216.32.88.10]:41396 "EHLO ldic83.amhost.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161659AbXDXLcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 07:32:42 -0400
Date: Tue, 24 Apr 2007 14:33:48 +0400
From: Alex Vorona <voron@amhost.net>
Reply-To: Alex Vorona <voron@amhost.net>
Organization: amhost.net
X-Priority: 3 (Normal)
Message-ID: <1211570752.20070424143348@amhost.net>
To: linux-kernel@vger.kernel.org
Subject: Re[2]: sendfile to nonblocking socket
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKIEDFDEAC.davids@webmaster.com>
References: <462D8D92.9050301@amhost.net>
 <MDEHLPKNGKAHNMBLJOLKIEDFDEAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

Tuesday, April 24, 2007, 1:19:49 PM, you wrote:

>> sendfile function is not just a more efficient version of a read 
>> followed by a write.  It reads from one fd and write to another at tha
>> same time. Please try to read 2G, and then write 2G - and how much 
>> memory you will be need and how much time you will loose while reading
>> 2G from disk, but not writing them to socket.

DS> You are correct. What I meant to say was that it's just a
DS> more efficient version of 'mmap'ing a file and then 'write'ing
DS> from the 'mmap'. The 'write' to a non-blocking socket can still
DS> 'block' on disk I/O.

How can I avoid that blocking? Or maybe another question - how can I
deliver data from disk to network with minimal copy operations, etc.

>> If you know more 
>> efficient method to transfer file from disk to network - please advise.
>> Now all I want is really non-blocking sendfile. Currently sendfile is
>> non-blocking on network, but not on disk i/o. And when I have network
>> faster than disk - I get block.

DS> There are many different techniques and which is correct
DS> depends on what direction you want to go.
_very_ fast frontend web-server :) using as much kernel features as possible
DS> POSIX asynchronous I/O is one possibility.
aio does not support direct transfer file->socket. Using some hints,
like aio reading into shared memory and then sendfile from shared
memory, like lighttpd does, is not what I want. My tests showing
that aio-sendfile realization in lighttpd is slower than sendfile.
I think, sendfile uses less copy operations(maybe even zerocopy), than current aio
realizations in kernel.
DS> Threads plus epoll is another.
20k threads and maybe more is too much :). Look at http://nginx.net/
senction "Architecture and scalability" for example.
DS> It really depends upon how much performance you need
all, that hardware can take and hold :)

-- 
Best regards,
 Alex                            mailto:voron@amhost.net

