Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbYFEK4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbYFEK4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 06:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYFEK4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 06:56:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:32503 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbYFEK4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 06:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ltBwKfmTXxrGtQFcxP9j8/rtkGYQz5B8MmP04wPjh1J3hZxxjYV3Ckb+xoJ7x7a7bf
         xYbYLffcXQ3LoxfDARi0d1bovysjou8iaD13SWEMEhgG5vFIbXJroQxCpEC/saAXxU9Z
         GVaGxdFZFj8MHNp/3phFPDZjLKJaguOqlKJoA=
Message-ID: <2f11576a0806050356ua1d86fo3a46863d21f195f5@mail.gmail.com>
Date: Thu, 5 Jun 2008 19:56:32 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH] introduce task cgroup (#task restrictioon for prevent fork bomb by cgroup)
Cc: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       "Li Zefan" <lizf@cn.fujitsu.com>, "Paul Menage" <menage@google.com>
In-Reply-To: <20080605142320.cdc8b21a.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080605142320.cdc8b21a.nishimura@mxp.nes.nec.co.jp>
X-Google-Sender-Auth: ef3a1ab01f83f428
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishimura-san,

Thanks good point out.

>> +#include <linux/res_counter.h>
> I don't think it's needed.
> Or, are you planning to implement this feature by using res_counter?

your are right.
my early version use res_counter, but it isn't used currently.


>> +     spin_lock(&taskcg->lock);
>> +     if (max_tasks < taskcg->nr_tasks)
>> +             return -EBUSY;
> need spin_unlock().

Yes, of cource.
I'll fix it.

Thanks!
