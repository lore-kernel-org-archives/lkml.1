Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYAOIIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYAOIIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 03:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYAOIIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 03:08:44 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53128 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYAOIIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 03:08:43 -0500
Date: Tue, 15 Jan 2008 17:07:38 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Nadia.Derbey@bull.net
Subject: Re: [RFC PATCH 4/4] [RESEND] Recomputing msgmni on memory add / remove
Cc: akmp@linux-foundation.org, linux-kernel@vger.kernel.org,
       matthltc@us.ibm.com
In-Reply-To: <20080114155602.855698000@bull.net>
References: <20080114155402.690906000@bull.net> <20080114155602.855698000@bull.net>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080115164440.6DBB.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Nadia-san.

> @@ -118,6 +122,10 @@ struct ipc_namespace {
>  	size_t		shm_ctlall;
>  	int		shm_ctlmni;
>  	int		shm_tot;
> +
> +#ifdef CONFIG_MEMORY_HOTPLUG
> +	struct notifier_block ipc_memory_hotplug;
> +#endif
>  };

I'm sorry, but I don't see why each ipc namespace must have each callbacks
of memory hotplug.
I prefer only one callback for each subsystem, not for each namespace.
In addition, the recompute_msgmni() calculation looks very similar for
all ipc namespace.
Or do you wish each ipc namespace have different callback for the future?



BTW, have you ever tested this patch? If you don't have any test environment
for memory hotplug code, then I'll check it. :-)

Bye.

-- 
Yasunori Goto 


