Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbZA2PqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbZA2PqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZA2PqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:46:15 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:63844 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZA2PqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:46:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QKEhb6EZNRkIZhgRrBlv7z8Qry2lxmTMo+KkAqArheZNXWdTAmYcfbVrH6m/CMznJ8
         gVdPhnRFGWnUZs6gUInkvz+YfwkFVMbjffq9/+8jk940MG/6QhhMqOWTbdVD4JrsuW0T
         Yxl1rqEHsdja2fURWJimx6Z0Grxjfjt0gzC/0=
MIME-Version: 1.0
In-Reply-To: <20090129072938.2761a6ed@infradead.org>
References: <1233242110-5422-1-git-send-email-tom.leiming@gmail.com>
	 <20090129072938.2761a6ed@infradead.org>
Date: Thu, 29 Jan 2009 23:46:13 +0800
Message-ID: <d82e647a0901290746r6dadd5c0v6091e9d2b8175596@mail.gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done
From: Ming Lei <tom.leiming@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: kay.sievers@vrfy.org, greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/29 Arjan van de Ven <arjan@infradead.org>:
>> @@ -396,9 +396,9 @@ void __init prepare_namespace(void)
>>       if ((ROOT_DEV == 0) && root_wait) {
>>               printk(KERN_INFO "Waiting for root device %s...\n",
>>                       saved_root_name);
>> -             while (driver_probe_done() != 0 ||
>> -                     (ROOT_DEV = name_to_dev_t(saved_root_name))
>> == 0)
>> -                     msleep(100);
>> +             ROOT_DEV = name_to_dev_t(saved_root_name);
>> +             if (ROOT_DEV)
>> +                     driver_probe_wait_done();
>>       }
>>
>
> Hi,
>
> another comment:
>
> this is not equivalent
>
> you turned "wait until all probing is done OR until the device exists"
> into "wait until all probing is done"... which might be several seconds
> longer!

Yes, you are right. I will consider how to fix the problem.
Thanks.

>



-- 
Lei Ming
