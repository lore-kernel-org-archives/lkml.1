Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYC2FtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYC2FtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 01:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYC2Fsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 01:48:52 -0400
Received: from gw.goop.org ([64.81.55.164]:33314 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYC2Fsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 01:48:51 -0400
Message-ID: <47EDD825.20501@goop.org>
Date: Fri, 28 Mar 2008 22:48:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
 zone growth from page onlining
References: <47ED8685.9040409@goop.org> <20080329133820.e692245d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080329133820.e692245d.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Hi,
>
> On Fri, 28 Mar 2008 17:00:05 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> -	if (onlined_pages)
>> +	if (onlined_pages) {
>> +		struct memory_notify arg;
>> +
>> +		arg.start_pfn = pfn;  /* ? */
>> +		arg.nr_pages = onlined_pages;
>> +		arg.status_change_nid = -1;  /* ? */
>> +
>>  		memory_notify(MEM_ONLINE, &arg);
>> +	}
>>     
> I think you should add "onlined" member instead of reusing nr_pages.
>   

I suppose.  What would I put into nr_pages?  And anyway, there are no 
users for this notification...

> But, in general, I have no objection to this way.
>   

The refactoring in general?

    J
