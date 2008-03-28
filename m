Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbYC1Vax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbYC1Vax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbYC1Vap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:30:45 -0400
Received: from gw.goop.org ([64.81.55.164]:35183 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbYC1Vao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:30:44 -0400
Message-ID: <47ED6368.3070708@goop.org>
Date: Fri, 28 Mar 2008 14:30:16 -0700
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
References: <e0b16cc8349b38a5f3f9.1206664118@localhost>	<20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>	<20080328102342.B0BF.E1E9C6FF@jp.fujitsu.com>	<20080328105406.5dc61c6c.kamezawa.hiroyu@jp.fujitsu.com>	<47EC5440.5020107@goop.org> <20080328113312.65cca8b5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080328113312.65cca8b5.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> For example, mem_notify() in online_pages() will be called several times against
> a section.
>   

It seems the only in-tree user of the notifier is mm/slub.c, and it only 
cares about MEM_GOING_ONLINE, GOING_OFFLINE, OFFLINE and CANCEL_ONLINE 
(not ONLINE or CANCEL_OFFLINE).

Also,

	if (onlined_pages)
		memory_notify(MEM_ONLINE, &arg);

doesn't seem correct, because arg.nr_pages still has the original 
nr_pages, and not the number of pages actually onlined (onlined_pages).  
Also arg.start_pfn isn't terribly meaningful if a discontiguous set of 
pages can be actually onlined.

    J
