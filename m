Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbYFCMIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbYFCMIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 08:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbYFCMIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 08:08:34 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:56981 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbYFCMId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 08:08:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kbfTq81HbvlaxHYpke0aBhBN+nxcdYaMXKkBwG8JfE6drp93gWWNPql6a79eFHJ7k+dH+zAfysNZsfCihiyMDkV/CJTEnzTk4JFfYBYTDLN6zYB1WQBD8skQIHcZl7tqJTT5duZGfXBhgv25ZFm6s+HAYiD7AcK8Uh7+y+/u9KQ=
Message-ID: <ca0148c30806030508g23bf0f52r2ac847fcc7cb7cbe@mail.gmail.com>
Date: Tue, 3 Jun 2008 15:08:32 +0300
From: "Matti Linnanvuori" <mattilinn@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: [PATCH v1.2.26] wan: new driver retina
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <m3lk1rhio4.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ca0148c30805280342l39ffe387rf4c670b17804f99d@mail.gmail.com>
	 <m3prr6obkz.fsf@maximus.localdomain>
	 <ca0148c30805300552u7eb5da43tfc75127a2e819d1@mail.gmail.com>
	 <m3lk1rhio4.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/30 Krzysztof Halasa <khc@pm.waw.pl>:
> "Matti Linnanvuori" <mattilinn@gmail.com> writes:
>
>> I would not like to change a legacy driver much.
>
> But this is a new driver, right? I guess the SIOCDEVPRIVATEs will go
> at some point so the change can't be really avoided.

I posted retina-1.2.29.patch that does not have SIOCDEVPRIVATEs at
http://groups.google.com/group/pcidriver/files.

>>>> +static int fepci_char_open(struct inode *inode, struct file *filp)
>>>> +{
>>>> +     unsigned int minor = MINOR(inode->i_rdev);
>>>> +     if (unlikely(minor >= find_cnt || card_privates[minor].pci_dev == NULL))
>>>> +             return -ENXIO;
>>>> +     filp->f_op = &fepci_char_fops;
>>>> +     if (unlikely(!try_module_get(THIS_MODULE)))
>>>> +             return -EBUSY;
>>>
>>> That won't work race-free, use owner field.
>>
>> You mean the f_op assignment? I have removed that.
>
> Actually I meant try_module_get() from within the driver, for example
> your module may get unloaded while in this function, before this
> try_module_get(), and that would be fatal. If you set the owner field
> the reference count will be incremented by the caller first.

I added the owner field setting to the above mentioned patch.
