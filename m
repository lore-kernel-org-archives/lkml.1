Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbYKSRhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbYKSRhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 12:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYKSRhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 12:37:40 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:32059 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbYKSRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 12:37:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DshIDaMEiAXBOFHHcdseJc/1eb0DMCM14ltcx+uAXs8rMU0tFccvUuGNxIUB2MXpZW
         xC71bcsVff+jf/7c//DHVyx2/Sjtah+CNnhCIjyeLNffkAiRGEq4feYjDuRS66HjUwY6
         4escIlTSrQTq9zv6OxpJ/QIgMXIb4d5cVutdg=
Message-ID: <91b13c310811190937ob9eddal28ef0d69ed32445c@mail.gmail.com>
Date: Thu, 20 Nov 2008 01:37:36 +0800
From: "rae l" <crquan@gmail.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH] kobject_add: use constant strings directly as fmt strings
Cc: "Greg KH" <gregkh@suse.de>, "Jens Axboe" <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <ac3eb2510811190900k62b1333aj9816e462601b4d0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227110059-12529-1-git-send-email-crquan@gmail.com>
	 <20081119155736.GA5072@suse.de>
	 <91b13c310811190817s31522a0et744ca7df2782cf27@mail.gmail.com>
	 <ac3eb2510811190900k62b1333aj9816e462601b4d0c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 1:00 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> Not that we should be able to measure it, but it should save some
> cycles parsing the format character and retrieving the string pointer
> from the stack, yes.

I'm sure it does work, one another as:

*** drivers/net/iseries_veth.c:
veth_probe_one[1088]           if (0 != kobject_add(&port->kobject,
&dev->dev.kobj, "veth_port"))

>> so if the string is constant, why not use it directly as the fmt string?
>
> It should be fine for strings, where you can be sure they can never
> contain a '%', sure.
And I have searched all places kobject_add called, only these two
places in block/blk-sysfs.c
and block/elevator.c have constant strings. So this patch is the whole
kobject_add constant string
optmization patch.

>
> Thanks,
> Kay

-- 
Cheng Renquan, Shenzhen, China
Fred Allen  - "An associate producer is the only guy in Hollywood who
will associate with a producer."
