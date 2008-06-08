Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYFHRpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYFHRpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 13:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYFHRpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 13:45:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:1141 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYFHRpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 13:45:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=agqikWhsWKlKAvvDQLc5NM7KC+BIznbXJP/u9J4oLUdnUR/gMm2ucvoXihrxb0B7V7
         /GO8l8a6Hp0qAYaIcmBpbv2ts/nSqVY2UCj7nZPMCiBAQlbt7IKF564YGsgcZZ//uBx4
         /P+Vm8MW6J9pTzVviqGQtTHH1T9IEw4/Ltb6c=
Message-ID: <484C1A99.7070109@gmail.com>
Date: Mon, 09 Jun 2008 01:44:57 +0800
From: RuoMu Hu <huruomu@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Create proc entry under /proc/sys/kernel
References: <484B91B9.5060204@gmail.com> <20080608111842.GA12240@martell.zuzino.mipt.ru>
In-Reply-To: <20080608111842.GA12240@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Sun, Jun 08, 2008 at 04:00:57PM +0800, RuoMu Hu wrote:
>   
>> Is it possible to create a proc entry under /proc/sys/kernel directly by 
>> create_proc_read_entry in the way shown below?
>>     
>
> No longer.
>
>   
>> test_pde = create_proc_read_entry("/proc/sys/kernel/test", 0, NULL,
>>                                    test_read_proc, NULL);
>> if (test_pde == NULL) {
>>    printk(KERN_ERR "Failed to create the test proc file.\n");
>>    return -ENOMEM;
>> }
>>
>> I'm using this in my kernel module but create_proc_read_entry always 
>> returns fail, while there's no problem creating proc entries directly under 
>> /proc.  The kernel source I'm building my kernel module against is 
>> 2.6.25.4.
>>     
>
> Use register_sysctl_table() for sysctls.
>   

Thank you for your hint, it really helped me.

Another question: Is it possible to add an entry under /proc/sys/kernel 
by register_sysctl_table() without modifying kernel source (adding an 
entry to the kern_table[] array in kernel/sysctl.c)?

Best regards,
Romu
