Return-Path: <linux-kernel-owner+w=401wt.eu-S1762163AbYGBEX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163AbYGBEX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYGBEX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:23:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:29026 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYGBEXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BsnBBg5eMTc4QUegORrjYI9eZq+qZ60pRWZEO9yYKoQmyr17PgDwPtFbAi3gsJfZ0c
         DSxYSE46ku+RiFR6N2re6VYMBYZXjqDoIDSp/iMS4A81WxKEO45XOudhgLYTtC0iFlj/
         v4tjpDbEH4oibjDW6shJjcN+nz3Tl/sgKeos4=
Message-ID: <863e9df20807012122u45f7d8dfmc4d11513b19aeadc@mail.gmail.com>
Date: Wed, 2 Jul 2008 09:52:59 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: next-0630: sparc64: build failed
Cc: "David Miller" <davem@davemloft.net>,
       "Alexander Beregalov" <a.beregalov@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, sparclinux@vger.kernel.org,
       rostedt@goodmis.org
In-Reply-To: <20080701200344.GA4896@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807010825t7ea2eb44oda3f08dc007c40a2@mail.gmail.com>
	 <20080701154648.GA31057@elte.hu> <486A7C19.5080905@gmail.com>
	 <20080701200344.GA4896@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2008 at 1:33 AM, Ingo Molnar <mingo@elte.hu> wrote:
> hm, mcount is the facility - so it makes sense to have that defined.
> Here you basically hide CONFIG_MCOUNT:
>
>> -ifeq ($(CONFIG_MCOUNT),y)
>> -  KBUILD_CFLAGS += -pg
>> +ifneq ($(CONFIG_FTRACE),y)
>> +ifeq ($(CONFIG_STACK_DEBUG),y)
>> +KBUILD_CFLAGS += -pg
>> +endif
>>  endif

Even with CONFIG_MCOUNT we'd have to do something like this to prevent
duplicate -pg flags (I hope there's a prettier way of writing this):

ifneq ($(CONFIG_FTRACE),y)
ifeq ($(CONFIG_MCOUNT),y)
KBUILD_CFLAGS += -pg
endif
endif

> via two conditions. I'm not sure that's a win and i found CONFIG_MCOUNT
> a logical switch - but it's David's call.

Ok, but it really doesn't allow end user to switch between anything
through any menu. It gets selected via:

config MCOUNT
        bool
        depends on STACK_DEBUG || FTRACE
        default y


I was attempting to decouple MCOUNT and STACK_DEBUG, which
incidentally made MCOUNT useless.

--
Regards,
Abhishek Sagar
