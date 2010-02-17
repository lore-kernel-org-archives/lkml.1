Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0BQSBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:01:44 -0500
Received: from oxalide-out.extra.cea.fr ([132.168.224.1]:43285 "EHLO
	oxalide-out.extra.cea.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab0BQSBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:01:42 -0500
X-Greylist: delayed 1789 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Feb 2010 13:01:42 EST
Message-ID: <4B7C25B3.5010206@cea.fr>
Date: Wed, 17 Feb 2010 18:21:55 +0100
From: THIELL Stephane <stephane.thiell@cea.fr>
Organization: CEA-DAM
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch/rfc] Make poll/select report error (POLLNVAL and EBADF)
 for unsupported files
References: <alpine.DEB.2.00.1002141403240.18795@makko.or.mcafeemobile.com> <1266255759.8262.26.camel@edumazet-laptop> <alpine.DEB.2.00.1002150945460.7390@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.1002150945460.7390@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2010 17:21:55.0657 (UTC) FILETIME=[B4147B90:01CAAFF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Mon, 15 Feb 2010, Eric Dumazet wrote:
>
>   
>> Hmm, according to POSIX :
>>
>> 	The poll() function shall support regular files, terminal and
>> pseudo-terminal devices, FIFOs, pipes, sockets ...
>>
>> 	Regular files shall always poll TRUE for reading and writing.
>>
>>     
As POSIX says poll(2) have to support regular files (and it seems all 
possible user file descriptors), then wouldn't it be better/more 
coherent to have epoll(7) behave the same way (ie. support regular files 
instead of epoll_ctl(2) returning EPERM), in order to allow generic code 
handling both very common situations like:

$ cat replay_file | application
and
$ application < replay_file

...where for instance the application doesn't know the origine of its fd 0 (pipe, file, or something else).

Regards,
Stephane Thiell




