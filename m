Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbZA2Pfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbZA2Pfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZA2PfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:35:19 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:56258 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbZA2PfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:35:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gn4CeMK8xGtlXgYQOR+15/iBUp72Pc1frXc7U+ltYPGX3HIGPQ5popCxl9AReCgRoH
         cxNfjAGirIMVzp8Un0j5uKE4MGt4eEldnUnvBCDazHEcHK/YhD4/llYk2iKfuEii/viz
         W5SJzWKEAUkZHyLyr6Ffwz5S1fnGXZ8fCn1lI=
MIME-Version: 1.0
In-Reply-To: <20090129072543.1302344c@infradead.org>
References: <1233242110-5422-1-git-send-email-tom.leiming@gmail.com>
	 <20090129072543.1302344c@infradead.org>
Date: Thu, 29 Jan 2009 23:35:14 +0800
Message-ID: <d82e647a0901290735p6cdfd80bw520a47aa3e73aa80@mail.gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done
From: Ming Lei <tom.leiming@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: kay.sievers@vrfy.org, greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/29 Arjan van de Ven <arjan@infradead.org>:
> On Thu, 29 Jan 2009 23:15:10 +0800
> tom.leiming@gmail.com wrote:
>
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> This patch renames driver_probe_done to driver_probe_wait_done,
>> and make it wait on condition variable of probe done to remove
>> polling for it in fs initialization.
>>
>
> I do not see where you add the wake_up() for waking up the wait queue...
> .... are you sure this is going to work ?

really_probe always wake up the queue of probe_waitqueue,
but no one pend on it. This patch adds the waitting on the queue.

static int really_probe(struct device *dev, struct device_driver *drv)
{
...
done:
        atomic_dec(&probe_count);
        wake_up(&probe_waitqueue);
        return ret;
£ý

>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>



-- 
Lei Ming
