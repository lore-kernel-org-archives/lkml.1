Return-Path: <linux-kernel-owner+w=401wt.eu-S966160AbXBPGZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966160AbXBPGZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964771AbXBPGZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:25:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:24145 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966160AbXBPGZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:25:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,180,1170662400"; 
   d="scan'208"; a="182671081:sNHT17564365"
Message-ID: <45D54E5B.9000605@intel.com>
Date: Thu, 15 Feb 2007 22:25:31 -0800
From: Auke Kok <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Len Brown <lenb@kernel.org>, "Ronciak, John" <john.ronciak@intel.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: e1000_intr in request_irq faults in 2.6.20-git
References: <m1y7mzhw7b.fsf@ebiederm.dsl.xmission.com>	<36D9DB17C6DE9E40B059440DB8D95F5201E997BA@orsmsx418.amr.corp.intel.com> <20070215220152.d137f86b.akpm@linux-foundation.org>
In-Reply-To: <20070215220152.d137f86b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Feb 2007 18:10:53 -0800 "Brandeburg, Jesse" <jesse.brandeburg@intel.com> wrote:
> 
>> @@ -1431,6 +1427,10 @@ e1000_open(struct net_device *netdev)
>>                 e1000_update_mng_vlan(adapter);
>>         }
>>
>> +       err = e1000_request_irq(adapter);
>> +       if (err)
>> +               goto err_req_irq;
>> +
>>         /* If AMT is enabled, let the firmware know that the network
>>          * interface is now open */
>>         if (adapter->hw.mac_type == e1000_82573 &&
>> @@ -1439,10 +1439,11 @@ e1000_open(struct net_device *netdev)
>>
>>         return E1000_SUCCESS;
>>
>> +err_req_irq:
>> +       e1000_down(adapter);
>> +       e1000_free_irq(adapter);
>>  err_up:
> 
> We don't want that e1000_free_irq(adapter) in the error path.


indeed, thanks for spotting and telling me before I sent this to Jeff.

Cheers,

Auke
