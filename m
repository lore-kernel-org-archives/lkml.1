Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZJUSvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZJUSvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 14:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZJUSvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 14:51:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:1473 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbZJUSvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 14:51:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,599,1249282800"; 
   d="scan'208";a="505909848"
Message-ID: <4ADF57D7.7010808@intel.com>
Date: Wed, 21 Oct 2009 11:49:59 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081103)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       "discuss@LessWatts.org" <discuss@LessWatts.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Corey Minyard <minyard@acm.org>
Subject: Re: [Discuss] [PATCH] ipmi: use round_jiffies on timers to reduce
 timer overhead/wakeups
References: <20091021102822.5b32b2dc.randy.dunlap@oracle.com> <20091021114210.4d7e1ea9@linux.intel.com>
In-Reply-To: <20091021114210.4d7e1ea9@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 21 Oct 2009 10:28:22 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Use a round_jiffies() variant to reduce overhead of timer
>> wakeups.  This causes the ipmi timers to occur at the same
>> time as other timers (per CPU).
>>
>> Typical powertop for /ipmi/ (2.6.31, before patch):
>>   11.4% (247.4)            kipmi0 : __mod_timer (process_timeout) 
>>    0.6% ( 13.1)       <interrupt> : ipmi_si 
>>    0.5% ( 10.0)     <kernel core> : __mod_timer (ipmi_timeout) 
>>
>> powertop for /ipmi/, 2.6.31, after patch:
>>   10.8% (247.6)            kipmi0 : __mod_timer (process_timeout) 
>>    0.3% (  6.9)       <interrupt> : ipmi_si 
>>    0.0% (  1.0)     <kernel core> : __mod_timer (ipmi_timeout)
> 
> while it is nice that ipmi_si ande the timer wake up less now.... it's
> still rather sad that the 247.6 from kipmi0 are still there..... those
> are a much much bigger issue

obviously :)

Randy, any idea where those are coming from ?

Auke


