Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYKXPzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYKXPzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYKXPzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:55:21 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:57351 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYKXPzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:55:19 -0500
Message-ID: <492ACE5E.9020601@fr.ibm.com>
Date: Mon, 24 Nov 2008 16:55:10 +0100
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Linux Containers <containers@lists.osdl.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: [patch 1/1][RFC]Handle uevent per namespace
References: <492A86FA.5080804@fr.ibm.com> <20081124153138.GA16742@kroah.com>
In-Reply-To: <20081124153138.GA16742@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Nov 24, 2008 at 11:50:34AM +0100, Daniel Lezcano wrote:
> 
>> Subject: Handle uevent per namespace
>> From: Daniel Lezcano <dlezcano@fr.ibm.com>
>>
>> At present when a network device is destroyed, inside a network
>> namespace, and this device has the same name as one network device
>> belonging to the initial network namespace (eg. eth0), the udev daemon
>> will disable the interface in the initial network namespace.
>>
>> IMHO, udev should not receive this event. The uevents should be per
>> namespace or at least do not send events when not for the initial
>> network namespace.
> 
> IMHO, network namespaces are a mess and not something that you should be
> doing at all :)
> 
>> The following patch is a RFC for making uevent namespace aware. I don't
>> know this part of the kernel code, so I am pretty sure t is not the 
>> right way to do that :) 
> 
> Like Kay said, please don't change the kobject core for this, try just
> filtering in the network core the events that you handle there.

Oh, why I didn't think about that :)
That will be a cleaner and a smaller patch.

Thanks.
   -- Daniel
