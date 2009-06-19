Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbZFSNOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbZFSNOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZFSNOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:14:18 -0400
Received: from mail-yx0-f177.google.com ([209.85.210.177]:48923 "EHLO
	mail-yx0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZFSNOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=f+BenkLCHqojws1dzsjR/433t5089Hw3Oyh44qInJ7aM9R2ayye6YOAiA7GX7fFmUT
         UXDTVJVhHPqBQp2PVAV0Rb6jDYzZpvV3DTQq+r8sktvCfPan5k3fiUl22VGwvwBbjskd
         3uaaSrNePLvdVxobhnaf17JkN5JzwOETQUB3g=
MIME-Version: 1.0
In-Reply-To: <200906190854.13052.rgetz@blackfin.uclinux.org>
References: <8bd0f97a0906180824y17a00110i57565aee16207e5@mail.gmail.com> 
	<200906191508.06537.rusty@rustcorp.com.au> <200906190854.13052.rgetz@blackfin.uclinux.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 19 Jun 2009 09:14:00 -0400
Message-ID: <8bd0f97a0906190614x2ed27fcdrb59ea339eb45ba82@mail.gmail.com>
Subject: Re: module version magic and arches with symbol prefixes
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 08:54, Robin Getz wrote:
> On Fri 19 Jun 2009 01:38, Rusty Russell pondered:
>> On Fri, 19 Jun 2009 12:54:44 am Mike Frysinger wrote:
>> > the current check_modstruct_version() does this:
>> > {
>> >     const unsigned long *crc;
>> >
>> >     if (!find_symbol("module_layout", NULL, &crc, true, false))
>> >         BUG();
>> >     return check_version(sechdrs, versindex, "module_layout", mod, crc);
>> > }
>> > the trouble here is that it looks for a literal "module_layout" symbol
>> > and for ports that have symbol prefixes (a quick check shows Blackfin
>> > & h8300), this aint going to work.
>>
>> MODULE_SYMBOL_PREFIX is the fix for this, ie:
>>
>>       if (!find_symbol(MODULE_SYMBOL_PREFIX "module_layout), ...
>>
>> > also, using BUG() here seems pretty damn harsh.  wouldnt it make more
>> > sense to do something like:
>> >     if (WARN_ON(!find_symbol("module_layout", NULL, &crc, true, false)))
>> >         return 0;
>> > this way the module is simply not loaded rather than killing the kernel
>>
>> No, it means the kernel didn't build properly.
>
> Or a module didn't build properly.

nah, when i talked to you earlier i was wrong -- this find_symbol() is
looking up the symbol in the kernel, not in the module.  the lookup of
the symbol in the requested module actually works.
-mike
