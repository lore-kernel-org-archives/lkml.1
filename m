Return-Path: <linux-kernel-owner+w=401wt.eu-S965506AbXCATKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965506AbXCATKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965513AbXCATKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:10:44 -0500
Received: from densedata.com ([217.160.171.7]:3360 "EHLO densedata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965506AbXCATKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:10:44 -0500
X-Greylist: delayed 8867 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 14:10:43 EST
Message-ID: <45E7287D.7000104@densedata.com>
Date: Thu, 01 Mar 2007 20:24:45 +0100
From: Johann Borck <johann.borck@densedata.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
References: <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188 <20070301081808.GD7217@2ka.mipt.ru>
In-Reply-To: <20070301081808.GD7217@2ka.mipt.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 04:41:27PM +0100, Eric Dumazet wrote:
>> 
>> I had to loop on accept() :
>> 
>>         for (i=0; i<num; ++i) {
>>                 if (event[i].data.fd == main_server_s) {
>>                         do {
>>                                 err = evtest_callback_main(event[i].data.fd);
>>                                 } while (err != -1);
>>                         }
>>                 else
>>                         err = evtest_callback_client(event[i].data.fd);
>>         }
>> 
>> Or else we can miss an event forever...
On Thu, 1 Mar 2007, Evgeniy Polyakov wrote:
>
> The same here - I would just enable a debug to find it.
>


I reported this a while ago and suggested to have the number of 
pending accepts reported with the event to save that last syscall.
I  created an ab replacement based on kevent, and at least with my 
machines, which are comparable to each other, the load on client 
dropped from 100% to 2% or something. ab just doesn't give meaningful 
results  (if the client is not way more powerful). With that new client 
I get very similar results for epoll and kevent, from 1000 through to 
26000 concurrent requests, the results have been posted on 
kevent-homepage in october, I just checked it with new version, but 
there's no significant difference.

this is the benchmark with kevent-based client:
http://tservice.net.ru/~s0mbre/blog/2006/10/11#2006_10_11
btw, each result is average over 1,000,000 requests

and just for comparison, this is on the same machines using ab:
http://tservice.net.ru/~s0mbre/blog/2006/10/08#2006_10_08

