Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab0BSNUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 08:20:06 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:55561 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0BSNUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 08:20:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=H9iQlDvoZ6Z/jYrCd4Ydbq7HJgIjSpgy1IZamDfVp95ONAfIichCwGO27tTmJmWNez
         aDmWoOaPdVVYwXr0y7qCG45QkaxAWyTvu0/yZhOaFNUsWS3UuKIex9pPsIZo8SYJ7mRV
         Sch4PN735T5rcSI9idqPbSG4kT8L81fkFOYUE=
MIME-Version: 1.0
In-Reply-To: <b6fcc0a1002190427k735dc6a8ha88cb79b4d333c3e@mail.gmail.com>
References: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
	 <b6fcc0a1002190344s75ecfcf6y625591a0fa8e9869@mail.gmail.com>
	 <628d1651002190357q1b17cf76o6585ce957d610ed8@mail.gmail.com>
	 <b6fcc0a1002190402y7aeef6bana21ad7d54a32777a@mail.gmail.com>
	 <628d1651002190423s4590bbc5x2eeff6792619f591@mail.gmail.com>
	 <b6fcc0a1002190427k735dc6a8ha88cb79b4d333c3e@mail.gmail.com>
Date: Fri, 19 Feb 2010 21:14:31 +0800
Message-ID: <628d1651002190514h18aa8783ubb86c3e76835eb3c@mail.gmail.com>
Subject: Re: [PATCH] LSM: add static to security_ops variable
From: wzt wzt <wzt.wzt@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, jmorris@namei.org,
       eparis@parisplace.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

security_ops is not static, so you can find the address with kallsysm,
but you can try secondary_ops:
static struct security_operations *secondary_ops = NULL;

cat /proc/kallsysm|grep secondary_ops

On Fri, Feb 19, 2010 at 8:27 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Fri, Feb 19, 2010 at 2:23 PM, wzt wzt <wzt.wzt@gmail.com> wrote:
>>> It's not a barrier, it's garbage. Once you know the adress security_ops
>>> ended up at, you simply write to it.
>>
>> How to find the security_ops address if the variable is static? Would
>> you please make an example?
>
> See /proc/kallsyms .
>
>>> Not that easily, but they still can.
>> That's why i suggest to make the variable to static, if you had wrote
>> a rootkit, you will find that in kernel 2.4.x, there are many many
>> rootkits, but in kernel 2.6.x, rootkit became fewer. Not all the
>> kernel driver writers can master this method to find the variable's
>> address.
>
> Please.
>
>> The patch also delete the secondary_ops variable.
>
