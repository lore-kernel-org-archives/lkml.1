Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbYJ0F71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbYJ0F71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 01:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYJ0F7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 01:59:20 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52157 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYJ0F7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 01:59:19 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=on-23RBEH8nnzte631QA:9 a=TCRj7waNdQnNcGSRPu8A:7 a=tzqT29qXEnQgh2qqGafAhshjVdYA:4 a=64-k_xsDSSYA:10 a=Wwgkb0oGCWUA:10
Message-ID: <490558B5.1060105@shaw.ca>
Date: Sun, 26 Oct 2008 23:59:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: ppak_98@yahoo.com
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: unexpected extra pollout events from epoll
References: <fa.iE6LeMsZ2b+Y7nnAUJEFSvwEiiU@ifi.uio.no> <fa.KeDEgbYh8k5LzzH6uv7u00N5twU@ifi.uio.no>
In-Reply-To: <fa.KeDEgbYh8k5LzzH6uv7u00N5twU@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul P wrote:
>> Which version of epoll do you have? The epoll_wait()
>> function does not 
>> accept an event mask (like you write above,
>> EPOLLIN|EPOLLOUT). 
> 
> lol, I was a bit tired when I wrote that.  Ok, ignore the stuff related 
> to epoll_wait in my previous post.
>  
>> As optimization, if the EPOLLOUT bit is already set, you
>> don't need to 
>> keep calling epoll_ctl(fd,MOD,EPOLLOUT).
> 
> This is good to know.
> 
> So, I've got a few questions about what happens to data that accumulates 
> while I am sending and the fd is set to EPOLLOUT?  If I am send out a 
> large buffer and incoming data wants to stream in on a full duplex 
> connection, what happens to that data when I am processing the socket 
> while it is in epollout mode?  
> 
> Is the following accurate?  When data comes in while I am sending, I guess 
> the data fills up the receive buffers until they are full and then it 
> stops accepting data until it is cleared out?  When I switch back to 
> EPOLLIN, I'm guessing that I will get a notification on that fd that there 
> is data waiting.
> 
> The other question I have is there a way to do full-duplex networking so 
> that I can receive network messages while I am sending or vice versa?  It 
> seems that the method of switching the socket between EPOLLIN and EPOLLOUT 
> means that I can't do both operations simultaneously.  Thanks

I don't quite follow. You shouldn't be switching back and forth if 
you're trying to both send and receive, you can be registered for both 
notifications at the same time and respond to whatever notifications 
that you get. If you're not trying to write anything at the moment then 
you shouldn't be registered for EPOLLOUT though, same for reading and 
EPOLLIN.
