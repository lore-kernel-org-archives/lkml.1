Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0BSMXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 07:23:55 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:38402 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0BSMXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 07:23:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mUy9tjEr0R9KsodkDmyzaKW9HA76+xVoBSN7YECz8BqwBcR1Fz6vhbzP39JoFbM1fw
         fTCGq/sS98A8dJpLrAOpnod++mblvtJUYtXv9WAjeJtEtZ7Em8XrfF7uCICEF2wP+PWg
         WkxjclLG6J7CF5OLfFyfIe58AieBLEuXCqbek=
MIME-Version: 1.0
In-Reply-To: <b6fcc0a1002190402y7aeef6bana21ad7d54a32777a@mail.gmail.com>
References: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
	 <b6fcc0a1002190344s75ecfcf6y625591a0fa8e9869@mail.gmail.com>
	 <628d1651002190357q1b17cf76o6585ce957d610ed8@mail.gmail.com>
	 <b6fcc0a1002190402y7aeef6bana21ad7d54a32777a@mail.gmail.com>
Date: Fri, 19 Feb 2010 20:23:53 +0800
Message-ID: <628d1651002190423s4590bbc5x2eeff6792619f591@mail.gmail.com>
Subject: Re: [PATCH] LSM: add static to security_ops variable
From: wzt wzt <wzt.wzt@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, jmorris@namei.org,
       eparis@parisplace.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not a barrier, it's garbage. Once you know the adress security_ops
> ended up at, you simply write to it.

How to find the security_ops address if the variable is static? Would
you please make an example?

> Not that easily, but they still can.
That's why i suggest to make the variable to static, if you had wrote
a rootkit, you will find that in kernel 2.4.x, there are many many
rootkits, but in kernel 2.6.x, rootkit became fewer. Not all the
kernel driver writers can master this method to find the variable's
address.

The patch also delete the secondary_ops variable.

On Fri, Feb 19, 2010 at 8:02 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Fri, Feb 19, 2010 at 1:57 PM, wzt wzt <wzt.wzt@gmail.com> wrote:
>> Maybe, but The attackers will use a complicated way to find the
>> security_ops address, it's a barrier to attackers.
>
> It's not a barrier, it's garbage. Once you know the adress security_ops
> ended up at, you simply write to it.
>
>> LSM is security framework,  we don't want the attackers can easily
>> to break it.
>
> LSM doesn't protect kernel from kernel.
>
>> Just like the sys_call_table variable in kernel 2.4.x(global and
>> writeable), evil drivers can extern the variable,  then replace the
>> Sys_X functions.
>
> Not that easily, but they still can.
>
