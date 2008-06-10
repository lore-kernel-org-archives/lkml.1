Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYFJH4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYFJH4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 03:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYFJH4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 03:56:09 -0400
Received: from sacred.ru ([62.205.161.221]:59228 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYFJH4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 03:56:08 -0400
Message-ID: <484E32B9.4020606@openvz.org>
Date: Tue, 10 Jun 2008 11:52:25 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>
CC: balbir@linux.vnet.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, menage@google.com,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [RFC PATCH 0/5] memcg: VM overcommit accounting and handling
References: <1213054383-18137-1-git-send-email-righi.andrea@gmail.com> <20080610091439.04061da9.kamezawa.hiroyu@jp.fujitsu.com> <484E0D73.6010609@linux.vnet.ibm.com>
In-Reply-To: <484E0D73.6010609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 10 Jun 2008 11:54:43 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> KAMEZAWA Hiroyuki wrote:
>> On Tue, 10 Jun 2008 01:32:58 +0200
>> Andrea Righi <righi.andrea@gmail.com> wrote:
>>
>>> Provide distinct cgroup VM overcommit accounting and handling using the memory
>>> resource controller.
>>>
>> Could you explain the benefits of this even when we have memrlimit controller ?
>> (If unsure, see 2.6.26-rc5-mm1 and search memrlimit controller.)
>>
>> And this kind of virtual-address-handling things should be implemented on
>> memrlimit controller (means not on memory-resource-controller.).
>> It seems this patch doesn't need to handle page_group.
>>
>> Considering hierarchy, putting several kinds of features on one controller is
>> not good, I think. Balbir, how do you think ?
>>
> 
> I would tend to agree. With the memrlimit controller, can't we do this in user
> space now? Figure out the overcommit value and based on that setup the memrlimit?

I also agree with Balbir and Kamezawa. Separate controller for VM (i.e. vma-s
lengths) is more preferable, rather than yet another fancy feature on top of 
the existing rss one.

