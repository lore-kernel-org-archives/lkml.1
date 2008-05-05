Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYEEIpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYEEIpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbYEEIpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:45:15 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58312 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbYEEIpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:45:13 -0400
Message-ID: <481EC917.6070808@bull.net>
Date: Mon, 05 May 2008 10:45:11 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       containers@lists.linux-foundation.org, matthltc@us.ibm.com,
       cmm@us.ibm.com
Subject: Re: [PATCH 1/8] Scaling msgmni to the amount of lowmem
References: <20080211141646.948191000@bull.net>	 <20080211141813.354484000@bull.net> <12c511ca0804291328v2f0b87csd0f2cf3accc6ad00@mail.gmail.com>
In-Reply-To: <12c511ca0804291328v2f0b87csd0f2cf3accc6ad00@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck wrote:
> On Mon, Feb 11, 2008 at 7:16 AM,  <Nadia.Derbey@bull.net> wrote:
> 
>> Index: linux-2.6.24-mm1/ipc/msg.c
>> ===================================================================
>> --- linux-2.6.24-mm1.orig/ipc/msg.c     2008-02-07 15:02:29.000000000 +0100
>> +++ linux-2.6.24-mm1/ipc/msg.c  2008-02-07 15:24:19.000000000 +0100
> 
> ...
> 
>> +out_callback:
>> +
>> +       printk(KERN_INFO "msgmni has been set to %d for ipc namespace %p\n",
>> +               ns->msg_ctlmni, ns);
>> +}
> 
> 
> This patch has now made its way to mainline.  I can see how this printk
> was really useful to you while developing this patch. But does it add
> much value in a production system? It just looks like another piece of
> clutter on the console to my uncontainerized eyes.
> 
> -Tony
> 
> 


Well, this printk had been suggested by somebody (sorry I don't remember 
who) when I first submitted the patch. Actually I think it might be 
useful for a sysadmin to be aware of a change in the msgmni value: we 
have the message not only at boot time, but also each time msgmni is 
recomputed because of a change in the amount of memory.
Also, at boot time, I think it's interesting to have the actual msgmni 
value: it used to unconditionally be set to 16. Some applications that 
used to need an initialization script setting msgmni to a higher value 
might not need that script anymore, since the new value might fit their 
needs.

Regards,
Nadia
