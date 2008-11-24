Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYKXPVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYKXPVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYKXPU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:20:56 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:41092 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbYKXPUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:20:54 -0500
Message-ID: <492AC64E.9080800@fr.ibm.com>
Date: Mon, 24 Nov 2008 16:20:46 +0100
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>,
       David Miller <davem@davemloft.net>,
       Linux Containers <containers@lists.osdl.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: [patch 1/1][RFC]Handle uevent per namespace
References: <492A86FA.5080804@fr.ibm.com> <ac3eb2510811240714l76b15469lea541bb4badd328@mail.gmail.com>
In-Reply-To: <ac3eb2510811240714l76b15469lea541bb4badd328@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Mon, Nov 24, 2008 at 11:50, Daniel Lezcano <dlezcano@fr.ibm.com> wrote:
> 
>  struct kobject {
>  	const char		*name;
>  	struct list_head	entry;
> @@ -63,6 +65,9 @@ struct kobject {
>  	struct kset		*kset;
>  	struct kobj_type	*ktype;
>  	struct sysfs_dirent	*sd;
> +#ifdef CONFIG_NET
> +	struct net              *net;
> +#endif
>  	struct kref		kref;
>  	unsigned int state_initialized:1;
>  	unsigned int state_in_sysfs:1;
> 
> We cannot do that. Network specific stuff does not belong into
> kobjects. Kobjects are not in any way subsystem specific, and we need
> to keep it that way.

That makes sense :)

Is there a way to follow up from the kobject, the netdev associated with 
it ? I mean in the function kobject_uevent_env, how can I check the 
event is related to a network device and retrieve the struct net_device 
from it ?

Thanks.
  -- Daniel

