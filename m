Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbYLGQEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbYLGQEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 11:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYLGQEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 11:04:36 -0500
Received: from stinky.trash.net ([213.144.137.162]:43893 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbYLGQEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 11:04:35 -0500
Message-ID: <493BF40F.6050307@trash.net>
Date: Sun, 07 Dec 2008 17:04:31 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: m m <olsajiri@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: netlink - notify when the socket gets closed
References: <35476bd20812050017y70c3c729v450cdc3d0c1188de@mail.gmail.com>	 <20081205195624.95ea1866.akpm@linux-foundation.org>	 <493A92FD.3060302@trash.net> <35476bd20812061010g145b6c19r282ae32a4ebfabb1@mail.gmail.com>
In-Reply-To: <35476bd20812061010g145b6c19r282ae32a4ebfabb1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m m wrote:
> On Sat, Dec 6, 2008 at 3:58 PM, Patrick McHardy <kaber@trash.net> wrote:
>> That doesn't make sense. When you use multicast, multiple applications
>> can be listening to the messages. If you really need state for a single
>> listener and exchange messages in both directions, it sounds like you
>> should use unicast.
>>
>>
> My user app register in kernel for a data. When there is a first
> application request,
> kernel module creates an internal record and ask DATA subsystem for a data,
> which are then passed to the user application.
> 
> The data are then delivered to the application as they are comming from
> the DATA subsystem.
> 
> When there's another application requesting the same data type, kernel module
> just increase reference count in the internal record, and multicast delivers
> data to the other app.
> 
> Now when one of those applications end, kernel module just decrease
> the reference count in the internal record.
> 
> When the other application ends, kernel module needs to release the internal
> record and ask the DATA subsystem to stop delivering data.
> 
> Hope this make sense... I could do some ascii art next time if needed :)

Thats an unusual way to use netlink, but it sounds reasonable.

Adding a notifier for multicast unsubscriptions should be easy.
Nothing in the kernel needs it though, so you need to carry the
patch to do this yourself until you submit your module.
