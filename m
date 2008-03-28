Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYC1SUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYC1SUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYC1STw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:19:52 -0400
Received: from gw.goop.org ([64.81.55.164]:47037 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757650AbYC1STv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:19:51 -0400
Message-ID: <47ED36AC.9000807@goop.org>
Date: Fri, 28 Mar 2008 11:19:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned memory
 is bad
References: <e0b16cc8349b38a5f3f9.1206664118@localhost>	<20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>	<20080328102342.B0BF.E1E9C6FF@jp.fujitsu.com>	<20080328105406.5dc61c6c.kamezawa.hiroyu@jp.fujitsu.com>	<47EC5440.5020107@goop.org>	<20080328113312.65cca8b5.kamezawa.hiroyu@jp.fujitsu.com>	<47EC5D2E.8060001@goop.org>	<20080328121758.7f355925.kamezawa.hiroyu@jp.fujitsu.com>	<47EC7202.3040009@goop.org> <20080328133940.dc3be13d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080328133940.dc3be13d.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
>> What would happen if I did online_pages(pfn, 1) on each page as I 
>> populate it?
>>
>>     
> I think (hope) it works well. But it seems no one tries to do that.

Well I had immediate problems because I try to use it under spinlock and 
it calls online_pages -> build_all_zonelists -> stop_machine_run.  I can 
easily rearrange to fix that, but it seems to me that stop_machine_run() 
is probably too expensive to call thousands of times (one for each page, 
rather than once per section).

I'm just looking at how I can refactor online_pages() into a function 
which does the general zone setup stuff, and one for actually onlining 
pages.  The function of online_pages() would remain unchanged for 
existing users, but I could call the pieces separately at the 
appropriate times.

    J
