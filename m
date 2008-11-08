Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYKHCqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYKHCqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 21:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYKHCqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 21:46:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34049 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYKHCqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 21:46:19 -0500
Message-ID: <38971.10.75.179.62.1226112376.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <31630.10.75.179.62.1226111079.squirrel@webmail-b.css.fujitsu.com>
References: <1226096940.8805.4.camel@badari-desktop>
    <31630.10.75.179.62.1226111079.squirrel@webmail-b.css.fujitsu.com>
Date: Sat, 8 Nov 2008 11:46:16 +0900 (JST)
Subject: Re: 2.6.28-rc3 mem_cgroup panic
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Badari Pulavarty" <pbadari@us.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>, "linux-mm" <linux-mm@kvack.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki said:
> Badari Pulavarty said:
>> Hi Balbir,
>>
>> I was running memory remove/add tests in a continuous loop.
>> I get following panic in mem_cgroup migration code.
>>
>> Is this a known issue ?
>>
> No, this is new one. We don't see panic in cpuset based migration..so..
> Maybe related to page_cgroup allocation/free code in memory hotplug
> notifier.
>
> Thank you for report. I'll try this.
>
Hmm...at quick look...

online/offline page_cgroup's calculation for "start" is buggy..

-start = start_pfn & (PAGES_PER_SECTION - 1);
+start = start_pfn & ~(PAGES_PER_SECTION - 1);

I'm sorry I can't write patch today.

Regards,
-Kame

