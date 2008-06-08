Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYFHSDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYFHSDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 14:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYFHSDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 14:03:36 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:2944 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbYFHSDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 14:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bZWyzbxtHh/d7KBcXKenNfeUnyZte4ZwICJGWVROWZ3jPW60Pgyt513IpXWpR3xyoz
         TgtEDWhEY5XURaFLCmN8km9KF8sMcbkxMNnqnwt3Vf4Pax6Q1uf1TipcH9MEOhdpsHUq
         PgsnaK1KWVyZAKZnVwZgdEDn+aKbHJdm69YQU=
Date: Sun, 8 Jun 2008 21:59:21 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: RuoMu Hu <huruomu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Create proc entry under /proc/sys/kernel
Message-ID: <20080608175921.GA4794@martell.zuzino.mipt.ru>
References: <484B91B9.5060204@gmail.com> <20080608111842.GA12240@martell.zuzino.mipt.ru> <484C1A99.7070109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484C1A99.7070109@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 01:44:57AM +0800, RuoMu Hu wrote:
> Alexey Dobriyan wrote:
>> On Sun, Jun 08, 2008 at 04:00:57PM +0800, RuoMu Hu wrote:
>>   
>>> Is it possible to create a proc entry under /proc/sys/kernel directly by 
>>> create_proc_read_entry in the way shown below?
>>>     
>>
>> No longer.
>>
>>   
>>> test_pde = create_proc_read_entry("/proc/sys/kernel/test", 0, NULL,
>>>                                    test_read_proc, NULL);
>>> if (test_pde == NULL) {
>>>    printk(KERN_ERR "Failed to create the test proc file.\n");
>>>    return -ENOMEM;
>>> }
>>>
>>> I'm using this in my kernel module but create_proc_read_entry always 
>>> returns fail, while there's no problem creating proc entries directly 
>>> under /proc.  The kernel source I'm building my kernel module against is 
>>> 2.6.25.4.
>>>     
>>
>> Use register_sysctl_table() for sysctls.
>>   
>
> Thank you for your hint, it really helped me.
>
> Another question: Is it possible to add an entry under /proc/sys/kernel by 
> register_sysctl_table() without modifying kernel source (adding an entry to 
> the kern_table[] array in kernel/sysctl.c)?

Yes.

grep for register_sysctl_table and you'll see how.

