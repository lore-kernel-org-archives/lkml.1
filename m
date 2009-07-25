Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZGYVlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZGYVlO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 17:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZGYVlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 17:41:13 -0400
Received: from mail-pz0-f172.google.com ([209.85.222.172]:42102 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZGYVlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 17:41:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=i9gUr1XAjDF49UeY7+1EAbdYmaz4LYq+GYJ/7xPxelg4gG31GYMp2f8vB7HZUOnOXs
         F2UkBy5pzSKKSqgU5/Gz2huqfXpeqtnIL+8zNQyNQ/O+8Cuucxanu5fwJxig1ecL8/M1
         kf3OtvZc3dftBo1c5gWLMNpcD6TmTywkuwLKk=
References: <1248275919-3296-1-git-send-email-manuel.lauss@gmail.com> <20090725191037.GE14062@dtor-d630.eng.vmware.com> <200907252139.30674.rjw@sisk.pl> <200907252221.45407.elendil@planet.nl>
Message-Id: <6090EAB2-5A74-4324-9B0C-1A70A871D293@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Frans Pop <elendil@planet.nl>
In-Reply-To: <200907252221.45407.elendil@planet.nl>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7A341)
Mime-Version: 1.0 (iPhone Mail 7A341)
Subject: Re: [PATCH V2] au1xmmc: dev_pm_ops conversion
Date: Sat, 25 Jul 2009 14:41:03 -0700
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Manuel Lauss <manuel.lauss@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
       Manuel Lauss <manuel.lauss@gmail.com>,
       Arnaud Faucher <arnaud.faucher@gmail.com>, Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 25, 2009, at 1:21 PM, Frans Pop <elendil@planet.nl> wrote:

> On Saturday 25 July 2009, Rafael J. Wysocki wrote:
>>>>> Was suspend to disk tested? It requires freeze()/thaw().
>>>>
>>>> Is that a regression introduced by this patch then? If so, many
>>>> more of the recent dev_pm_ops conversion patches would need to be
>>>> revisited.
>>
>> Yes, they would.  In general, you'd probably want to do something  
>> like
>> this:
>>
>> static struct dev_pm_ops au1xmmc_pmops = {
>>         .resume         = au1xmmc_resume,
>>         .suspend                = au1xmmc_suspend,
>>         .freeze         = au1xmmc_resume,
>>         .thaw           = au1xmmc_suspend,
>>         .restore                = au1xmmc_resume,
>>         .poweroff       = au1xmmc_suspend,
>> };
>>
>> but in this particular case it's probably better to define separate
>> callbacks for .freeze() and .thaw() at least.
>>
>> During hibernation we call .freeze() and .thaw() before and after
>> creating the image, respectively, and then .poweroff() is called  
>> right
>> after the image has been saved.  During resume .freeze() is called
>> after the image has been loaded and before the control goes to the
>> image kernel, which then calls .restore().
>
> Yes, I see that in drivers/base/platform.c (legacy) .suspend  
> resp. .resume
> also got called for those cases?
> Ouch :-(
>
> I've added others who've submitted dev_pm_ops patches in CC.
>
>> I'll fix up the floppy and hp-wmi patches.
>
> Note that those are already in mainline, as is pcspkr.
>


Pcspkr should be fine as is since we just want to shut it off and with  
s2d it will happen automatically when we power down.

-- 
Dmitry

