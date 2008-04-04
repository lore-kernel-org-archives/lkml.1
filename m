Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYDDFgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYDDFgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 01:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYDDFgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 01:36:42 -0400
Received: from gw.goop.org ([64.81.55.164]:47135 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYDDFgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 01:36:41 -0400
Message-ID: <47F5BE2F.8020607@goop.org>
Date: Thu, 03 Apr 2008 22:35:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 5 of 6] hotplug-memory: add section_ops
References: <785fe0877fea0f488bc5.1207267545@localhost>	<1207270272.943.27.camel@nimitz.home.sr71.net> <20080404104706.c97956ed.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080404104706.c97956ed.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 03 Apr 2008 17:51:12 -0700
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
>
>   
>> On Thu, 2008-04-03 at 17:05 -0700, Jeremy Fitzhardinge wrote:
>>     
>>> Add a per-section "section_ops" structure,  allowing each section to have
>>> specific functions for onlining and offlining pages within the section.
>>> This is used by the Xen balloon driver to make sure that pages are not
>>> onlined without some physical memory backing them.
>>>       
>> This is kinda a lot of code and mucking around for what we actually get
>> out of it, especially since you just condensed down all the actual
>> online_page() instances.
>>
>> I think it might just be nicer to have a global list of these handlers
>> somewhere.  The Xen driver can just say "put me on the list of
>> callbacks" and we'll call them at online_page().  I really don't think
>> we need to be passing an ops structure around.
>>
>> KAME, did you have some other ideas about this?
>>
>>     
>
> At first. please don't call online_page() handler in add_memory() phase.
> online_page() handler should be called in online_pages().
>   

Yes, that's how it is at the moment.

> Passing handler to online_pages() is much easier and it's ok to me.
>   

Rather than an ops structure associated with the section?  That's a 
possibility...  I'll see how that looks...

    J
