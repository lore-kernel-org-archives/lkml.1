Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYAOJoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYAOJoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYAOJoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:44:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58653 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYAOJo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:44:29 -0500
Date: Tue, 15 Jan 2008 18:40:52 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Subject: Re: [RFC PATCH 4/4] [RESEND] Recomputing msgmni on memory add / remove
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       matthltc@us.ibm.com
In-Reply-To: <478C76D4.3010700@bull.net>
References: <20080115164440.6DBB.Y-GOTO@jp.fujitsu.com> <478C76D4.3010700@bull.net>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080115182402.6DBD.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yasunori Goto wrote:
> > Hello Nadia-san.
> > 
> > 
> >>@@ -118,6 +122,10 @@ struct ipc_namespace {
> >> 	size_t		shm_ctlall;
> >> 	int		shm_ctlmni;
> >> 	int		shm_tot;
> >>+
> >>+#ifdef CONFIG_MEMORY_HOTPLUG
> >>+	struct notifier_block ipc_memory_hotplug;
> >>+#endif
> >> };
> > 
> > 
> > I'm sorry, but I don't see why each ipc namespace must have each callbacks
> > of memory hotplug.
> > I prefer only one callback for each subsystem, not for each namespace.
> > In addition, the recompute_msgmni() calculation looks very similar for
> > all ipc namespace.
> > Or do you wish each ipc namespace have different callback for the future?
> > 
> 
> Actually, this is what I wanted to do at the very beginning: have a 
> single callback that would recompute the msgmni for each ipc namespace. 
> But the issue here is that the namespaces are not linked to each other, 
> so I had no simple way to go through all the namespaces.
> I solved the issue by having a callback for any single ipc namespace and 
> make it recompute the msgmni value for itslef.

The recompute_msg() must be called when new ipc_namespace is created/removed
as you mentioned. I think namespaces should be linked each other for it
in the end....



> > 
> > BTW, have you ever tested this patch? If you don't have any test environment
> > for memory hotplug code, then I'll check it. :-)
> 
> Well, I tested it but not in "real configuration": what I did is that I 
> changed the status by hand under sysfs to offline. I also changed 
> remove_memory() in mm/memory_hotplug.c in the following way (instead of 
> returninf EINVAL):
> 1) decrease the total_ram pages
> 2) call memory_notify(MEM_OFFLINE, NULL)
> 
> and checked that the msgmni was recomputed.

You can also online again after offline by writing sysfs.

> But sure, if you are candidate to test it, that would be great!

Ok. I'll check it too.
Bye.

-- 
Yasunori Goto 


