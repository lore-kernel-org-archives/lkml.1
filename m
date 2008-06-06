Return-Path: <linux-kernel-owner+w=401wt.eu-S1764226AbYFFGoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764226AbYFFGoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYFFGoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:44:13 -0400
Received: from mx1.melware.net ([78.47.171.162]:55853 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbYFFGoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:44:12 -0400
Date: Fri, 6 Jun 2008 08:44:08 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn divas: fix proc creation
In-Reply-To: <20080606061744.GB4977@martell.zuzino.mipt.ru>
Message-ID: <alpine.DEB.0.99.0806060842360.7260@k10.melware.de>
References: <20080530233445.GB7358@martell.zuzino.mipt.ru>
 <alpine.DEB.0.99.0806051221380.30590@k10.melware.de>
 <20080606061744.GB4977@martell.zuzino.mipt.ru>
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008, Alexey Dobriyan wrote:
> On Thu, Jun 05, 2008 at 12:25:06PM +0200, Armin Schindler wrote:
>> On Sat, 31 May 2008, Alexey Dobriyan wrote:
>>> 1. creating proc entry and not saving pointer to PDE and checking it
>>>   is not going to work.
>>
>> I don't know where you found this. I have look even in older versions, but
>> the pointer divas_proc_entry is set by proc_create(). The patch to
>> divasproc.c is wrong, it exists from the beginning of the driver.
>> (2.6.25.4 doesn't contain the bug you describe).
>
> Check mainline kernel, namely, 2.6.26-rc5.

Ah, okay. So someone removed the pointer between 2.6.25 and 2.6.26 then.
In that case your patch is correct of course.

Armin

>>> --- a/drivers/isdn/hardware/eicon/divasproc.c
>>> +++ b/drivers/isdn/hardware/eicon/divasproc.c
>>> @@ -125,8 +125,8 @@ static const struct file_operations divas_fops = {
>>>
>>> int create_divas_proc(void)
>>> {
>>> -	proc_create(divas_proc_name, S_IFREG | S_IRUGO, proc_net_eicon,
>>> -		    &divas_fops);
>>> +	divas_proc_entry = proc_create(divas_proc_name, S_IFREG | S_IRUGO,
>>> +					proc_net_eicon, &divas_fops);
>>> 	if (!divas_proc_entry)
>>> 		return (0);
>
