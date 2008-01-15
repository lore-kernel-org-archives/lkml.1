Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbYAOPcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbYAOPcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 10:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYAOPcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 10:32:04 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40275 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYAOPcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:32:02 -0500
Message-ID: <478CD18B.9050705@bull.net>
Date: Tue, 15 Jan 2008 16:30:19 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: containers@lists.osdl.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] [RESEND] Change default MSGMNI tunable to scale
 with lowmem
References: <478CCEA3.5050404@bull.net>
In-Reply-To: <478CCEA3.5050404@bull.net>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/01/2008 16:40:21,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/01/2008 16:40:22,
	Serialize complete at 15/01/2008 16:40:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with the right address for the containers mailing list.
So sorry...


Nadia Derbey wrote:
> Hi,
> 
> Yesterday, I posted to lkml a series of patches that make the ipc 
> tunable msgmni scale with lowmem (see thread 
> http://lkml.org/lkml/2008/1/14/196).
> 
> Since these patches watch for memory hotplug notifications, I thought 
> that comments from linux-mm people would be interesting.
> 
> Also, since these patches change the ipc_namespace structure, comments 
> from people subscribed at the containers mailing list would be welcome too.
> 
> Notes:
> 1) please, Cc me since I'm not subscribed to linux-mm.
> 2) sorry for lkml subsribers who are receiving this mail for the 2nd 
> time, but I wanted all the comments to be shared.
> 
> 
> Here is patch 0, the complete series can be found in the thread 
> mentioned above.
> 
> -----------------
> 
> On large systems we'd like to allow a larger number of message queues. 
> In some cases up to 32K. However simply setting MSGMNI to a larger value 
> may cause problems for smaller systems.
> 
> The first patch of this series introduces a default maximum number of 
> message queue ids that scales with the amount of lowmem.
> 
> Since msgmni is per namespace and there is no amount of memory dedicated 
> to each namespace so far, the second patch of this series scales msgmni 
> to the number of ipc namespaces.
> 
> In the last patch, a notifier block is added to the ipc namespace 
> structure to manage memory hotplug. The callback routine is activated 
> upon memory add/remove and it recomputes msgmni. One callback routine is 
> added to the memory notifier chain each time an ipc namespace is 
> allocated. It is removed when the coresponding ipc namespace is freed.
> 
> I still have 1 issue that I'll try to solve next:
>   . use the notification mechanism to recompute all the msg_ctlmni each
>     time an ipc namespace is created / removed.
> 
> 
> These patches should be applied to 2.6.24-rc7, in the following order:
> 
> [PATCH 1/4]: ipc_scale_msgmni_with_lowmem.patch
> [PATCH 2/4]: ipc_scale_msgmni_with_namespaces.patch
> [PATCH 3/4]: ipc_slab_memory_callback_prio_to_const.patch
> [PATCH 4/4]: ipc_recompute_msgmni_on_memory_hotplug.patch
> 
> 
> Regards,
> Nadia
> 



