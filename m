Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYL1SSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYL1SSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 13:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYL1SRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 13:17:55 -0500
Received: from main.gmane.org ([80.91.229.2]:45754 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbYL1SRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 13:17:54 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [0/7] Distributed storage release.
Date: Sun, 28 Dec 2008 13:17:40 -0500
Message-ID: <4957C2C4.5080007@tmr.com>
References: <1230292576-23963-1-git-send-email-zbr@ioremap.net> <20081226191701.GA1761@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: netdev@vger.kernel.org
X-Gmane-NNTP-Posting-Host: pool-68-236-142-151.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 pango-text SeaMonkey/1.1.14
In-Reply-To: <20081226191701.GA1761@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Fri 2008-12-26 14:56:09, Evgeniy Polyakov wrote:
>> Hi.
>>
>> This is a maintenance distributed storage release, which includes a
>> rebase against the 2.6.28 kernel tree only.
>>
>> DST is a network block device storage, which can be used to organize
>> exported storages on the remote nodes into the local block device.
>>
>> Its main goal of the project is to allow creation of the block devices
>> on top of different network media and connect physically distributed devices
>> into single storage using existing network infrastructure and not
>> introducing new limitations into the protocol and network usage model.
> 
> So it is basically nbd on steroids?
> 
> ...reminds me, nbd-server should really fsync data before returning success...
> 									Pavel
> 
If you really want reliable operation without killing performance on the server 
you could use aio and just wait until the data is written to the device. Lots of 
discussion of this in various places, "on the device" may not mean on the 
platter, then you talk disabling write cache, barriers, etc. At least aio should 
(a) be more reliable than just issuing the i/o and (b) not impact the 
performance of the server as fsync would.

Comments welcome, pointers to a benchmark even more so, now I'm curious.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

