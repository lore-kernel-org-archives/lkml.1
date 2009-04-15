Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbZDOOw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbZDOOw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZDOOwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:52:15 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:39174 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZDOOwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:52:14 -0400
Message-ID: <49E5F457.5090602@csr.com>
Date: Wed, 15 Apr 2009 15:51:03 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: device_for_each_child() before device_add() doesn't work
References: <49E4BFD0.2020302@csr.com> <20090414165905.GA25645@kroah.com> <49E4D2FF.8090906@csr.com> <20090415051548.GC3462@kroah.com>
In-Reply-To: <20090415051548.GC3462@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2009 14:51:02.0980 (UTC) FILETIME=[99089840:01C9BDD9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> So the problem is for the first device being added, right?  Can't you
> just have a flag for this?

It's trivial to fix in the UWB stack.

>> This address must be assigned during initialization and during normal 
>> operation and in the past we didn't need to special case the address 
>> assignment during initialization.
> 
> Does the patch below fix the problem for you?

Yes.

>  drivers/base/core.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1142,6 +1142,9 @@ int device_for_each_child(struct device 
>  	struct device *child;
>  	int error = 0;
>  
> +	if (!parent->p)
> +		return 0;
> +
>  	klist_iter_init(&parent->p->klist_children, &i);
>  	while ((child = next_device(&i)) && !error)
>  		error = fn(child, data);
> 
> 

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
