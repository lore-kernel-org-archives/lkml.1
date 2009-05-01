Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbZEAMik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbZEAMik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759072AbZEAMiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:38:16 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51493 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbZEAMiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:38:15 -0400
Message-ID: <49FAED34.5000701@monstr.eu>
Date: Fri, 01 May 2009 14:38:12 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/27] asm-generic: add a NOMMU uaccess.h
References: <cover.1241105648.git.arnd@arndb.de> <45b4644e80c27b9d042b3960e3d99f0d444e0d92.1241105648.git.arnd@arndb.de> <c1a198be0904302337x714621d8xc4685a634c5cf222@mail.gmail.com> <200905011436.05204.arnd@arndb.de>
In-Reply-To: <200905011436.05204.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 01 May 2009, Michal Simek wrote:
>>> +#ifndef __put_user
>>> +#define __put_user(x, ptr)                             \
>>> +({                                                     \
>>> +       int __pu_err = 0;                               \
>>> +       typeof(*(ptr)) __pu_val = (x);                  \
>>> +       switch (sizeof (*(ptr))) {                      \
>>> +       case 1:                                         \
>>> +       case 2:                                         \
>>> +       case 4:                                         \
>>> +               *(ptr) = (__pu_val);                    \
>>> +               break;                                  \
>>> +       case 8:                                         \
>>> +               memcpy(ptr, &__pu_val, sizeof (*(ptr)));\
>>
>> potential cast problem
> 
> Yes, I'm looking into this already, probably will do something
> based on the s390 code, which seems to do this correctly.
> 
>>> +#define put_user(x, ptr) (                             \
>>> +       access_ok(VERIFY_WRITE, ptr, sizeof (*ptr)) ?   \
>>> +               __put_user(x, ptr) :                    \
>>> +               -EFAULT)
>>
>> IMHO write it as inline function with type checking.
> 
> Unfortunately, this doesn't work because of the callin
> conventions: __put_user needs to know the type of ptr,
> so it has to be a macro.

yes, I am looking on it too.

Michal

> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
